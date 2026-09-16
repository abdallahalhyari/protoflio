import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';
import '../../model/architecture_topic.dart';
import 'diagram_list.dart';

/// Card container displaying the interactive flowchart tiers for an architecture topic.
class ArchitectureDiagramCard extends StatelessWidget {
  final ArchitectureTopic topic;
  final bool isDesktop;

  const ArchitectureDiagramCard({
    super.key,
    required this.topic,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? scheme.surface.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.14) : AppColors.slate200),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: AppColors.slate900.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ARCHITECTURE FLOWCHART',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: scheme.primary,
                    fontSize: isDesktop ? 11 : 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.slate100,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(color: isDark ? Colors.transparent : AppColors.slate200),
                ),
                child: Text(
                  '${topic.diagramSteps.length} TIERS',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: isDark ? Colors.white70 : AppColors.slate600,
                    fontSize: AppTypography.editorialSm,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DiagramList(topic: topic, scheme: scheme, isDesktop: isDesktop),
        ],
      ),
    );
  }
}
