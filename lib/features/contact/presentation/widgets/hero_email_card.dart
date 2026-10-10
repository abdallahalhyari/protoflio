import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/widgets/magnetic_pull.dart';

class HeroEmailCard extends StatefulWidget {
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
  State<HeroEmailCard> createState() => _HeroEmailCardState();
}

class _HeroEmailCardState extends State<HeroEmailCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = scheme.primary;
    final isDark = context.isDarkMode;
    const availabilityGreen = AppColors.teal;
    final l10n = AppLocalizations.of(context)!;

    final ctaSend = MagneticPull(
      maxPull: 6.0,
      child: FilledButton.icon(
        onPressed: widget.onSendEmail,
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
          elevation: _hover ? 4 : 1,
        ),
      ),
    );

    final ctaCopy = MagneticPull(
      maxPull: 6.0,
      child: OutlinedButton.icon(
        onPressed: widget.onCopyEmail,
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
      ),
    );

    final ctaCompose = widget.onComposeInquiry != null
        ? MagneticPull(
            maxPull: 6.0,
            child: FilledButton.tonalIcon(
              onPressed: widget.onComposeInquiry,
              icon: const Icon(Icons.edit_note_rounded, size: 16),
              label: Text(l10n.uiComposeInquiry),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                textStyle: const TextStyle(
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w800,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
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
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.16 : 0.10),
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: accent.withValues(alpha: isDark ? 0.35 : 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mark_email_read_rounded,
                  size: 12,
                  color: context.adaptiveAccentText(accent),
                ),
                const SizedBox(width: 5),
                Text(
                  l10n.contactHeroEyebrow,
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    color: context.adaptiveAccentText(accent),
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: SelectableText(
            widget.email,
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              color: context.onSurface,
              fontSize: widget.isDesktop
                  ? AppTypography.heading - 4
                  : AppTypography.lead,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
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
              child: Icon(
                Icons.check_circle_rounded,
                color: context.adaptiveAccentText(availabilityGreen),
                size: 14,
              ),
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

    final contentBody =
        widget.isDesktop && MediaQuery.textScalerOf(context).scale(1) <= 1.2
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
              );

    final card = AnimatedContainer(
      duration: AppMotion.cardHover,
      curve: AppMotion.emphasized,
      padding: EdgeInsets.all(widget.isDesktop ? AppSpacing.xl : AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.container),
        gradient: isDark
            ? RadialGradient(
                center: Alignment.bottomRight,
                radius: _hover ? 2.5 : 2.0,
                colors: [
                  accent.withValues(alpha: _hover ? 0.22 : 0.15),
                  context.cardGlass,
                ],
              )
            : null,
        border: Border.all(
          color: accent.withValues(
              alpha: _hover ? (isDark ? 0.75 : 0.55) : (isDark ? 0.45 : 0.3)),
          width: _hover ? 1.6 : 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(
                alpha:
                    _hover ? (isDark ? 0.22 : 0.12) : (isDark ? 0.12 : 0.05)),
            blurRadius: _hover ? 36 : 24,
            offset: const Offset(0, 8),
            spreadRadius: _hover ? 3 : 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.signalLight,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.goldSoft : AppColors.goldDeep,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.tealLight : AppColors.tealDeep,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'DISPATCH PROTOCOL // 06 · DIRECT REACH-OUT',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontSize: AppTypography.label - 2,
                    fontWeight: FontWeight.w800,
                    color: context.adaptiveAccentText(accent),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.tealLight : AppColors.tealDeep,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppColors.tealLight : AppColors.tealDeep)
                          .withValues(alpha: 0.6),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'AVAILABLE',
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontSize: AppTypography.label - 2,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.tealLight : AppColors.tealDeep,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            thickness: 0.8,
            color: context.glassBorderStrong.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          contentBody,
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: RepaintBoundary(child: card),
    );
  }
}
