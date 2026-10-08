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
                l10n.introSeniorEngineer,
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
                  l10n.introPitch,
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
