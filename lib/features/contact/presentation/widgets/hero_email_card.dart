import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

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
    const availabilityGreen = AppColors.teal;
    final l10n = AppLocalizations.of(context)!;

    final ctaSend = FilledButton.icon(
      onPressed: onSendEmail,
      icon: const Icon(Icons.send_rounded, size: 16),
      label: Text(l10n.contactSendEmailBtn),
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontSize: AppTypography.label,
          fontWeight: FontWeight.w900,
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
        foregroundColor: context.onSurface,
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: AppAlpha.border)
              : AppColors.ink300,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        textStyle: const TextStyle(
          fontSize: AppTypography.label,
          fontWeight: FontWeight.w800,
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
            label: Text(l10n.uiComposeInquiry),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              textStyle: const TextStyle(
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          )
        : null;

    final actionRow = Wrap(
      spacing: 8,
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
            color: context.adaptiveAccentText(accent),
            fontSize: AppTypography.label,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: SelectableText(
            email,
            style: TextStyle(
              color: context.onSurface,
              fontSize: isDesktop ? 22 : 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: availabilityGreen.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(Icons.check_circle_rounded,
                  color: context.adaptiveAccentText(availabilityGreen),
                  size: 14),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n.contactReplyWindow,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.mutedText,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ],
    );

    final card = Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.xl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.container),
        gradient: isDark
            ? RadialGradient(
                center: Alignment.bottomRight,
                radius: 2.2,
                colors: [
                  accent.withValues(alpha: 0.16),
                  context.cardGlass,
                ],
              )
            : null,
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.5 : 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: isDark ? 0.14 : 0.06),
            blurRadius: 32,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
        ],
      ),
      child: isDesktop && MediaQuery.textScalerOf(context).scale(1) <= 1.2
          ? Row(
              children: [
                Expanded(child: emailBlock),
                const SizedBox(width: AppSpacing.lg),
                Flexible(child: actionRow),
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
