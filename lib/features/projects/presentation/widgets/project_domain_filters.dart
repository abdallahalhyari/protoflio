import 'package:flutter/material.dart';
import 'package:profile/features/projects/presentation/utils/project_copy.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/shared/utils/bidi.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

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
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (final domain in domains) ...[
                      _DomainChip(
                        domainRaw: domain,
                        label: localizedProjectDomain(loc, domain),
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
            ),
            if (isDesktop) ...[
              const SizedBox(width: AppSpacing.md),
              _KeyboardShortcutHint(isDark: isDark),
            ],
          ],
        ),
        if (selectedTech != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: isDark ? 0.18 : 0.08),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: scheme.primary.withValues(alpha: isDark ? 0.5 : 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: isDark ? 0.12 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_alt_rounded, size: 14, color: accentText),
                const SizedBox(width: 6),
                Text(
                  ltrContent(
                    context,
                    loc.projectTechFilter(
                      ltrAlways(context, selectedTech!),
                    ),
                  ),
                  style: TextStyle(
                    color: accentText,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w800,
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

class _KeyboardShortcutHint extends StatelessWidget {
  final bool isDark;
  const _KeyboardShortcutHint({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : AppColors.ink100,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.09) : AppColors.ink200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _KeyPill(label: '←', isDark: isDark),
          const SizedBox(width: 3),
          _KeyPill(label: '→', isDark: isDark),
          const SizedBox(width: 6),
          Text(
            'Switch domain',
            style: TextStyle(
              color: context.mutedText,
              fontSize: AppTypography.label - 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyPill extends StatelessWidget {
  final String label;
  final bool isDark;

  const _KeyPill({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.hairline),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.16) : AppColors.ink300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: context.onSurface,
          fontSize: AppTypography.label - 2,
          fontWeight: FontWeight.w900,
          height: 1.0,
        ),
      ),
    );
  }
}

class _DomainChip extends StatefulWidget {
  final String domainRaw;
  final String label;
  final int count;
  final bool isSelected;
  final ColorScheme scheme;
  final bool isDark;
  final bool isDesktop;
  final VoidCallback onTap;

  const _DomainChip({
    required this.domainRaw,
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

  IconData _iconForDomain(String raw) {
    switch (raw) {
      case 'ALL':
        return Icons.auto_awesome_mosaic_rounded;
      case 'Healthcare & Smart Cards':
        return Icons.contactless_rounded;
      case 'Enterprise HIS & LMS':
        return Icons.apartment_rounded;
      case 'Fleet & Telematics':
        return Icons.navigation_rounded;
      case 'M-Commerce & Streaming':
        return Icons.play_circle_fill_rounded;
      default:
        return Icons.folder_open_rounded;
    }
  }

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
                : AppColors.ink100));

    final activeBorder = isSelected
        ? scheme.primary.withValues(alpha: isDark ? 0.7 : 0.6)
        : (isInteractive
            ? scheme.primary.withValues(alpha: isDark ? 0.45 : 0.35)
            : (context.divider));

    final textColor = isSelected
        ? context.adaptiveAccentText(scheme.primary)
        : context.onSurface;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '${widget.label} filter, ${widget.count} '
          '${widget.count == 1 ? 'case study' : 'case studies'}',
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
              child: ExcludeSemantics(
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
                                .withValues(alpha: isDark ? 0.25 : 0.15),
                            blurRadius: 10,
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
                    Icon(
                      _iconForDomain(widget.domainRaw),
                      size: 13,
                      color: isSelected
                          ? textColor
                          : (isInteractive ? textColor : context.mutedText),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: AppTypography.label,
                        fontWeight:
                            isSelected ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 5),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: textColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: scheme.primary.withValues(alpha: 0.6),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(width: 6),
                    AnimatedContainer(
                      duration: AppMotion.snap,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? scheme.primary
                            : (isInteractive
                                ? scheme.primary
                                    .withValues(alpha: isDark ? 0.15 : 0.1)
                                : (context.divider)),
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                      ),
                      child: Text(
                        '${widget.count}',
                        style: TextStyle(
                          color: isSelected ? scheme.onPrimary : textColor,
                          fontSize: AppTypography.label,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
