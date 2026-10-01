import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/shared/widget/app_toast.dart';
import 'package:profile/shared/widget/primary_button.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/intro/widget/quick_profile_sheet.dart';

class IntroCtaRow extends StatelessWidget {
  final bool isDark;
  final VoidCallback onViewWork;
  final VoidCallback onDownloadResume;
  final VoidCallback onContactMe;

  const IntroCtaRow({
    super.key,
    required this.isDark,
    required this.onViewWork,
    required this.onDownloadResume,
    required this.onContactMe,
  });

  static const String _kEmail = 'alhyariabdallh@gmail.com';

  Future<void> _copyEmail(BuildContext context) async {
    SoundService.instance.playClick();
    await Clipboard.setData(const ClipboardData(text: _kEmail));
    if (!context.mounted) return;
    final loc = AppLocalizations.of(context)!;
    AppToast.showGlass(
      context,
      message: loc.emailCopied(_kEmail),
    );
  }

  Widget _ghostButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    Color? color,
  }) {
    final effectiveColor =
        color ?? (isDark ? Colors.white70 : AppColors.slate700);
    final borderColor =
        isDark ? (color ?? Colors.white24) : (color ?? AppColors.slate300);

    // One node named once: the label merges into the button, which keeps
    // its focus state; the visible text is left unsaid.
    return MergeSemantics(
      child: Semantics(
        button: true,
        label: label,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: ExcludeSemantics(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppTypography.small,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveColor,
            side: BorderSide(color: borderColor, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ),
    );
  }

  /// Quiet text-link action for the secondary row under the main pair.
  Widget _linkButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return MergeSemantics(
      child: Semantics(
        button: true,
        label: label,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 15),
          label: ExcludeSemantics(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppTypography.caption,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: isDark ? Colors.white70 : AppColors.slate600,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final loc = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            PrimaryButton(
              label: loc.viewMyWork,
              isPill: true,
              letterSpacing: 1.2,
              onPressed: () {
                SoundService.instance.playClick();
                onViewWork();
              },
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: _ghostButton(
                label: loc.downloadResume,
                icon: Icons.download_rounded,
                color: accent,
                isDark: isDark,
                onPressed: () {
                  SoundService.instance.playClick();
                  onDownloadResume();
                },
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: _ghostButton(
                label: loc.contactMe,
                icon: Icons.send_rounded,
                color: accent,
                isDark: isDark,
                onPressed: () {
                  SoundService.instance.playClick();
                  onContactMe();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: 8,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _linkButton(
              label: loc.copyEmail,
              icon: Icons.content_copy_rounded,
              onPressed: () => _copyEmail(context),
            ),
            _linkButton(
              label: loc.quickProfile,
              icon: Icons.badge_rounded,
              onPressed: () => showQuickProfile(
                context,
                onDownloadResume: onDownloadResume,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
