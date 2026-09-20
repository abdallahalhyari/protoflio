import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../../service/sound_service.dart';
import '../../../../theme/tokens.dart';
import '../primary_button.dart';

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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: AppMotion.toast,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.accentGreen, size: 16),
            const SizedBox(width: 8),
            Text(loc.emailCopied(_kEmail)),
          ],
        ),
      ),
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
    final borderColor = isDark
        ? (color ?? Colors.white24)
        : (color ?? AppColors.slate300);

    return Semantics(
      button: true,
      label: label,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: AppTypography.small,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final loc = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        PrimaryButton(
          label: loc.viewMyWork,
          isPill: true,
          onPressed: () {
            SoundService.instance.playClick();
            onViewWork();
          },
        ),
        _ghostButton(
          label: loc.downloadResume,
          icon: Icons.download_rounded,
          isDark: isDark,
          onPressed: () {
            SoundService.instance.playClick();
            onDownloadResume();
          },
        ),
        _ghostButton(
          label: loc.contactMe,
          icon: Icons.send_rounded,
          color: accent,
          isDark: isDark,
          onPressed: () {
            SoundService.instance.playClick();
            onContactMe();
          },
        ),
        _ghostButton(
          label: loc.copyEmail,
          icon: Icons.content_copy_rounded,
          isDark: isDark,
          onPressed: () => _copyEmail(context),
        ),
      ],
    );
  }
}
