import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Calls `window.portfolioReady()` from `web/index.html`. Looked up rather
/// than bound with `@JS`, so a page without the hook (an old cached
/// index.html) can't throw here; its own first-frame fallback hides the
/// boot screen instead.
void announceAppReady() {
  final hook = globalContext['portfolioReady'];
  if (hook.isA<JSFunction>()) (hook as JSFunction).callAsFunction();
}

/// Whether `web/index.html`'s boot screen is still over the app.
bool isBootScreenUp() {
  final doc = globalContext['document'];
  if (doc.isUndefinedOrNull) return false;
  final el = (doc as JSObject)
      .callMethod<JSAny?>('getElementById'.toJS, 'boot-loader'.toJS);
  return !el.isUndefinedOrNull;
}
