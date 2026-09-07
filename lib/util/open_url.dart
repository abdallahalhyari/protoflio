import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Open a URL in the platform's default handler.
/// On failure, shows a SnackBar via ScaffoldMessenger. Silent no-op if
/// context is unmounted.
Future<void> openUrl(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open $url')),
    );
  }
}
