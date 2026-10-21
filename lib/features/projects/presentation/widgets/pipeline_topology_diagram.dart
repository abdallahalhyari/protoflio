import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';

/// A project's pipeline as its stages in order, joined by arrows: a row
/// where they fit, a column on narrow screens.
class PipelineTopologyDiagram extends StatelessWidget {
  final Project project;
  final bool isDesktop;
  final bool isDark;

  const PipelineTopologyDiagram({
    super.key,
    required this.project,
    required this.isDesktop,
    required this.isDark,
    this.showTitle = true,
  });

  /// Off where a heading above already names the diagram (case studies).
  final bool showTitle;

  /// Below this width the stages stack.
  static const double _rowMinWidth = 480;

  @override
  Widget build(BuildContext context) {
    // Keyed on the company, which is stable; project names get rewritten.
    // Only projects with a hand-drawn pipeline are listed — the rest show
    // their own stack, which comes from the project data and so can't drift.
    final pipeline = switch (project.company) {
      'NatHealth' => const [
          'NFC APDU',
          'Keystore JWT',
          'Offline SQLite',
          'WorkManager',
          'HTTPS TPA',
        ],
      'ESKADENIA Software' => const [
          'Feature PKG',
          'MVVM Models',
          'Service Locator',
          'Cache Store',
          'Hospital REST',
        ],
      _ => project.stack.take(5).toList(),
    };

    final line = isDark ? AppColors.tealLight : AppColors.tealDeep;

    Widget stage(String label) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.cardGlass,
            borderRadius: BorderRadius.circular(AppRadius.hairlineWide),
            border: Border.all(color: context.divider),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: context.onSurface.withValues(alpha: 0.9),
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

    return Semantics(
      container: true,
      label:
          'Pipeline architecture for ${project.name}: stages: ${pipeline.join(" to ")}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 10 : 8,
          vertical: showTitle ? 6 : 10,
        ),
        decoration: BoxDecoration(
          color: context.onSurface.withValues(alpha: isDark ? 0.03 : 0.02),
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(color: context.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle) ...[
              Text(
                'Production pipeline topology',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.mutedText,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
            ],
            LayoutBuilder(builder: (context, c) {
              // A row while every stage fits; a column on narrow screens
              // rather than a row that hides stages off the edge.
              if (c.maxWidth < _rowMinWidth) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < pipeline.length; i++) ...[
                      stage(pipeline[i]),
                      if (i < pipeline.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: Icon(Icons.arrow_downward_rounded,
                              size: 14, color: line),
                        ),
                    ],
                  ],
                );
              }
              return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 6,
                children: [
                  for (int i = 0; i < pipeline.length; i++) ...[
                    stage(pipeline[i]),
                    if (i < pipeline.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 14, color: line),
                      ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
