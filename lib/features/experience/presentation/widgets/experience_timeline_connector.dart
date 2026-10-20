import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

/// An animated connector line between sequential experience cards in mobile viewports.
/// Illuminates when either adjacent node is selected.
class ExperienceTimelineConnector extends StatelessWidget {
  final bool isAdjacentSelected;
  final bool isCurrent;

  const ExperienceTimelineConnector({
    super.key,
    this.isAdjacentSelected = false,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isCurrent ? AppColors.tealLight : scheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: SizedBox(
          height: 22,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppMotion.cardHover,
                curve: AppMotion.emphasized,
                width: 2,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isAdjacentSelected
                          ? activeColor.withValues(alpha: isDark ? 0.7 : 0.6)
                          : (isDark ? Colors.white24 : AppColors.ink200),
                      isAdjacentSelected
                          ? activeColor.withValues(alpha: isDark ? 0.9 : 0.8)
                          : (isDark ? Colors.white38 : AppColors.ink300),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: AppMotion.cardHover,
                curve: AppMotion.emphasized,
                width: isAdjacentSelected ? 8 : 6,
                height: isAdjacentSelected ? 8 : 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAdjacentSelected
                      ? activeColor
                      : (isDark ? Colors.white38 : AppColors.ink400),
                  boxShadow: [
                    if (isAdjacentSelected)
                      BoxShadow(
                        color:
                            activeColor.withValues(alpha: isDark ? 0.5 : 0.35),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              AnimatedContainer(
                duration: AppMotion.cardHover,
                curve: AppMotion.emphasized,
                width: 2,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isAdjacentSelected
                          ? activeColor.withValues(alpha: isDark ? 0.9 : 0.8)
                          : (isDark ? Colors.white38 : AppColors.ink300),
                      isAdjacentSelected
                          ? activeColor.withValues(alpha: isDark ? 0.7 : 0.6)
                          : (isDark ? Colors.white24 : AppColors.ink200),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
