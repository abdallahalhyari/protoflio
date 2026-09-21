import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

class HeroEmailCard extends StatelessWidget {
  final String email;
  final bool isDesktop;
  final VoidCallback onSendEmail;
  final VoidCallback onCopyEmail;
  final VoidCallback? onComposeInquiry;

  const HeroEmailCard({
    super.key,
    required this.email,
    required this.isDesktop,
    required this.onSendEmail,
    required this.onCopyEmail,
    this.onComposeInquiry,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final isDark = context.isDarkMode;
    final accentSoft = accent.withValues(alpha: 0.35);
    const availabilityGreen = AppColors.accentGreen;
    final l10n = AppLocalizations.of(context)!;

    final ctaSend = FilledButton.icon(
      onPressed: onSendEmail,
      icon: const Icon(Icons.send_rounded, size: 16),
      label: Text(l10n.contactSendEmailBtn),
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        textStyle: const TextStyle(
          fontSize: AppTypography.overline,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );

    final ctaCopy = OutlinedButton.icon(
      onPressed: onCopyEmail,
      icon: const Icon(Icons.content_copy_rounded, size: 14),
      label: Text(l10n.contactCopyAddressBtn),
      style: OutlinedButton.styleFrom(
        foregroundColor: isDark ? Colors.white : AppColors.slate900,
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.35)
              : AppColors.slate300,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(
          fontSize: AppTypography.captionSm,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );

    final ctaCompose = onComposeInquiry != null
        ? FilledButton.tonalIcon(
            onPressed: onComposeInquiry,
            icon: const Icon(Icons.edit_note_rounded, size: 16),
            label: const Text('COMPOSE INQUIRY'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              textStyle: const TextStyle(
                fontSize: AppTypography.captionSm,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          )
        : null;

    final actionRow = Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        ctaSend,
        if (ctaCompose != null) ctaCompose,
        ctaCopy,
      ],
    );

    final emailBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.contactHeroEyebrow,
          style: TextStyle(
            color: isDark ? accentSoft : accent,
            fontSize: AppTypography.editorial,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: SelectableText(
            email,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.slate900,
              fontSize: isDesktop ? 22 : 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: availabilityGreen, size: 14),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                l10n.contactReplyWindow,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.7)
                      : AppColors.slate500,
                  fontSize: AppTypography.overline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final card = Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.45 : 0.35),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.10 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: emailBlock),
                const SizedBox(width: AppSpacing.lg),
                actionRow,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                emailBlock,
                const SizedBox(height: AppSpacing.md),
                actionRow,
              ],
            ),
    );

    return RepaintBoundary(child: card);
  }
}
