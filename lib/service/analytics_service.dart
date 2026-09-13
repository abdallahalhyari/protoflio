import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around `FirebaseAnalytics` that swallows exceptions so
/// callers don't have to bury every call site in try/catch. Analytics is
/// non-critical — offline browsers or blocked SDKs must never break the
/// UI thread.
class Analytics {
  Analytics._();

  static bool _enabled = true;

  // Debug-mode log spam guard — Firebase not being initialized in tests
  // or during offline dev floods the console with the same error per call.
  // Only surface the first `_kMaxDebugLogs` failures per session.
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

  /// Toggles all analytics calls into no-ops.
  static void setEnabled(bool enabled) => _enabled = enabled;

  /// Fire-and-forget screen view.
  static void screen(String name, {String? className}) {
    if (!_enabled) return;
    try {
      FirebaseAnalytics.instance
          .logScreenView(screenName: name, screenClass: className);
    } catch (e) {
      _logIfDebug('Analytics.screen failed: $e');
    }
  }

  /// Fire-and-forget custom event.
  static void event(String name, {Map<String, Object>? params}) {
    if (!_enabled) return;
    try {
      FirebaseAnalytics.instance.logEvent(name: name, parameters: params);
    } catch (e) {
      _logIfDebug('Analytics.event $name failed: $e');
    }
  }

  // Semantic wrappers — self-documenting call sites at CTAs.
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
