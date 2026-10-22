import 'package:flutter/material.dart';
import 'package:profile/core/config/profile_links.dart';
import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/mailto.dart';
import 'package:profile/shared/widgets/primary_button.dart';
import 'package:url_launcher/url_launcher.dart';

/// The cover's three actions, in order of intent: see the work, write to
/// me, take the CV. Everything else (profiles, copy, vCard) lives on
/// About & Contact, so the cover asks for one decision.
class IntroCtaRow extends StatelessWidget {
  final bool isDark;
  final VoidCallback onViewWork;
  final VoidCallback onDownloadResume;

  /// Left-align the rows (cover layout) instead of centring them.
  final bool alignStart;

  const IntroCtaRow({
    super.key,
    required this.isDark,
    required this.onViewWork,
    required this.onDownloadResume,
    this.alignStart = false,
  });

  Future<void> _emailMe() async {
    SoundService.instance.playClick();
    Analytics.ctaEmail();
    await launchUrl(
      mailtoUri(
        ProfileLinks.email,
        subject: '[Inquiry] Senior Mobile Engineering - Abdallah Alhyari',
      ),
      mode: LaunchMode.externalApplication,
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

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final loc = AppLocalizations.of(context)!;

    final ctas = <Widget>[
      // A node of its own, like the two actions after it; otherwise its
      // button role lands on the row and the others read as inside it.
      MergeSemantics(
        child: PrimaryButton(
          label: loc.viewMyWork,
          isPill: true,
          letterSpacing: 0.3,
          onPressed: () {
            SoundService.instance.playClick();
            onViewWork();
          },
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.9, minHeight: 40),
        child: _ghostButton(
          label: loc.introEmailMe,
          icon: Icons.mail_outline_rounded,
          color: accent,
          isDark: isDark,
          onPressed: _emailMe,
        ),
      ),
    ];
    // Narrow phones: one column at a shared width. Centred in a Wrap the
    // buttons each took their label's width and stacked unevenly.
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
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: _linkButton(
            label: loc.introDownloadResume,
            icon: Icons.download_rounded,
            onPressed: () {
              SoundService.instance.playClick();
              onDownloadResume();
            },
          ),
        ),
      ],
    );
  }
}
