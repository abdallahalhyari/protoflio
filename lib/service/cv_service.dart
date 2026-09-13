import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'analytics_service.dart';
import 'sound_service.dart';

/// Central CV/resume download entry point.
///
/// On Flutter web the CV is served from `web/cv.pdf` at the site root, so a
/// bare relative URI resolves against the current origin. On iOS/Android
/// that relative URI has no origin and `launchUrl` silently no-ops — we
/// fall back to the production absolute URL so the mobile "Download CV"
/// buttons actually surface the PDF.
class CvService {
  CvService._();

  /// Absolute production URL. Replace the domain once the live host is
  /// pinned — everything else (mobile fallback + snackbar copy) picks it
  /// up automatically.
  static const String publicUrl = 'https://alhyari.portfolio.com/cv.pdf';

  /// Web-local relative path (served from `web/cv.pdf`).
  static const String webRelativePath = 'cv.pdf';

  /// Launch the CV in the platform's external viewer. Plays a click,
  /// fires the resume analytics event, and surfaces a SnackBar if the
  /// launcher rejects the URI.
  static Future<void> open(BuildContext context) async {
    SoundService.instance.playClick();
    Analytics.ctaResume();
    final uri = Uri.parse(kIsWeb ? webRelativePath : publicUrl);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Could not open resume — visit $publicUrl'),
        ),
      );
    }
  }
}
