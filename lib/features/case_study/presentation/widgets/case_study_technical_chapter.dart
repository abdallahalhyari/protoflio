import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_prose.dart';

/// One facet of a `TechnicalChapter`: the layer it sits in, what was done
/// there and how.
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

/// A technical chapter as a spec list: heading, then one entry per facet.
/// The facets (hardware, security, resilience…) aren't an order, so they
/// aren't numbered.
class TechnicalChapter extends StatelessWidget {
  const TechnicalChapter({
    super.key,
    required this.title,
    required this.steps,
  });

  final String title;
  final List<TechStep> steps;

  @override
  Widget build(BuildContext context) {
    // An English chapter, heading included.
    return EnglishContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChapterHeading(title),
          const SizedBox(height: AppSpacing.sm),
          for (int i = 0; i < steps.length; i++)
            TechStepEntry(step: steps[i], isFirst: i == 0),
        ],
      ),
    );
  }
}

class TechStepEntry extends StatelessWidget {
  const TechStepEntry({super.key, required this.step, this.isFirst = false});

  final TechStep step;

  /// The chapter heading's rule already sits above the first entry.
  final bool isFirst;

  /// Room for the layer as a column of its own.
  static const double _sideLabelMinWidth = 560;
  static const double _labelColumn = 120;

  @override
  Widget build(BuildContext context) {
    final layer = Text(
      step.layer,
      style: TextStyle(
        fontSize: AppTypography.label + 1,
        fontWeight: FontWeight.w600,
        height: 1.6,
        color: context.mutedText,
      ),
    );
    final detail = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          step.title,
          style: TextStyle(
            fontSize: AppTypography.lead,
            fontWeight: FontWeight.w700,
            height: 1.35,
            color: context.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          step.body,
          style: TextStyle(
            fontSize: AppTypography.body,
            height: 1.6,
            color: context.onSurface.withValues(alpha: 0.85),
          ),
        ),
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: isFirst
          ? null
          : BoxDecoration(
              border: Border(top: BorderSide(color: context.divider)),
            ),
      child: LayoutBuilder(
        builder: (context, c) => c.maxWidth >= _sideLabelMinWidth
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: _labelColumn, child: layer),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: detail),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  layer,
                  const SizedBox(height: 2),
                  detail,
                ],
              ),
      ),
    );
  }
}
