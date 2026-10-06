import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/core/services/analytics_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_reveal.dart';

/// The whole case study in three lines — challenge, what was built, result
/// — right under the masthead, for readers who decide in seconds whether
/// to go deeper. Links straight to the full outcomes.
class CaseStudyAtAGlance extends StatelessWidget {
  const CaseStudyAtAGlance({
    super.key,
    required this.slug,
    required this.challenge,
    required this.built,
    required this.result,
    required this.outcomesKey,
    required this.isDesktop,
  });

  final String slug;
  final String challenge;
  final String built;
  final String result;
  final GlobalKey outcomesKey;
  final bool isDesktop;

  void _seeOutcomes(BuildContext context) {
    Analytics.event('case_study_glance_outcomes', params: {'study': slug});
    final controller = Scrollable.maybeOf(context)?.widget.controller;
    if (controller == null) return;
    revealCaseStudySection(
      controller,
      outcomesKey,
      reduceMotion: MediaQuery.disableAnimationsOf(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;
    final l10n = AppLocalizations.of(context)!;
    final steps = [
      _Step(
          label: l10n.studyChallenge,
          text: challenge,
          color: context.amberText),
      _Step(label: l10n.studyBuilt, text: built, color: context.indigoText),
      _Step(label: l10n.studyResult, text: result, color: context.greenText),
    ];

    return Semantics(
      container: true,
      label: l10n.studyGlance,
      child: Container(
        key: const Key('case_study_at_a_glance'),
        padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.035)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: scheme.primary.withValues(alpha: isDark ? 0.22 : 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt_rounded,
                    size: 16,
                    color: context.adaptiveAccentText(scheme.primary)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    l10n.studyGlanceKicker,
                    style: TextStyle(
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w900,
                      color: context.mutedText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (isDesktop)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < steps.length; i++) ...[
                      if (i > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md),
                          child: Container(width: 1, color: context.divider),
                        ),
                      Expanded(child: steps[i]),
                    ],
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < steps.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.md),
                    steps[i],
                  ],
                ],
              ),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                key: const Key('case_study_glance_outcomes'),
                onPressed: () => _seeOutcomes(context),
                icon: const Icon(Icons.arrow_downward_rounded, size: 16),
                label: Text(l10n.studySeeOutcomes),
                style: TextButton.styleFrom(
                  foregroundColor: context.adaptiveAccentText(scheme.primary),
                  minimumSize: const Size(44, 44),
                  textStyle: const TextStyle(
                    fontSize: AppTypography.body,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.label, required this.text, required this.color});

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppTypography.label,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: AppTypography.body,
            height: 1.55,
            color: context.onSurface.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
