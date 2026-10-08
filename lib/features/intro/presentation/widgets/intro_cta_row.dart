import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/shared/widgets/app_toast.dart';
import 'package:profile/shared/widgets/primary_button.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/contact/presentation/widgets/vcard_qr_dialog.dart';
import 'package:profile/features/intro/presentation/widgets/quick_profile_sheet.dart';

class IntroCtaRow extends StatelessWidget {
  final bool isDark;
  final VoidCallback onViewWork;
  final VoidCallback onDownloadResume;
  final VoidCallback onContactMe;

  /// Left-align the rows (cover layout) instead of centring them.
  final bool alignStart;

  const IntroCtaRow({
    super.key,
    required this.isDark,
    required this.onViewWork,
    required this.onDownloadResume,
    required this.onContactMe,
    this.alignStart = false,
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
        color ?? (isDark ? Colors.white70 : AppColors.ink700);
    final borderColor =
        isDark ? (color ?? Colors.white24) : (color ?? AppColors.ink300);

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
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
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
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: isDark ? Colors.white70 : AppColors.ink600,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
        ),
      ),
    );
  }

  /// Tinted pill for the two quiet actions under the main buttons.
  Widget _pill(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String semanticsLabel,
    required Color accent,
    required VoidCallback onTap,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.9, minHeight: 40),
      child: Semantics(
        button: true,
        excludeSemantics: true,
        label: semanticsLabel,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              SoundService.instance.playClick();
              onTap();
            },
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: accent.withValues(alpha: isDark ? 0.40 : 0.30),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: isDark ? 0.16 : 0.08),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 15, color: accent),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        color: isDark ? Colors.white : AppColors.ink900,
                      ),
                    ),
                  ],
                ),
              ),
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

    final ctas = <Widget>[
      PrimaryButton(
        label: loc.viewMyWork,
        trailingIcon: Icons.arrow_forward_rounded,
        isPill: true,
        letterSpacing: 0.3,
        onPressed: () {
          SoundService.instance.playClick();
          onViewWork();
        },
      ),
      ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.9, minHeight: 40),
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
    ];
    // Narrow phones: one column at a shared width. Centred in a Wrap the
    // three buttons each took their label's width and stacked unevenly.
    final wrapAlign = alignStart ? WrapAlignment.start : WrapAlignment.center;
    final stackCtas = MediaQuery.sizeOf(context).width < AppBreakpoints.compact;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (stackCtas)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < ctas.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  ctas[i],
                ],
              ],
            ),
          )
        else
          Wrap(
            spacing: 12,
            runSpacing: 10,
            alignment: wrapAlign,
            children: ctas,
          ),
        const SizedBox(height: AppSpacing.smd),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          alignment: wrapAlign,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                  minHeight: 40),
              child: _linkButton(
                label: loc.introDownloadResume,
                icon: Icons.download_rounded,
                onPressed: () {
                  SoundService.instance.playClick();
                  onDownloadResume();
                },
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                  minHeight: 40),
              child: _linkButton(
                label: loc.copyEmail,
                icon: Icons.content_copy_rounded,
                onPressed: () => _copyEmail(context),
              ),
            ),
            _pill(
              context,
              icon: Icons.play_circle_fill_rounded,
              label: '30-second intro',
              semanticsLabel:
                  '30-second introduction video and executive summary',
              accent: accent,
              onTap: () => showQuickProfile(
                context,
                onDownloadResume: onDownloadResume,
              ),
            ),
            _pill(
              context,
              icon: Icons.qr_code_2_rounded,
              label: 'vCard QR',
              semanticsLabel: 'Recruiter vCard QR',
              accent: accent,
              onTap: () => VCardQrDialog.show(context),
            ),
          ],
        ),
      ],
    );
  }
}
