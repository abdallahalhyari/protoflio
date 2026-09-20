import 'package:flutter/material.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';
import 'architecture_simulator_bar.dart';
import 'architecture_telemetry_strip.dart';
import 'diagram_list.dart';

/// Card container displaying the interactive flowchart tiers for an architecture topic.
class ArchitectureDiagramCard extends StatelessWidget {
  final ArchitectureTopic topic;
  final bool isDesktop;
  final int activeStepIndex;
  final ValueChanged<int>? onSelectStep;
  final bool isPlaying;
  final VoidCallback? onPreviousStep;
  final VoidCallback? onNextStep;
  final VoidCallback? onTogglePlay;
  final VoidCallback? onResetStep;
  final VoidCallback? onInspect;

  const ArchitectureDiagramCard({
    super.key,
    required this.topic,
    required this.isDesktop,
    this.activeStepIndex = 0,
    this.onSelectStep,
    this.isPlaying = false,
    this.onPreviousStep,
    this.onNextStep,
    this.onTogglePlay,
    this.onResetStep,
    this.onInspect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final clampedStep = activeStepIndex.clamp(0, topic.diagramSteps.length - 1);
    final activeStepObj = topic.diagramSteps[clampedStep];

    return Semantics(
      container: true,
      label:
          'Architecture flowchart diagram for ${topic.title}: showing ${topic.diagramSteps.length} architectural tiers',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark
              ? scheme.surface.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.90),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : AppColors.slate200),
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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
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
                        fontFamily: AppTypography.monoFont,
                        color: scheme.primary,
                        fontSize: isDesktop
                            ? AppTypography.caption
                            : AppTypography.editorialSm,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  if (onInspect != null) ...[
                    IconButton(
                      tooltip: 'Inspect & Zoom Blueprint',
                      iconSize: 18,
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        SoundService.instance.playClick();
                        onInspect?.call();
                      },
                      icon: Icon(Icons.zoom_in_rounded, color: scheme.primary),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : AppColors.slate100,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      border: Border.all(
                          color:
                              isDark ? Colors.transparent : AppColors.slate200),
                    ),
                    child: Text(
                      '${topic.diagramSteps.length} TIERS',
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        color: isDark ? Colors.white70 : AppColors.slate600,
                        fontSize: AppTypography.editorialSm,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DiagramList(
                topic: topic,
                scheme: scheme,
                isDesktop: isDesktop,
                activeStepIndex: clampedStep,
                onSelectStep: onSelectStep,
                shrinkWrap: true,
              ),
              if (onPreviousStep != null &&
                  onNextStep != null &&
                  onTogglePlay != null &&
                  onResetStep != null) ...[
                const SizedBox(height: 12),
                ArchitectureSimulatorBar(
                  currentStep: clampedStep,
                  totalSteps: topic.diagramSteps.length,
                  isPlaying: isPlaying,
                  stepTitle: activeStepObj.title,
                  accentColor: scheme.primary,
                  isDesktop: isDesktop,
                  onPrevious: onPreviousStep!,
                  onNext: onNextStep!,
                  onTogglePlay: onTogglePlay!,
                  onReset: onResetStep!,
                  onInspect: onInspect,
                ),
                const SizedBox(height: 8),
                ArchitectureTelemetryStrip(
                  step: activeStepObj,
                  accentColor: scheme.primary,
                  isDesktop: isDesktop,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
