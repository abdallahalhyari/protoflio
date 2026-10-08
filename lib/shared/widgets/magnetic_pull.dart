import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/shared/utils/hover_reset_offset_controller.dart';

/// A physics-based wrapper that slightly pulls its child towards the cursor
/// on desktop hover, producing a highly tactile, premium "magnetic" feel.
///
/// Best applied to primary CTAs and social buttons.
class MagneticPull extends StatefulWidget {
  final Widget child;
  final bool enabled;

  /// How far the button can be pulled from its center (in pixels). Default 12.0.
  final double maxPull;

  const MagneticPull({
    super.key,
    required this.child,
    this.enabled = true,
    this.maxPull = 12.0,
  });

  @override
  State<MagneticPull> createState() => _MagneticPullState();
}

class _MagneticPullState extends State<MagneticPull>
    with SingleTickerProviderStateMixin {
  late final _hover = HoverResetOffsetController(
    vsync: this,
    duration: AppMotion.md,
    curve: AppMotion.emphasizedDecel,
  );

  bool _isHovered = false;
  final GlobalKey _key = GlobalKey();

  @override
  void dispose() {
    _hover.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerEvent event) {
    if (!widget.enabled || !_isHovered) return;

    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Calculate distance from center of the widget
    final size = renderBox.size;
    final center = size.center(Offset.zero);
    final localPosition = renderBox.globalToLocal(event.position);

    // Map position to a normalized pull factor (-1 to 1)
    final dx =
        ((localPosition.dx - center.dx) / (size.width / 2)).clamp(-1.0, 1.0);
    final dy =
        ((localPosition.dy - center.dy) / (size.height / 2)).clamp(-1.0, 1.0);

    // Apply maxPull and set offset
    _hover.set(Offset(dx * widget.maxPull, dy * widget.maxPull));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        _hover.animateToZero();
        setState(() => _isHovered = false);
      },
      onHover: _onPointerMove,
      child: RepaintBoundary(
        child: ValueListenableBuilder<Offset>(
          valueListenable: _hover.offset,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: offset,
              child: child,
            );
          },
          child: KeyedSubtree(
            key: _key,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
