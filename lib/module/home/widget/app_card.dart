import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Shared card surface: consistent radius, padding rhythm, border style.
/// Two constructors:
///  - `AppCard.outlined()` — dark surface tinted from Theme with onSurface border.
///  - `AppCard.filled(color: ...)` — solid brand color with subtle white border.
class AppCard extends StatefulWidget {
  final Widget child;
  final Color? _fillOverride;
  final Color? _borderOverride;
  final EdgeInsets padding;
  final double radius;

  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadius.md,
  })  : _fillOverride = null,
        _borderOverride = null;

  const AppCard.filled({
    super.key,
    required this.child,
    required Color color,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadius.md,
  })  : _fillOverride = color,
        _borderOverride = const Color(0x1FFFFFFF); // white @ ~12%

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    // Glassmorphism base colors
    final baseFill = widget._fillOverride ?? scheme.onSurface.withValues(alpha: 0.05);
    final hoverFill = widget._fillOverride ?? scheme.onSurface.withValues(alpha: 0.1);
    
    final baseBorder = widget._borderOverride ?? scheme.onSurface.withValues(alpha: 0.18);
    final hoverBorder = widget._borderOverride ?? scheme.primary.withValues(alpha: 0.6);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: AppMotion.sm,
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scaleByDouble(
          _isHovered ? 1.02 : 1.0,
          _isHovered ? 1.02 : 1.0,
          1.0,
          1.0,
        ),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              )
          ],
        ),
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: AnimatedContainer(
              duration: AppMotion.sm,
              decoration: BoxDecoration(
                color: _isHovered ? hoverFill : baseFill,
                border: Border.all(color: _isHovered ? hoverBorder : baseBorder),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
              child: Padding(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }
}
