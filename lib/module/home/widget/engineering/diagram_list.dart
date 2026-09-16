import 'package:flutter/material.dart';

import '../../../../theme/surface_tone.dart';
import '../../../../theme/tokens.dart';
import '../../model/architecture_topic.dart';

class DiagramList extends StatelessWidget {
  final ArchitectureTopic topic;
  final ColorScheme scheme;
  final bool isDesktop;
  const DiagramList({
    super.key,
    required this.topic,
    required this.scheme,
    required this.isDesktop,
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
    final list = ListView.separated(
      shrinkWrap: !isDesktop,
      physics: isDesktop
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: topic.diagramSteps.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Center(
          child: Column(
            children: [
              Container(
                  width: 1,
                  height: 16,
                  color: scheme.primary.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: scheme.primary, size: 16),
              const SizedBox(width: 4),
              Container(
                  width: 1,
                  height: 16,
                  color: scheme.primary.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
      itemBuilder: (context, index) {
        final step = topic.diagramSteps[index];
        final accent = _adaptiveAccent(context, step.color);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 14 : 10, vertical: isDesktop ? 10 : 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withValues(alpha: 0.35) : AppColors.slate50,
            borderRadius: BorderRadius.circular(AppRadius.smd),
            border: Border.all(color: (isDark ? step.color : accent).withValues(alpha: isDark ? 0.4 : 0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: step.color.withValues(alpha: isDark ? 0.08 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isDesktop ? 8 : 6),
                decoration: BoxDecoration(
                  color: step.color.withValues(alpha: isDark ? 0.15 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(step.icon, color: accent, size: isDesktop ? 18 : 16),
              ),
              SizedBox(width: isDesktop ? 12 : 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.layer,
                      style: TextStyle(
                        color: accent,
                        fontSize: isDesktop ? 9.5 : 8.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
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
        );
      },
    );
    return isDesktop ? Expanded(child: list) : list;
  }
}
