import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';
import '../../page/engineering_page.dart' show ArchitectureTopic;

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

  @override
  Widget build(BuildContext context) {
    final isDark = scheme.brightness == Brightness.dark;
    final list = ListView.separated(
      shrinkWrap: !isDesktop,
      physics: isDesktop
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: topic.diagramSteps.length,
      separatorBuilder: (context, index) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 1,
                  height: 16,
                  color: scheme.primary.withValues(alpha: 0.5)),
              const SizedBox(width: 4),
              Icon(Icons.arrow_downward, size: 12, color: scheme.primary),
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
        return Container(
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 14 : 10, vertical: isDesktop ? 10 : 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withValues(alpha: 0.35) : AppColors.slate50,
            borderRadius: BorderRadius.circular(AppRadius.smd),
            border: Border.all(color: step.color.withValues(alpha: isDark ? 0.4 : 0.5), width: 1),
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
                child: Icon(step.icon, color: step.color, size: isDesktop ? 18 : 16),
              ),
              SizedBox(width: isDesktop ? 12 : 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.layer,
                      style: TextStyle(
                        color: step.color,
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
