import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'case_study_prose.dart';

/// Data for a single ordered step inside a `TechnicalChapter`.
class TechStep {
  const TechStep({
    required this.layer,
    required this.title,
    required this.body,
  });
  final String layer;
  final String title;
  final String body;
}

/// A numbered technical chapter — kicker + ordered `TechStep` cards.
class TechnicalChapter extends StatelessWidget {
  const TechnicalChapter({
    super.key,
    required this.number,
    required this.title,
    required this.steps,
  });

  final String number;
  final String title;
  final List<TechStep> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionKicker(number: number, label: title),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(steps.length, (i) {
          final s = steps[i];
          return Padding(
            padding: EdgeInsets.only(
                bottom: i == steps.length - 1 ? 0 : AppSpacing.md),
            child: TechStepCard(index: i + 1, step: s),
          );
        }),
      ],
    );
  }
}

class TechStepCard extends StatelessWidget {
  const TechStepCard({super.key, required this.index, required this.step});

  final int index;
  final TechStep step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final accentText = context.adaptiveAccentText(scheme.primary);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              index.toString().padLeft(2, '0'),
              style: TextStyle(
                fontFamily: AppTypography.displayFont,
                fontSize: AppTypography.subtitle,
                fontWeight: FontWeight.w900,
                color: accentText,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.layer,
                  style: TextStyle(
                    fontSize: AppTypography.editorial,
                    letterSpacing: 2.4,
                    fontWeight: FontWeight.w800,
                    color: accentText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  step.title,
                  style: TextStyle(
                    fontSize: AppTypography.subtitle,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  step.body,
                  style: TextStyle(
                    fontSize: AppTypography.body,
                    height: 1.55,
                    color: scheme.onSurface.withValues(alpha: 0.82),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
