import 'package:flutter/material.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

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
    final accentText = context.adaptiveAccentText(scheme.primary);

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
              color: scheme.primary.withValues(alpha: AppAlpha.hover),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: scheme.primary.withValues(alpha: AppAlpha.border),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_alt_rounded, size: 14, color: accentText),
                const SizedBox(width: 6),
                Text(
                  'TECH FILTER: ${selectedTech!.toUpperCase()}',
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    color: accentText,
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
                    child:
                        Icon(Icons.close_rounded, size: 14, color: accentText),
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

class _DomainChip extends StatefulWidget {
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
  State<_DomainChip> createState() => _DomainChipState();
}

class _DomainChipState extends State<_DomainChip> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isDark = widget.isDark;
    final scheme = widget.scheme;
    final isDesktop = widget.isDesktop;
    final isInteractive = _isHovered || _isFocused;

    final activeBg = isSelected
        ? scheme.primary.withValues(alpha: isDark ? 0.22 : 0.15)
        : (isInteractive
            ? scheme.primary.withValues(alpha: isDark ? 0.08 : 0.05)
            : (isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.slate100));

    final activeBorder = isSelected
        ? scheme.primary.withValues(alpha: isDark ? 0.7 : 0.6)
        : (isInteractive
            ? scheme.primary.withValues(alpha: isDark ? 0.45 : 0.35)
            : (context.divider));

    final textColor = isSelected
        ? context.adaptiveAccentText(scheme.primary)
        : (isInteractive
            ? (context.onSurface)
            : (isDark
                ? Colors.white.withValues(alpha: 0.85)
                : AppColors.slate700));

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${widget.label} filter, ${widget.count} items',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedScale(
          scale: isInteractive && !isSelected && isDesktop ? 1.03 : 1.0,
          duration: AppMotion.snap,
          curve: AppMotion.emphasized,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onFocusChange: (focused) => setState(() => _isFocused = focused),
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
                  border: Border.all(
                    color: activeBorder,
                    width: isSelected || _isFocused ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: scheme.primary
                                .withValues(alpha: isDark ? 0.2 : 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : (isInteractive && !isSelected
                          ? [
                              BoxShadow(
                                color: scheme.primary
                                    .withValues(alpha: isDark ? 0.08 : 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label.toUpperCase(),
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        color: textColor,
                        fontSize: isDesktop ? AppTypography.micro : 10,
                        fontWeight:
                            isSelected ? FontWeight.w900 : FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedContainer(
                      duration: AppMotion.snap,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? scheme.primary.withValues(alpha: AppAlpha.fill)
                            : (isInteractive
                                ? scheme.primary
                                    .withValues(alpha: isDark ? 0.15 : 0.1)
                                : (context.divider)),
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                      ),
                      child: Text(
                        '${widget.count}',
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          color: textColor,
                          fontSize: AppTypography.editorialSm,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
