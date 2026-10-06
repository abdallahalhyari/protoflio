import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:profile/shared/utils/mailto.dart';

class QuickProfileActions extends StatelessWidget {
  final VoidCallback onDownloadResume;
  final VoidCallback onCopySummary;
  final String email;
  final String linkedIn;

  const QuickProfileActions({
    super.key,
    required this.onDownloadResume,
    required this.onCopySummary,
    required this.email,
    required this.linkedIn,
  });

  Future<void> _open(Uri uri, String event) async {
    SoundService.instance.playClick();
    Analytics.event(event);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        FilledButton.icon(
          key: const Key('quick_profile_cv'),
          onPressed: () {
            SoundService.instance.playClick();
            onDownloadResume();
          },
          icon: const Icon(Icons.download_rounded, size: 18),
          label: Text(l10n.introDownloadResume),
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
        ),
        OutlinedButton.icon(
          onPressed: () => _open(mailtoUri(email), 'quick_profile_email'),
          icon: const Icon(Icons.mail_outline_rounded, size: 18),
          label: Text(l10n.quickProfileEmail),
          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
        ),
        OutlinedButton.icon(
          onPressed: () => _open(Uri.parse(linkedIn), 'quick_profile_linkedin'),
          icon: const Icon(Icons.open_in_new_rounded, size: 18),
          label: const Text('LinkedIn'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
        ),
        TextButton.icon(
          key: const Key('quick_profile_copy'),
          onPressed: onCopySummary,
          icon: const Icon(Icons.content_copy_rounded, size: 18),
          label: Text(l10n.quickProfileCopy),
          style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
        ),
      ],
    );
  }
}
