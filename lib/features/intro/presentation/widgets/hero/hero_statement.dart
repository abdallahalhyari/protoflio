import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Left column of the cover: the name, one specific sentence about the
/// work, and when you can hire me. The trace card beside it shows the work;
/// this column only has to say who and when. Plays its slice of the
/// cover's entrance via [reveal].
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
    final compactHeight = isWide && size.height < 940;
    final nameSize = isWide
        ? (size.width * 0.075).clamp(64.0, compactHeight ? 76.0 : 96.0)
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

    final gap = compactHeight
        ? AppSpacing.sm
        : (isWide ? AppSpacing.lg : AppSpacing.md);

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
          child: ConstrainedBox(
            // ~60 characters a line at this size.
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.introSummary,
                  style: TextStyle(
                    fontSize: isWide && !compactHeight
                        ? AppTypography.title
                        : AppTypography.lead,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                    color: context.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.introAvailability,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    height: 1.5,
                    color: context.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
