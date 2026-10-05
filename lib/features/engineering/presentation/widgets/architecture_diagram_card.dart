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
    final accentText = context.adaptiveAccentText(scheme.primary);

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_tree_rounded, size: 15, color: accentText),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.uiArchFlowchart,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: accentText,
                        fontSize: isDesktop
                            ? AppTypography.label
                            : AppTypography.label,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
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
                icon: Icon(Icons.zoom_in_rounded, color: accentText),
              ),
              const SizedBox(width: 4),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isDark
                    ? scheme.primary.withValues(alpha: 0.12)
                    : AppColors.ink100,
                borderRadius: BorderRadius.circular(AppRadius.xs),
                border: Border.all(
                  color: isDark
                      ? scheme.primary.withValues(alpha: 0.3)
                      : AppColors.ink300,
                ),
              ),
              child: Text(
                ltrAlways(context, '${topic.diagramSteps.length} TIERS'),
                style: TextStyle(
                  color: accentText,
                  fontSize: AppTypography.label,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
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
            boxShadow: isDark
                ? const []
                : [
                    BoxShadow(
                      color: AppColors.ink900.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
