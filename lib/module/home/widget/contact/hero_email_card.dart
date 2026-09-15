import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import '../../../../theme/tokens.dart';

class HeroEmailCard extends StatelessWidget {
  final String email;
  final bool isDark;
  final bool isDesktop;
  final VoidCallback onSendEmail;
  final VoidCallback onCopyEmail;

  const HeroEmailCard({
    super.key,
    required this.email,
    required this.isDark,
    required this.isDesktop,
    required this.onSendEmail,
    required this.onCopyEmail,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
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
          fontSize: 12,
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
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );

    final actionRow = Wrap(spacing: 10, runSpacing: 8, children: [ctaSend, ctaCopy]);

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
          alignment: Alignment.centerLeft,
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
                  fontSize: 12,
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
        color: isDark
            ? Colors.black.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.95),
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
