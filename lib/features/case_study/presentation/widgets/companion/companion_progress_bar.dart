import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

class CompanionTopReadingProgressBar extends StatelessWidget {
  const CompanionTopReadingProgressBar({
    super.key,
    required this.progress,
    required this.isDark,
  });

  final double progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Positioned(
      key: const Key('case_study_reading_progress_bar'),
      top: 0,
      left: 0,
      right: 0,
      height: 3.5,
      child: ColoredBox(
        color: context.progressTrack,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final filledWidth = constraints.maxWidth * progress;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: AppMotion.micro,
                  curve: Curves.easeOut,
                  width: filledWidth,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.teal,
                        scheme.primary,
                        AppColors.teal,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: context.glowAccent(AppColors.teal),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: context.glowSecondary(AppColors.teal),
                        blurRadius: 12,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                ),
                if (progress > 0.01 && progress < 0.995)
                  Positioned(
                    left: (filledWidth - 3)
                        .clamp(0.0, math.max(0.0, constraints.maxWidth - 6)),
                    top: -1.2,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.teal,
                            blurRadius: 6,
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
