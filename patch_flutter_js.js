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
    fs.writeFileSync(filePath, content, 'utf8');
    console.log(`Successfully patched ${path.basename(filePath)} to disable stale service worker.`);
  } catch (e) {
    console.error(`Error patching ${path.basename(filePath)}:`, e);
  }
}

patchFile(mjsPath);
patchFile(jsPath);
patchBootstrap(bootstrapPath);
