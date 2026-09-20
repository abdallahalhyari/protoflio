import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/features/engineering/model/architecture_topic.dart';

/// Horizontal pill tab bar to switch between production architecture blueprints.
class ArchitectureTopicTabs extends StatelessWidget {
  final List<ArchitectureTopic> topics;
  final int selectedIndex;
  final ValueChanged<int> onSelectTopic;
  final bool isDesktop;

  const ArchitectureTopicTabs({
    super.key,
    required this.topics,
    required this.selectedIndex,
    required this.onSelectTopic,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < topics.length; i++) ...[
            _buildTabItem(
              context: context,
              topic: topics[i],
              isSelected: selectedIndex == i,
              onTap: () => onSelectTopic(i),
              scheme: scheme,
            ),
            if (i < topics.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required ArchitectureTopic topic,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme scheme,
  }) {
    final isDark = scheme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Select ${topic.title}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: AnimatedContainer(
          duration: AppMotion.sm,
          curve: AppMotion.emphasized,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.primary.withValues(alpha: isDark ? 0.18 : 0.12)
                : (isDark
                    ? scheme.surface.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.85)),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected
                  ? scheme.primary
                  : (isDark
                      ? scheme.onSurface.withValues(alpha: 0.15)
                      : AppColors.slate300),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: scheme.primary
                          .withValues(alpha: isDark ? 0.25 : 0.15),
                      blurRadius: 16,
                    ),
                  ]
                : (isDark
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.slate900.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ]),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? scheme.primary
                      : (isDark ? Colors.white38 : AppColors.slate400),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                topic.title.toUpperCase(),
                style: TextStyle(
                  color: isSelected
                      ? (isDark ? Colors.white : scheme.primary)
                      : (isDark ? Colors.white70 : AppColors.slate600),
                  fontSize: AppTypography.captionSm,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
