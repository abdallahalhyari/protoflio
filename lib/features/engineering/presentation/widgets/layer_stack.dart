import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/presentation/utils/architecture_labels.dart';
import 'package:profile/l10n/app_localizations.dart';

/// An architecture's layers, top to bottom, on one continuous teal line:
/// teal is the site's colour for order and sequence, and these layers are
/// an order (each depends only on the ones below it, or runs after the
/// one above). Nothing here is selectable; the line carries the reading.
class LayerStack extends StatelessWidget {
  const LayerStack({super.key, required this.topic});

  final ArchitectureTopic topic;

  static const double _spine = 28;
  static const double _node = 11;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final line = context.isDarkMode ? AppColors.tealLight : AppColors.tealDeep;
    final steps = topic.diagramSteps;

    // The layers are written in English, so they read left to right in
    // every language, as the case studies' English chapters do.
    return Semantics(
      container: true,
      label: 'Layers of ${architectureTopicLabel(l10n, topic.title)}, '
          '${l10n.engTiers(steps.length)}',
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < steps.length; i++)
              _LayerRow(
                step: steps[i],
                line: line,
                isFirst: i == 0,
                isLast: i == steps.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _LayerRow extends StatelessWidget {
  const _LayerRow({
    required this.step,
    required this.line,
    required this.isFirst,
    required this.isLast,
  });

  final DiagramStep step;
  final Color line;
  final bool isFirst;
  final bool isLast;

  /// Where the node sits: level with the layer's title line.
  static const double _nodeTop = 24;

  @override
  Widget build(BuildContext context) {
    Widget segment(bool visible) => Center(
          child: Container(
            width: 2,
            color: visible ? line.withValues(alpha: 0.7) : Colors.transparent,
          ),
        );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: LayerStack._spine,
            child: Column(
              children: [
                SizedBox(height: _nodeTop, child: segment(!isFirst)),
                Container(
                  width: LayerStack._node,
                  height: LayerStack._node,
                  decoration: BoxDecoration(
                    color: line,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(child: segment(!isLast)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.layer,
                    style: TextStyle(
                      fontSize: AppTypography.label + 1,
                      height: 1.5,
                      color: context.mutedText,
                    ),
                  ),
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
                    step.details,
                    style: TextStyle(
                      fontSize: AppTypography.body,
                      height: 1.55,
                      color: context.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
