import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/shared/utils/bidi.dart';

/// The tiers of one architecture as a single printed stack: a guilloche
/// teal spine runs through every tier, and each tier carries its latency
/// budget in the end margin. The active tier is marked by a gold contact
/// plate on the spine and a flat ink band, nothing else.
class DiagramList extends StatelessWidget {
  final ArchitectureTopic topic;
  final bool isDesktop;
  final int? activeStepIndex;
  final ValueChanged<int>? onSelectStep;

  const DiagramList({
    super.key,
    required this.topic,
    required this.isDesktop,
    this.activeStepIndex,
    this.onSelectStep,
  });

  @override
  Widget build(BuildContext context) {
    final steps = topic.diagramSteps;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < steps.length; i++)
          _DiagramTier(
            key: ValueKey('tier_${topic.id}_$i'),
            step: steps[i],
            isFirst: i == 0,
            isLast: i == steps.length - 1,
            isActive: activeStepIndex == i,
            isDesktop: isDesktop,
            onTap: onSelectStep != null ? () => onSelectStep!(i) : null,
          ),
      ],
    );
  }
}

class _DiagramTier extends StatefulWidget {
  final DiagramStep step;
  final bool isFirst;
  final bool isLast;
  final bool isActive;
  final bool isDesktop;
  final VoidCallback? onTap;

  const _DiagramTier({
    super.key,
    required this.step,
    required this.isFirst,
    required this.isLast,
    required this.isActive,
    required this.isDesktop,
    this.onTap,
  });

  @override
  State<_DiagramTier> createState() => _DiagramTierState();
}

class _DiagramTierState extends State<_DiagramTier> {
  bool _isHovered = false;

  // Band padding above the layer label; the spine node sits level with it.
  static const double _bandTop = 12;
  static const double _spineWidth = 20;
  static const double _nodeSize = 10;

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    final isActive = widget.isActive;
    final isDesktop = widget.isDesktop;
    final isDark = context.isDarkMode;

    final spine = (isDark ? AppColors.tealLight : AppColors.teal)
        .withValues(alpha: isDark ? 0.45 : 0.55);
    final plate = isDark ? AppColors.goldSoft : AppColors.gold;

    final bandColor = context.onSurface.withValues(
      alpha: isActive ? (isDark ? 0.06 : 0.045) : (_isHovered ? 0.03 : 0.0),
    );

    Widget segment(bool visible) => Container(
          width: 1.5,
          color: visible ? spine : Colors.transparent,
        );

    final node = AnimatedContainer(
      duration: AppMotion.snap,
      width: _nodeSize,
      height: _nodeSize,
      decoration: BoxDecoration(
        color: isActive ? plate : context.cardGlass,
        borderRadius: BorderRadius.circular(
          isActive ? AppRadius.xxs : _nodeSize / 2,
        ),
        border: Border.all(
          color: isActive ? plate : spine,
          width: 1.5,
        ),
      ),
    );

    final budget = step.latencyBudget;

    return Semantics(
      button: widget.onTap != null,
      selected: isActive,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _spineWidth,
              child: Column(
                children: [
                  SizedBox(
                    height: _bandTop + 3,
                    child: segment(!widget.isFirst),
                  ),
                  node,
                  Expanded(child: segment(!widget.isLast)),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: AnimatedContainer(
                    duration: AppMotion.snap,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      12,
                      _bandTop,
                      12,
                      isDesktop ? 14 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: bandColor,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                step.layer,
                                style: TextStyle(
                                  color: context.mutedText,
                                  fontSize: AppTypography.label,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                step.title,
                                style: TextStyle(
                                  color: context.onSurface,
                                  fontSize: isDesktop
                                      ? AppTypography.lead
                                      : AppTypography.body,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ltrContent(context, step.details),
                                style: TextStyle(
                                  color: context.mutedText,
                                  fontSize: isDesktop
                                      ? AppTypography.body
                                      : AppTypography.label,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (budget != null) ...[
                          const SizedBox(width: 16),
                          // A fixed quarter of the row, so figures line up
                          // under the column head and a narrow phone at
                          // large text size wraps instead of overflowing.
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text(
                                ltrAlways(context, budget),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: isActive
                                      ? context.onSurface
                                      : context.mutedText,
                                  fontSize: isDesktop
                                      ? AppTypography.title
                                      : AppTypography.lead,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  height: 1.1,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
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
