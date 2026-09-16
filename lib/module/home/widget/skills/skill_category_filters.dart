import 'package:flutter/material.dart';

import '../../../../theme/tokens.dart';
import '../../../../service/sound_service.dart';
import '../../data/skills_data.dart';

/// Styling helper for skill categories and corresponding theme accents.
class SkillCategoryStyle {
  static Color getColor(String category, ColorScheme scheme) {
    switch (category) {
      case 'Domain Expertise':
        return AppColors.accentViolet;
      case 'Mobile Systems':
        return AppColors.accentSky;
      case 'Security & Protocols':
        return AppColors.accentAmber;
      case 'Architecture & State':
        return AppColors.accentGreen;
      case 'Cloud & Infrastructure':
        return AppColors.accentVioletLight;
      case 'Languages & Comm':
        return const Color(0xFFF472B6);
      default:
        return scheme.primary;
    }
  }

  static Color getTextColor(String category, ColorScheme scheme, bool isDark) {
    if (isDark) return getColor(category, scheme);
    switch (category) {
      case 'Domain Expertise':
        return AppColors.accentVioletDeep;
      case 'Mobile Systems':
        return AppColors.accentSkyDeep;
      case 'Security & Protocols':
        return AppColors.accentAmberDeep;
      case 'Architecture & State':
        return AppColors.accentGreenDeep;
      case 'Cloud & Infrastructure':
        return const Color(0xFF7C3AED);
      case 'Languages & Comm':
        return const Color(0xFFBE185D);
      default:
        return scheme.primary;
    }
  }

  static List<Color> getGradient(String category, ColorScheme scheme) {
    switch (category) {
      case 'Domain Expertise':
        return const [Color(0xFF8B5CF6), Color(0xFF6D28D9)];
      case 'Mobile Systems':
        return [const Color(0xFF38BDF8), scheme.primary];
      case 'Security & Protocols':
        return const [Color(0xFFFBBF24), Color(0xFFF59E0B)];
      case 'Architecture & State':
        return const [Color(0xFF34D399), Color(0xFF10B981)];
      case 'Cloud & Infrastructure':
        return const [Color(0xFFA78BFA), Color(0xFFEC4899)];
      case 'Languages & Comm':
        return const [Color(0xFFF472B6), Color(0xFFBE185D)];
      default:
        return [scheme.primary, const Color(0xFFC084FC)];
    }
  }
}

/// Category chip filter row / wrap for skill disciplines.
class SkillCategoryFilters extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;
  final bool isDesktop;

  const SkillCategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (!isDesktop) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < categories.length; i++) ...[
              _buildFilterChip(categories[i], scheme, false),
              if (i < categories.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final cat in categories) _buildFilterChip(cat, scheme, isDesktop),
      ],
    );
  }

  Widget _buildFilterChip(String cat, ColorScheme scheme, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    final isSelected = selectedCategory == cat;
    final color = cat == 'ALL' ? scheme.primary : SkillCategoryStyle.getColor(cat, scheme);
    final textColor = cat == 'ALL' ? scheme.primary : SkillCategoryStyle.getTextColor(cat, scheme, isDark);
    final count = cat == 'ALL' ? kSkills.length : kSkills.where((s) => s.category == cat).length;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$cat category, $count skills',
      child: InkWell(
        onTap: () {
          SoundService.instance.playClick();
          onSelectCategory(cat);
        },
        borderRadius: BorderRadius.circular(AppRadius.sm),
        focusColor: color.withValues(alpha: 0.25),
        child: AnimatedContainer(
          duration: AppMotion.chipHover,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 16 : 10,
            vertical: isDesktop ? 10 : 7,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: isDark ? 0.18 : 0.12)
                : (isDark ? Colors.transparent : Colors.white.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: isSelected
                  ? color
                  : (isDark ? scheme.onSurface.withValues(alpha: 0.15) : AppColors.slate300),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: isDark ? 0.25 : 0.15),
                      blurRadius: 12,
                    ),
                  ]
                : (isDark
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.slate900.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ]),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  cat.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: isSelected
                        ? (isDark ? color : textColor)
                        : (isDark ? scheme.onSurface.withValues(alpha: 0.7) : AppColors.slate700),
                    fontSize: isDesktop ? 11 : 9.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '($count)',
                  style: TextStyle(
                    fontFamily: 'Courier',
                    color: isSelected
                        ? (isDark ? color.withValues(alpha: 0.85) : textColor)
                        : (isDark ? scheme.onSurface.withValues(alpha: 0.45) : AppColors.slate500),
                    fontSize: isDesktop ? 10 : 8.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
