import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Left column of the cover: availability, the name, the role and one
/// plain sentence about the work. Everything a recruiter screens for sits
/// above the buttons. Plays its slice of the cover's entrance via [reveal].
class HeroStatement extends StatelessWidget {
  final Size size;
  final bool isDark;
  final bool isWide;
  final Animation<double> reveal;

  const HeroStatement({
    super.key,
    required this.size,
    required this.isDark,
    required this.isWide,
    required this.reveal,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final nameSize = isWide
        ? (size.width * 0.085).clamp(72.0, 116.0)
        : (size.width * 0.17).clamp(52.0, 84.0);

    final nameStyle = TextStyle(
      fontFamily: AppTypography.wordmarkFont,
      fontSize: nameSize,
      fontWeight: FontWeight.w900,
      height: 0.98,
      color: context.onSurface,
    );

    Widget nameLine(String text, Color? color) => FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(text, style: nameStyle.copyWith(color: color)),
        );

    final gap = isWide ? AppSpacing.lg : AppSpacing.md;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroStep(
          animation: reveal,
          begin: 0.02,
          end: 0.38,
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: scheme.primary.withValues(alpha: isDark ? 0.4 : 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.teal,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'PRINCIPAL MOBILE SYSTEMS ARCHITECT · STAFF LEAD',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                      color: context.adaptiveAccentText(scheme.primary),
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Semantics(
          header: true,
          headingLevel: 1,
          label: l10n.semanticTitle,
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroStep(
                animation: reveal,
                begin: 0.08,
                end: 0.5,
                mask: true,
                child: nameLine('ABDALLAH', null),
              ),
              HeroStep(
                animation: reveal,
                begin: 0.2,
                end: 0.62,
                mask: true,
                child: nameLine('ALHYARI', scheme.primary),
              ),
            ],
          ),
        ),
        SizedBox(height: gap),
        HeroStep(
          animation: reveal,
          begin: 0.42,
          end: 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.introTagline,
                style: TextStyle(
                  fontSize:
                      isWide ? AppTypography.heading : AppTypography.title,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: context.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Text(
                  l10n.introPitch2,
                  style: TextStyle(
                    fontSize: AppTypography.lead,
                    height: 1.6,
                    color: context.onSurface
                        .withValues(alpha: isDark ? 0.82 : 0.78),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
