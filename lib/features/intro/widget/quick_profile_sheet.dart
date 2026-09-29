import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:profile/features/experience/data/experience_data.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/service/analytics_service.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/shared/util/career_facts.dart';
import 'package:profile/shared/util/mailto.dart';
import 'package:profile/shared/widget/app_toast.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

const String _kEmail = 'alhyariabdallh@gmail.com';
const String _kLinkedIn =
    'https://www.linkedin.com/in/abdallah-alhyari-0294791a0/';
const String _kSite = 'https://alhyari.web.app';

/// The hiring facts a recruiter screens for, on one card: role, years,
/// stack, location, status and the latest roles, with the CV, email,
/// LinkedIn and a plain-text copy for their notes or ATS. Every value comes
/// from strings and data the site already shows elsewhere.
Future<void> showQuickProfile(
  BuildContext context, {
  required VoidCallback onDownloadResume,
}) {
  Analytics.event('quick_profile_open');
  SoundService.instance.playClick();
  final sheet = QuickProfileCard(onDownloadResume: onDownloadResume);
  if (MediaQuery.sizeOf(context).width < AppBreakpoints.tablet) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: context.modalSurface,
      builder: (_) => sheet,
    );
  }
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (ctx) => Dialog(
      backgroundColor: ctx.modalSurface,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: sheet,
      ),
    ),
  );
}

class QuickProfileCard extends StatelessWidget {
  const QuickProfileCard({super.key, required this.onDownloadResume});

  final VoidCallback onDownloadResume;

  static List<(String, String)> _facts(AppLocalizations l10n) => [
        (l10n.quickProfileRole, l10n.introSeniorEngineer),
        (
          l10n.quickProfileExperience,
          l10n.quickProfileYears(CareerFacts.yearsOfExperience()),
        ),
        (l10n.quickProfileStack, l10n.introTechStack),
        (l10n.introBasedIn, l10n.introLocation),
        (
          l10n.introStatus,
          '${l10n.introOpenForRoles} · ${l10n.introAvailableContracts} · '
              '${l10n.introWorkEligibility}',
        ),
      ];

  /// Plain text for a recruiter's notes: no formatting to lose on paste.
  static String summaryText(AppLocalizations l10n) {
    final recent = kExperience
        .take(3)
        .map((e) => '- ${e.role}, ${e.company} (${e.period})')
        .join('\n');
    return [
      'Abdallah Alhyari',
      for (final (label, value) in _facts(l10n)) '$label: $value',
      '${l10n.quickProfileRecent}:',
      recent,
      '${l10n.quickProfileEmail}: $_kEmail',
      'LinkedIn: $_kLinkedIn',
      'Portfolio: $_kSite',
    ].join('\n');
  }

  Future<void> _copySummary(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    SoundService.instance.playClick();
    Analytics.event('quick_profile_copy');
    await Clipboard.setData(ClipboardData(text: summaryText(l10n)));
    if (!context.mounted) return;
    AppToast.showGlass(context, message: l10n.quickProfileCopied);
  }

  Future<void> _open(Uri uri, String event) async {
    SoundService.instance.playClick();
    Analytics.event(event);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final accent = context.adaptiveAccentText(scheme.primary);

    return SingleChildScrollView(
      key: const Key('quick_profile'),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.badge_rounded, size: 20, color: accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.quickProfileTitle,
                  style: const TextStyle(
                    fontSize: AppTypography.title,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.closeTooltip,
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (label, value) in _facts(l10n)) _Fact(label, value),
          _Fact(
            l10n.quickProfileRecent,
            null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final e in kExperience.take(3))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '${e.role} · ${e.company}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: '  ${e.period}',
                          style: TextStyle(color: context.mutedText),
                        ),
                      ]),
                      style: const TextStyle(
                          fontSize: AppTypography.small, height: 1.4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
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
                label: Text(l10n.downloadResume),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _open(mailtoUri(_kEmail), 'quick_profile_email'),
                icon: const Icon(Icons.mail_outline_rounded, size: 18),
                label: Text(l10n.quickProfileEmail),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    _open(Uri.parse(_kLinkedIn), 'quick_profile_linkedin'),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('LinkedIn'),
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
              ),
              TextButton.icon(
                key: const Key('quick_profile_copy'),
                onPressed: () => _copySummary(context),
                icon: const Icon(Icons.content_copy_rounded, size: 18),
                label: Text(l10n.quickProfileCopy),
                style: TextButton.styleFrom(minimumSize: const Size(0, 44)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.label, this.value, {this.child});

  final String label;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.micro,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: 2),
          child ??
              Text(
                value!,
                style: const TextStyle(
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
        ],
      ),
    );
  }
}
