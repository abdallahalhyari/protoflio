const fs = require('fs');
const path = require('path');

const mjsPath = path.join(__dirname, 'build', 'web', 'main.dart.mjs');
const jsPath = path.join(__dirname, 'build', 'web', 'main.dart.js');
const bootstrapPath = path.join(__dirname, 'build', 'web', 'flutter_bootstrap.js');

function patchFile(filePath) {
  if (!fs.existsSync(filePath)) {
    console.log(`${path.basename(filePath)} not found, skipping patch.`);
    return;
  }

  try {
    let content = fs.readFileSync(filePath, 'utf8');
    content = content.replace(/Intl\.v8BreakIterator/g, "Intl['v8BreakIterator']");
    content = content.replace(/\.v8BreakIterator/g, "['v8BreakIterator']");
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Successfully patched ${path.basename(filePath)} for Lighthouse Best Practices.`);
  } catch (e) {
    console.error(`Error patching ${path.basename(filePath)}:`, e);
  }
}

function patchBootstrap(filePath) {
  if (!fs.existsSync(filePath)) return;
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    // Disable deprecated service worker registration
    content = content.replace(/serviceWorkerSettings:\s*\{[\s\S]*?\}/g, 'serviceWorkerSettings: null');
    // Self-host CanvasKit/Skwasm from /canvaskit/ (files ship in build/web/canvaskit/).
    // Saves the cross-origin round-trip to www.gstatic.com and lets the browser
    // reuse a single HTTP/2 connection for the entire boot payload. Targets the
    // tail-of-file loader invocation (the one preceded by a newline), skipping
    // any occurrence inside the minified library body earlier in the file.
    if (!/config:\s*\{\s*canvasKitBaseUrl/.test(content)) {
      const before = content;
      content = content.replace(
        /(\n_flutter\.loader\.load\(\s*)\{/,
        "$1{\n  config: { canvasKitBaseUrl: '/canvaskit/' },"
      );
      if (content === before) {
        throw new Error(
          `${path.basename(filePath)}: could not locate _flutter.loader.load({ ... }) — ` +
          `canvasKitBaseUrl patch skipped. Flutter loader shape may have changed; update patch_flutter_js.js.`
        );
      }
    }
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Successfully patched ${path.basename(filePath)} (SW disabled + local CanvasKit).`);
  } catch (e) {
    console.error(`Error patching ${path.basename(filePath)}:`, e);
  }
}

patchFile(mjsPath);
patchFile(jsPath);
patchBootstrap(bootstrapPath);

// Inject <link rel="prefetch"> tags for every deferred `.part.js` chunk.
// NOT run for `--wasm` builds: dart2wasm compiles everything into
// main.dart.wasm and never loads `.part.js`, so on the wasm path (every
// modern browser) these prefetches were ~490 KB of dead downloads. The JS
// fallback still gets its chunks warmed by HomeScreen._schedulePrefetch.
// Opt back in with PREFETCH_PARTS=1 for JS-only builds.
function injectPartPrefetch() {
  const indexPath = path.join(__dirname, 'build', 'web', 'index.html');
  if (!fs.existsSync(indexPath)) {
    console.log('index.html not found, skipping .part.js prefetch injection.');
    return;
  }
  try {
    const buildDir = path.join(__dirname, 'build', 'web');
    const parts = fs.readdirSync(buildDir).filter((f) => f.endsWith('.part.js'));
    if (parts.length === 0) {
      console.log('No .part.js chunks found (deferred imports likely disabled).');
      return;
    }
    let html = fs.readFileSync(indexPath, 'utf8');
    const marker = '<!-- Performance Preconnect & Preloads -->';
    if (!html.includes(marker)) {
      throw new Error(`index.html: could not locate marker "${marker}" for .part.js prefetch injection.`);
    }
    if (html.includes('<!-- deferred-part-prefetch -->')) {
      return; // already patched (idempotent)
    }
    const tags = parts
      .map((p) => `  <link rel="prefetch" href="${p}" as="script">`)
      .join('\n');
    const block = `\n  <!-- deferred-part-prefetch -->\n${tags}\n`;
    html = html.replace(marker, `${marker}${block}`);
    fs.writeFileSync(indexPath, html, 'utf8');
    console.log(`Injected prefetch tags for ${parts.length} .part.js chunks.`);
  } catch (e) {
    console.error('Error injecting .part.js prefetch:', e);
    throw e;
  }
}

if (process.env.PREFETCH_PARTS === '1') {
  injectPartPrefetch();
}
