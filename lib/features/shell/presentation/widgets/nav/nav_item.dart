import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/hover_reset_offset_controller.dart';

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

class _NavItemState extends State<NavItem> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final _hoverOffset = HoverResetOffsetController(
    vsync: this,
    duration: AppMotion.chipHover,
    curve: AppMotion.emphasized,
  );

  @override
  void dispose() {
    _hoverOffset.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    if (widget.active || MediaQuery.disableAnimationsOf(context)) return;
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;
    if (size.width == 0 || size.height == 0) return;

    final nx = ((event.localPosition.dx / size.width) - 0.5) * 2.0;
    final ny = ((event.localPosition.dy / size.height) - 0.5) * 2.0;
    _hoverOffset.set(Offset(nx.clamp(-1.0, 1.0), ny.clamp(-1.0, 1.0)));
  }

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
        onExit: (_) {
          setState(() => _isHovered = false);
          _hoverOffset.animateToZero();
        },
        onHover: _onHover,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: AnimatedScale(
            scale: hovered ? 1.05 : (widget.active ? 1.02 : 1.0),
            duration: AppMotion.chipHover,
            curve: AppMotion.emphasized,
            child: ValueListenableBuilder<Offset>(
              valueListenable: _hoverOffset.offset,
              builder: (context, norm, child) {
                // Max magnetic pull of 4px
                return Transform.translate(
                  offset: Offset(norm.dx * 4.0, norm.dy * 4.0),
                  child: child,
                );
              },
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
                        margin: const EdgeInsetsDirectional.only(end: 6),
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
            ), // ValueListenableBuilder
          ),
        ),
      ),
    );
  }
}
