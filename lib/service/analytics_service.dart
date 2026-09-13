import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around `FirebaseAnalytics` that swallows exceptions so
/// callers don't have to bury every call site in try/catch. Analytics is
/// non-critical — offline browsers or blocked SDKs must never break the
/// UI thread.
class Analytics {
  Analytics._();

  static bool _enabled = true;

  /// Toggles all analytics calls into no-ops.
  static void setEnabled(bool enabled) => _enabled = enabled;

  /// Fire-and-forget screen view.
  static void screen(String name, {String? className}) {
    if (!_enabled) return;
    try {
      FirebaseAnalytics.instance
          .logScreenView(screenName: name, screenClass: className);
    } catch (e) {
      if (kDebugMode) debugPrint('Analytics.screen failed: $e');
    }
  }

  /// Fire-and-forget custom event.
  static void event(String name, {Map<String, Object>? params}) {
    if (!_enabled) return;
    try {
      FirebaseAnalytics.instance.logEvent(name: name, parameters: params);
    } catch (e) {
      if (kDebugMode) debugPrint('Analytics.event $name failed: $e');
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
