import 'package:flutter/foundation.dart';

import 'analytics_service_stub.dart'
    if (dart.library.js_interop) 'analytics_service_web.dart';

/// Public analytics facade. On web, forwards to the lazily-loaded
/// `gtag.js` global (stubbed synchronously by `web/index.html` so calls
/// made before the SDK arrives are queued). On non-web platforms every
/// call is a no-op.
class Analytics {
  Analytics._();

  static bool _enabled = true;
  static const int _kMaxDebugLogs = 3;
  static int _debugLogCount = 0;

  static void _logIfDebug(String msg) {
    if (!kDebugMode) return;
    if (_debugLogCount >= _kMaxDebugLogs) return;
    _debugLogCount++;
    debugPrint(msg);
    if (_debugLogCount == _kMaxDebugLogs) {
      debugPrint('Analytics: further errors silenced this session.');
    }
  }

  static void setEnabled(bool enabled) => _enabled = enabled;

  static void screen(String name, {String? className}) {
    if (!_enabled) return;
    try {
      emitAnalyticsEvent('screen_view', {
        'screen_name': name,
        if (className != null) 'screen_class': className,
      });
    } catch (e) {
      _logIfDebug('Analytics.screen failed: $e');
    }
  }

  static void event(String name, {Map<String, Object>? params}) {
    if (!_enabled) return;
    try {
      emitAnalyticsEvent(name, params);
    } catch (e) {
      _logIfDebug('Analytics.$name failed: $e');
    }
  }

  static void ctaEmail() => event('cta_email');
  static void ctaCvDownload() => event('cta_cv_download');
  static void ctaResume() => event('cta_resume');
  static void ctaPhoneCall() => event('cta_phone_call');
  static void ctaWhatsapp() => event('cta_whatsapp');
  static void ctaLinkedIn() => event('cta_linkedin');
  static void ctaGithub() => event('cta_github');
  static void ctaProject(String company) =>
      event('cta_project_visit', params: {'company': company});
}
