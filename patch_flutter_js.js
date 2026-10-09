const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const mjsPath = path.join(__dirname, 'build', 'web', 'main.dart.mjs');
const jsPath = path.join(__dirname, 'build', 'web', 'main.dart.js');
const bootstrapPath = path.join(__dirname, 'build', 'web', 'flutter_bootstrap.js');
const flutterJsPath = path.join(__dirname, 'build', 'web', 'flutter.js');

function minifyJsFallback(src) {
  let out = "";
  let inString = null;
  let inBlockComment = false;
  let inLineComment = false;
  for (let i = 0; i < src.length; i++) {
    const ch = src[i];
    const next = src[i + 1];
    if (inLineComment) {
      if (ch === "\n") { inLineComment = false; out += "\n"; }
      continue;
    }
    if (inBlockComment) {
      if (ch === "*" && next === "/") { inBlockComment = false; i++; }
      continue;
    }
    if (inString) {
      out += ch;
      if (ch === "\\" && inString) { out += next; i++; continue; }
      if (ch === inString) inString = null;
      continue;
    }
    if (ch === "\"" || ch === "'" || ch === "`") {
      inString = ch;
      out += ch;
      continue;
    }
    if (ch === "/" && next === "/") {
      inLineComment = true;
      i++;
      continue;
    }
    if (ch === "/" && next === "*") {
      inBlockComment = true;
      i++;
      continue;
    }
    out += ch;
  }
  return out
    .split("\n")
    .map(line => line.trim())
    .filter(Boolean)
    .join("\n");
}

function patchMjs(filePath) {
  if (!fs.existsSync(filePath)) return;
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    content = content.replace(/\/\/#\s*sourceMappingURL=.*\.map/g, "");
    fs.writeFileSync(filePath, content, 'utf8');

    // Minify with terser to eliminate Lighthouse unminified-javascript warning
    let minified = false;
    try {
      const terserBin = path.join(__dirname, 'node_modules', '.bin', 'terser');
      const cmd = fs.existsSync(terserBin)
        ? `"${terserBin}" "${filePath}" -o "${filePath}" --module -c -m`
        : `npx --yes terser "${filePath}" -o "${filePath}" --module -c -m`;
      execSync(cmd, { stdio: 'pipe' });
      console.log(`Successfully patched and minified ${path.basename(filePath)} with terser.`);
      minified = true;
    } catch (e) {
      console.warn(`Terser execution fallback: ${e.message}`);
    }

    if (!minified) {
      let code = fs.readFileSync(filePath, 'utf8');
      code = minifyJsFallback(code);
      fs.writeFileSync(filePath, code, 'utf8');
      console.log(`Successfully patched and minified ${path.basename(filePath)} (built-in minifier).`);
    }
  } catch (e) {
    console.error(`Error patching ${path.basename(filePath)}:`, e);
  }
}

function patchBootstrap(filePath) {
  if (!fs.existsSync(filePath)) return;
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    // Remove missing flutter.js.map reference which breaks Lighthouse valid-source-maps audit
    content = content.replace(/\/\/#\s*sourceMappingURL=flutter\.js\.map/g, '');
    // Disable deprecated service worker registration
    content = content.replace(/serviceWorkerSettings:\s*\{[\s\S]*?\}/g, 'serviceWorkerSettings: null');
    // Self-host CanvasKit/Skwasm from /canvaskit/ (files ship in build/web/canvaskit/).
    if (!/config:\s*\{\s*canvasKitBaseUrl/.test(content)) {
      if (/\n_flutter\.loader\.load\(\s*\{/.test(content)) {
        content = content.replace(
          /(\n_flutter\.loader\.load\(\s*)\{/,
          "$1{\n  config: { canvasKitBaseUrl: '/canvaskit/' },"
        );
      } else if (/\n_flutter\.loader\.load\(\s*\)/.test(content)) {
        content = content.replace(
          /(\n_flutter\.loader\.load\(\s*)\)/,
          "$1{\n  config: { canvasKitBaseUrl: '/canvaskit/' },\n  serviceWorkerSettings: null\n})"
        );
      }
    }
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Successfully patched ${path.basename(filePath)} (SW disabled + local CanvasKit + no missing source map).`);
  } catch (e) {
    console.error(`Error patching ${path.basename(filePath)}:`, e);
  }
}

function patchFlutterJs(filePath) {
  if (!fs.existsSync(filePath)) return;
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    content = content.replace(/\/\/#\s*sourceMappingURL=flutter\.js\.map/g, '');
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Successfully patched ${path.basename(filePath)}.`);
  } catch (e) {
    console.error(`Error patching ${path.basename(filePath)}:`, e);
  }
}

function patchMainJs(filePath) {
  if (!fs.existsSync(filePath)) return;
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    content = content.replace(/Intl\.v8BreakIterator/g, "Intl['v8BreakIterator']");
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Successfully patched ${path.basename(filePath)}.`);
  } catch (e) {
    console.error(`Error patching ${path.basename(filePath)}:`, e);
  }
}

patchMjs(mjsPath);
patchMainJs(jsPath);
patchFlutterJs(flutterJsPath);
patchBootstrap(bootstrapPath);

// index.html preloads the engine's fallback Roboto by exact URL. If a Flutter
// upgrade changes that URL, the preload becomes a wasted 62 KB download, so
// fail the build instead of shipping it silently.
function checkRobotoPreload() {
  const wasmPath = path.join(__dirname, 'build', 'web', 'main.dart.wasm');
  const indexPath = path.join(__dirname, 'build', 'web', 'index.html');
  if (!fs.existsSync(wasmPath) || !fs.existsSync(indexPath)) return;
  const m = fs.readFileSync(indexPath, 'utf8')
    .match(/fonts\.gstatic\.com\/s\/(roboto\/[^"]+\.woff2)/);
  if (!m) return;
  if (!fs.readFileSync(wasmPath).includes(Buffer.from(m[1]))) {
    throw new Error(
      `index.html preloads ${m[1]}, but main.dart.wasm no longer references ` +
      'it. Update the Roboto preload URL in web/index.html.'
    );
  }
  console.log('Roboto preload URL matches the engine.');
}
checkRobotoPreload();

// Inject <link rel="prefetch"> tags for every deferred `.part.js` chunk.
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

injectPartPrefetch();
