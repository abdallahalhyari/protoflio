import 'package:flutter/material.dart';

import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';

class DiagramList extends StatelessWidget {
  final ArchitectureTopic topic;
  final ColorScheme scheme;
  final bool isDesktop;
  final int? activeStepIndex;
  final ValueChanged<int>? onSelectStep;
  final bool shrinkWrap;

  const DiagramList({
    super.key,
    required this.topic,
    required this.scheme,
    required this.isDesktop,
    this.activeStepIndex,
    this.onSelectStep,
    this.shrinkWrap = false,
  });

  Color _adaptiveAccent(BuildContext context, Color color) {
    if (context.isDarkMode) return color;
    final val = color.toARGB32();
    if (val == 0xFF38BDF8) return AppColors.accentSkyDeep;
    if (val == 0xFF34D399) return AppColors.accentGreenDeep;
    if (val == 0xFF818CF8) return AppColors.accentIndigoDeepText;
    if (val == 0xFF8B5CF6 || val == 0xFFA78BFA) return AppColors.accentVioletDeep;
    if (val == 0xFFF59E0B || val == 0xFFFBBF24) return AppColors.accentAmberDeep;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isShrunk = shrinkWrap || !isDesktop;
    final list = ListView.separated(
      shrinkWrap: isShrunk,
      physics: isShrunk
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      itemCount: topic.diagramSteps.length,
      separatorBuilder: (context, index) {
        final isConnectorActive = activeStepIndex != null && activeStepIndex == index;
        final connColor = isConnectorActive
            ? scheme.primary
            : scheme.primary.withValues(alpha: 0.5);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Center(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: AppMotion.snap,
                  width: isConnectorActive ? 2 : 1,
                  height: 16,
                  color: connColor,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: connColor,
                  size: isConnectorActive ? 18 : 16,
                ),
                const SizedBox(width: 4),
                AnimatedContainer(
                  duration: AppMotion.snap,
                  width: isConnectorActive ? 2 : 1,
                  height: 16,
                  color: connColor,
                ),
              ],
            ),
          ),
        );
      },
      itemBuilder: (context, index) {
        final step = topic.diagramSteps[index];
        final accent = _adaptiveAccent(context, step.color);
        final isActive = activeStepIndex != null && activeStepIndex == index;

        final cardBg = isActive
            ? (isDark
                ? step.color.withValues(alpha: 0.18)
                : step.color.withValues(alpha: 0.10))
            : (isDark
                ? Colors.black.withValues(alpha: 0.35)
                : AppColors.slate50);

        final borderColor = isActive
            ? (isDark ? step.color : accent)
            : (isDark ? step.color : accent).withValues(alpha: isDark ? 0.35 : 0.45);

        return InkWell(
          onTap: onSelectStep != null ? () => onSelectStep!(index) : null,
          borderRadius: BorderRadius.circular(AppRadius.smd),
          child: AnimatedContainer(
            duration: AppMotion.snap,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 14 : 10,
              vertical: isDesktop ? 10 : 8,
            ),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(AppRadius.smd),
              border: Border.all(
                color: borderColor,
                width: isActive ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? step.color : accent).withValues(
                    alpha: isActive ? (isDark ? 0.25 : 0.15) : (isDark ? 0.08 : 0.04),
                  ),
                  blurRadius: isActive ? 16 : 10,
                  spreadRadius: isActive ? 1 : 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: AppMotion.snap,
                  padding: EdgeInsets.all(isDesktop ? (isActive ? 9 : 8) : (isActive ? 7 : 6)),
                  decoration: BoxDecoration(
                    color: step.color.withValues(alpha: isActive ? 0.3 : (isDark ? 0.15 : 0.12)),
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: accent, width: 1.5) : null,
                  ),
                  child: Icon(step.icon, color: accent, size: isDesktop ? 18 : 16),
                ),
                SizedBox(width: isDesktop ? 12 : 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              step.layer,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: accent,
                                fontSize: isDesktop ? 9.5 : 8.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          if (isActive) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(AppRadius.chip),
                              ),
                              child: Text(
                                'ACTIVE TRACE',
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: accent,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.title,
                        style: TextStyle(
                          color: isDark ? Colors.white : AppColors.slate900,
                          fontSize: isDesktop ? 13 : 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.details,
                        style: TextStyle(
                          color: isDark ? Colors.white.withValues(alpha: 0.7) : AppColors.slate600,
                          fontSize: isDesktop ? 11 : 9.5,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return isShrunk ? list : Expanded(child: list);
  }
}
