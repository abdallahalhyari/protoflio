import 'package:flutter/material.dart';
import '../../../../service/sound_service.dart';
import '../../../../theme/tokens.dart';

class ProjectDomainFilters extends StatelessWidget {
  final List<String> domains;
  final String selectedDomain;
  final String? selectedTech;
  final ValueChanged<String> onSelectDomain;
  final VoidCallback? onClearTech;
  final Map<String, int> domainCounts;
  final bool isDesktop;

  const ProjectDomainFilters({
    super.key,
    required this.domains,
    required this.selectedDomain,
    this.selectedTech,
    required this.onSelectDomain,
    this.onClearTech,
    required this.domainCounts,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = scheme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (final domain in domains) ...[
                _DomainChip(
                  label: domain,
                  count: domainCounts[domain] ?? 0,
                  isSelected: domain == selectedDomain,
                  scheme: scheme,
                  isDark: isDark,
                  isDesktop: isDesktop,
                  onTap: () {
                    SoundService.instance.playSelection();
                    onSelectDomain(domain);
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),
        ),
        if (selectedTech != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_alt_rounded, size: 14, color: scheme.primary),
                const SizedBox(width: 6),
                Text(
                  'TECH FILTER: ${selectedTech!.toUpperCase()}',
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    color: scheme.primary,
                    fontSize: AppTypography.micro,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    SoundService.instance.playClick();
                    onClearTech?.call();
                  },
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(Icons.close_rounded, size: 14, color: scheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _DomainChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final ColorScheme scheme;
  final bool isDark;
  final bool isDesktop;
  final VoidCallback onTap;

  const _DomainChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.scheme,
    required this.isDark,
    required this.isDesktop,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeBg = isSelected
        ? scheme.primary.withValues(alpha: isDark ? 0.22 : 0.15)
        : (isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.slate100);

    final activeBorder = isSelected
        ? scheme.primary.withValues(alpha: isDark ? 0.7 : 0.6)
        : (isDark ? Colors.white.withValues(alpha: 0.12) : AppColors.slate200);

    final textColor = isSelected
        ? scheme.primary
        : (isDark ? Colors.white.withValues(alpha: 0.85) : AppColors.slate700);

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label filter, $count items',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedContainer(
            duration: AppMotion.snap,
            curve: AppMotion.standard,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 12 : 10,
              vertical: isDesktop ? 7 : 6,
            ),
            decoration: BoxDecoration(
              color: activeBg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: activeBorder, width: isSelected ? 1.5 : 1.0),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    color: textColor,
                    fontSize: isDesktop ? AppTypography.micro : 10,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? scheme.primary.withValues(alpha: 0.25)
                        : (isDark ? Colors.white12 : AppColors.slate200),
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      color: textColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
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
