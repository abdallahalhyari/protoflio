import 'package:flutter/material.dart';

import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/engineering/domain/entities/architecture_topic.dart';
import 'package:profile/features/engineering/presentation/widgets/diagram_list.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Card container displaying the interactive flowchart tiers for an architecture topic.
class ArchitectureDiagramCard extends StatelessWidget {
  final ArchitectureTopic topic;
  final bool isDesktop;
  final int activeStepIndex;
  final ValueChanged<int>? onSelectStep;
  final VoidCallback? onInspect;

  const ArchitectureDiagramCard({
    super.key,
    required this.topic,
    required this.isDesktop,
    this.activeStepIndex = 0,
    this.onSelectStep,
    this.onInspect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final clampedStep = activeStepIndex.clamp(0, topic.diagramSteps.length - 1);
    final l10n = AppLocalizations.of(context)!;
    final columnHead = TextStyle(
      color: context.mutedText,
      fontSize: AppTypography.label,
      fontWeight: FontWeight.w500,
    );

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Column heads for the stack below: what the rows are, and what
        // the figure in the end margin of each row means. Insets and the
        // 3:1 split mirror a tier's band in [DiagramList].
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 38, end: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  ltrAlways(context, l10n.engTiers(topic.diagramSteps.length)),
                  style: columnHead,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.uiLatencyBudget,
                  textAlign: TextAlign.end,
                  style: columnHead,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        DiagramList(
          topic: topic,
          isDesktop: isDesktop,
          activeStepIndex: clampedStep,
          onSelectStep: onSelectStep,
        ),
        if (onInspect != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () {
                SoundService.instance.playClick();
                onInspect?.call();
              },
              icon: const Icon(Icons.zoom_in_rounded, size: 18),
              label: Text(l10n.engInspectDiagram),
              style: TextButton.styleFrom(
                foregroundColor: context.adaptiveAccentText(scheme.primary),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ],
    );

    return Semantics(
      container: true,
      label:
          'Architecture flowchart diagram for ${topic.title}: showing ${topic.diagramSteps.length} architectural tiers',
      child: RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.cardGlass,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : AppColors.ink200,
            ),
          ),
          child: isDesktop
              ? SingleChildScrollView(
                  primary: false,
                  physics: const ClampingScrollPhysics(),
                  child: content,
                )
              : content,
        ),
      ),
    );
  }
}
