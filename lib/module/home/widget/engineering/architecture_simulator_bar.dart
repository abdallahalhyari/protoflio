import 'package:flutter/material.dart';

import '../../../../service/sound_service.dart';
import '../../../../theme/tokens.dart';
import '../directional_icon.dart';
import '../pulsing_dot.dart';

class ArchitectureSimulatorBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final bool isPlaying;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onTogglePlay;
  final VoidCallback onReset;
  final VoidCallback? onInspect;
  final String stepTitle;
  final Color accentColor;
  final bool isDesktop;

  const ArchitectureSimulatorBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.isPlaying,
    required this.onPrevious,
    required this.onNext,
    required this.onTogglePlay,
    required this.onReset,
    this.onInspect,
    required this.stepTitle,
    required this.accentColor,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.md : AppSpacing.sm,
        vertical: isDesktop ? 10 : 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withValues(alpha: 0.45) : AppColors.slate50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Simulator live indicator badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PulsingDot(color: accentColor),
                    const SizedBox(width: 6),
                    Text(
                      'STEP ${currentStep + 1} / $totalSteps',
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        color: accentColor,
                        fontSize: AppTypography.micro,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  stepTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.slate900,
                    fontSize: isDesktop ? 13 : 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Control buttons row
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: 'Previous pipeline stage',
                  child: OutlinedButton.icon(
                    onPressed: currentStep > 0
                        ? () {
                            SoundService.instance.playSelection();
                            onPrevious();
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(68, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const DirIcon(Icons.chevron_left_rounded, size: 16),
                    label: const Text('BACK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: isPlaying
                          ? 'Pause automatic execution'
                          : 'Auto-run pipeline simulation',
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          SoundService.instance.playClick();
                          onTogglePlay();
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(76, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 16,
                          color: accentColor,
                        ),
                        label: Text(
                          isPlaying ? 'PAUSE' : 'AUTO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Tooltip(
                      message: 'Restart pipeline from step 1',
                      child: IconButton.outlined(
                        iconSize: 16,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          SoundService.instance.playClick();
                          onReset();
                        },
                        icon: const Icon(Icons.replay_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Next pipeline stage',
                  child: OutlinedButton.icon(
                    onPressed: currentStep < totalSteps - 1
                        ? () {
                            SoundService.instance.playSelection();
                            onNext();
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(68, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const DirIcon(Icons.chevron_right_rounded, size: 16),
                    label: const Text('NEXT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
