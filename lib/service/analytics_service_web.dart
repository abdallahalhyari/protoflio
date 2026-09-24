import 'dart:js_interop';

/// Forwards to the global `gtag` function set up in `web/index.html`.
/// The stub in the HTML queues calls made before `gtag.js` finishes
/// loading, so we can fire events during Dart boot without waiting on
/// the network.
void emitAnalyticsEvent(String name, Map<String, Object>? params) {
  final payload = params == null
      ? JSObject()
      : (params.map((k, v) => MapEntry(k, _toJs(v))).jsify() as JSObject);
  _gtag('event'.toJS, name.toJS, payload);
}

JSAny? _toJs(Object v) {
  if (v is String) return v.toJS;
  if (v is num) return v.toJS;
  if (v is bool) return v.toJS;
  return v.toString().toJS;
}

@JS('gtag')
external void _gtag(JSString command, JSString name, [JSObject? params]);

/// Reopens the analytics consent banner defined in `web/index.html`.
void reopenAnalyticsConsent() => _resetAnalyticsConsent();

@JS('resetAnalyticsConsent')
external void _resetAnalyticsConsent();
