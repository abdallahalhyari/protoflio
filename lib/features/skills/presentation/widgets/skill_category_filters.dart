import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/skills/presentation/utils/skill_category_labels.dart';

/// Styling helper for skill categories and corresponding theme accents.
class SkillCategoryStyle {
  static Color getColor(String category, ColorScheme scheme) {
    switch (category) {
      case 'Domain Expertise':
        return AppColors.teal;
      case 'Mobile Systems':
        return AppColors.teal;
      case 'Security & Protocols':
        return AppColors.gold;
      case 'Architecture & State':
        return AppColors.teal;
      case 'Cloud & Infrastructure':
        return AppColors.tealLight;
      case 'Languages & Comm':
        return AppColors.signal;
      default:
        return scheme.primary;
    }
  }

  static Color getTextColor(String category, ColorScheme scheme, bool isDark) {
    if (isDark) return getColor(category, scheme);
    switch (category) {
      case 'Domain Expertise':
        return AppColors.tealDeep;
      case 'Mobile Systems':
        return AppColors.tealDeep;
      case 'Security & Protocols':
        return AppColors.goldDeep;
      case 'Architecture & State':
        return AppColors.tealDeep;
      case 'Cloud & Infrastructure':
        return AppColors.teal;
      case 'Languages & Comm':
        return AppColors.signalDeep;
      default:
        return AppColors.toAccessibleLightText(scheme.primary);
    }
  }

  static List<Color> getGradient(String category, ColorScheme scheme) {
    switch (category) {
      case 'Domain Expertise':
        return const [AppColors.teal, AppColors.tealDeep];
      case 'Mobile Systems':
        return [AppColors.teal, scheme.primary];
      case 'Security & Protocols':
        return const [AppColors.gold, AppColors.gold];
      case 'Architecture & State':
        return const [AppColors.tealLight, AppColors.teal];
      case 'Cloud & Infrastructure':
        return const [AppColors.tealLight, AppColors.signal];
      case 'Languages & Comm':
        return const [AppColors.signal, AppColors.signalDeep];
      default:
        return [scheme.primary, AppColors.tealLight];
    }
  }
}

/// Category chip filter row / wrap for skill disciplines.
class SkillCategoryFilters extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;
  final bool isDesktop;

  /// Skills per category (and 'ALL'), from the filter bloc's state.
  final Map<String, int> counts;

  const SkillCategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.isDesktop,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < categories.length; i++) ...[
              _buildFilterChip(categories[i], false),
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
        for (final cat in categories) _buildFilterChip(cat, isDesktop),
      ],
    );
  }

  Widget _buildFilterChip(String cat, bool isDesktop) {
    return _SkillFilterChip(
      cat: cat,
      isDesktop: isDesktop,
      selectedCategory: selectedCategory,
      onSelectCategory: onSelectCategory,
      count: counts[cat] ?? 0,
    );
  }
}

class _SkillFilterChip extends StatefulWidget {
  const _SkillFilterChip({
    required this.cat,
    required this.isDesktop,
    required this.selectedCategory,
    required this.onSelectCategory,
    required this.count,
  });

  final String cat;
  final int count;
  final bool isDesktop;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  @override
  State<_SkillFilterChip> createState() => _SkillFilterChipState();
}

class _SkillFilterChipState extends State<_SkillFilterChip> {
  bool _focused = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.cat;
    final scheme = Theme.of(context).colorScheme;
    final isDesktop = widget.isDesktop;
    final selectedCategory = widget.selectedCategory;
    final onSelectCategory = widget.onSelectCategory;
    final isDark = scheme.brightness == Brightness.dark;
    final isSelected = selectedCategory == cat;
    final color = cat == 'ALL'
        ? scheme.primary
        : SkillCategoryStyle.getColor(cat, scheme);
    final textColor = cat == 'ALL'
        ? (isDark
            ? scheme.primary
            : AppColors.toAccessibleLightText(scheme.primary))
        : SkillCategoryStyle.getTextColor(cat, scheme, isDark);
    final count = widget.count;

    final borderColor = isSelected || _focused
        ? color
        : (_hovered
            ? color.withValues(alpha: isDark ? 0.55 : 0.6)
            : (isDark
                ? scheme.onSurface.withValues(alpha: 0.15)
                : AppColors.ink300));

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$cat category, $count skills',
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered && !isSelected ? 1.03 : 1.0,
          duration: AppMotion.chipHover,
          curve: AppMotion.emphasized,
          child: InkWell(
            onTap: () {
              SoundService.instance.playClick();
              onSelectCategory(cat);
            },
            borderRadius: BorderRadius.circular(AppRadius.sm),
            focusColor: color.withValues(alpha: AppAlpha.fill),
            onFocusChange: (focused) {
              if (focused != _focused) setState(() => _focused = focused);
            },
            child: ExcludeSemantics(
                child: AnimatedContainer(
              duration: AppMotion.chipHover,
              curve: AppMotion.emphasized,
              // 12 on desktop keeps all seven filters on one row inside
              // the shared 1280 section width (16 wrapped the last one).
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 12 : 10,
                vertical: isDesktop ? 10 : 7,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: isDark ? 0.18 : 0.12)
                    : (isDark
                        ? Colors.transparent
                        : Colors.white.withValues(alpha: 0.8)),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: borderColor,
                  width: _focused ? 2.0 : (isSelected ? 1.5 : 1.0),
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
                              color: AppColors.ink900.withValues(alpha: 0.03),
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
                        decoration:
                            BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      skillCategoryLabel(AppLocalizations.of(context)!, cat),
                      style: TextStyle(
                        color: isSelected
                            ? (isDark ? color : textColor)
                            : (isDark
                                ? scheme.onSurface.withValues(alpha: 0.7)
                                : AppColors.ink700),
                        fontSize: isDesktop
                            ? AppTypography.label
                            : AppTypography.label,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '($count)',
                      style: TextStyle(
                        color: isSelected
                            ? textColor
                            : (isDark ? context.mutedText : AppColors.ink500),
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
