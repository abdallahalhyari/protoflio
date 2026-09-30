import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

class NavItem extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  /// Tighter padding and a smaller label, for windows under desktop width
  /// where the full-length section names otherwise overflow the pill.
  final bool dense;

  const NavItem({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.dense = false,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accent = Theme.of(context).colorScheme.primary;
    final hovered = _isHovered && !widget.active;

    return Semantics(
      button: true,
      selected: widget.active,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedScale(
            scale: hovered ? 1.05 : (widget.active ? 1.02 : 1.0),
            duration: AppMotion.chipHover,
            curve: AppMotion.emphasized,
            child: AnimatedContainer(
              duration: widget.active ? AppMotion.sm : AppMotion.chipHover,
              curve: AppMotion.emphasized,
              padding: EdgeInsets.symmetric(
                  horizontal: widget.dense ? AppSpacing.sm : AppSpacing.smd,
                  vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: widget.active
                    ? context.activeChipSurface(accent)
                    : hovered
                        ? context.hoverChipSurface(accent)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: widget.active
                    ? Border.all(color: context.activeChipBorder(accent))
                    : null,
                boxShadow: widget.active
                    ? context.activeChipShadow(accent)
                    : hovered
                        ? context.hoverChipShadow(accent)
                        : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.active) ...[
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white : accent,
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.8),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                  AnimatedDefaultTextStyle(
                    duration: AppMotion.chipHover,
                    style: TextStyle(
                      color: widget.active
                          ? (isDark ? Colors.white : accent)
                          : hovered
                              ? (isDark
                                  ? Colors.white.withValues(alpha: 0.92)
                                  : AppColors.slate800)
                              : (context.mutedText),
                      fontSize: widget.dense
                          ? AppTypography.caption + 1
                          : AppTypography.small,
                      fontWeight:
                          widget.active ? FontWeight.w800 : FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
