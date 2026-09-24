/// Non-web analytics sink — the app never actually ships to a mobile
/// store, but tests and desktop builds compile this branch. Everything
/// is a silent no-op.
void emitAnalyticsEvent(String name, Map<String, Object>? params) {}

/// No consent UI off the web.
void reopenAnalyticsConsent() {}
