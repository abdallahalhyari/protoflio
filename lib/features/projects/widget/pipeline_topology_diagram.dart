import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/features/projects/model/project.dart';

/// Renders a horizontal architectural pipeline diagram for a given project,
/// showing key pipeline stages and technology flow.
class PipelineTopologyDiagram extends StatelessWidget {
  final Project project;
  final bool isDesktop;
  final bool isDark;

  const PipelineTopologyDiagram({
    super.key,
    required this.project,
    required this.isDesktop,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    List<String> pipeline;
    if (project.name.contains('NatHealth')) {
      pipeline = const [
        'NFC APDU',
        'Keystore JWT',
        'Offline SQLite',
        'WorkManager',
        'HTTPS TPA'
      ];
    } else if (project.name.contains('ESKADENIA')) {
      pipeline = const [
        'Feature PKG',
        'MVVM Models',
        'Service Locator',
        'Cache Store',
        'Hospital REST'
      ];
    } else if (project.name.contains('FAIS')) {
      pipeline = const [
        'Onboarding UI',
        'Inspection Form',
        'Blob Storage',
        'WorkManager Sync',
        'Core ERP'
      ];
    } else if (project.name.contains('Solutions Now')) {
      pipeline = const [
        'GPS Stream',
        'Native Service',
        'Local DB',
        'Batch Sync',
        'Fleet Command'
      ];
    } else {
      pipeline = project.stack.take(5).toList();
    }

    return Semantics(
      container: true,
      label:
          'Pipeline architecture for ${project.name}: stages: ${pipeline.join(" to ")}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            EdgeInsets.symmetric(horizontal: isDesktop ? 10 : 8, vertical: 6),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.black.withValues(alpha: AppAlpha.border) : AppColors.slate50,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
              color: scheme.primary.withValues(alpha: isDark ? 0.25 : 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreenLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'PRODUCTION PIPELINE TOPOLOGY',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      color: scheme.primary,
                      fontSize: isDesktop ? 9.0 : 8.0,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < pipeline.length; i++) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: scheme.primary
                            .withValues(alpha: isDark ? 0.08 : 0.06),
                        borderRadius: BorderRadius.circular(AppRadius.hairlineWide),
                        border: Border.all(
                            color: scheme.primary
                                .withValues(alpha: isDark ? 0.3 : 0.25)),
                      ),
                      child: Text(
                        pipeline[i].toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.95)
                              : AppColors.slate900,
                          fontSize: isDesktop
                              ? AppTypography.editorialSm
                              : AppTypography.nano,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (i < pipeline.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: isDesktop ? 11 : 9.5,
                          color: scheme.primary.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
