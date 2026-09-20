import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';

/// A high-performance 3D interactive physics wrapper that tilts its child based
/// on the mouse cursor position and renders a dynamic specular glare.
///
/// Uses [ValueNotifier] and [ValueListenableBuilder] to isolate tilt updates to
/// the GPU transform layer without triggering full-tree widget rebuilds.
class HolographicCardPhysics extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final double maxTiltAngle;
  final bool enableGlare;

  const HolographicCardPhysics({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.card,
    this.maxTiltAngle = 0.15, // ~8.5 degrees max tilt
    this.enableGlare = true,
  });

  @override
  State<HolographicCardPhysics> createState() => _HolographicCardPhysicsState();
}

class _HolographicCardPhysicsState extends State<HolographicCardPhysics>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<Offset> _norm = ValueNotifier<Offset>(Offset.zero);
  final ValueNotifier<bool> _isHovering = ValueNotifier<bool>(false);
  late final AnimationController _resetCtrl;
  late Animation<Offset> _resetAnimation;

  @override
  void initState() {
    super.initState();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: AppMotion.sm,
    );
  }

  @override
  void dispose() {
    _norm.dispose();
    _isHovering.dispose();
    _resetCtrl.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent _) {
    _resetCtrl.stop();
    _isHovering.value = true;
  }

  void _onHover(PointerEvent event, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    if (_resetCtrl.isAnimating) _resetCtrl.stop();

    final nx = (((event.localPosition.dx / size.width) - 0.5) * 2.0).clamp(-1.0, 1.0);
    final ny = (((event.localPosition.dy / size.height) - 0.5) * 2.0).clamp(-1.0, 1.0);
    final next = Offset(nx, ny);

    if ((next - _norm.value).distanceSquared < 0.0004) return;
    _norm.value = next;
  }

  void _onExit(PointerEvent _) {
    _isHovering.value = false;
    final current = _norm.value;
    if (current == Offset.zero) return;

    _resetAnimation = Tween<Offset>(
      begin: current,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _resetCtrl, curve: Curves.easeOutCubic),
    );

    _resetCtrl.reset();
    _resetAnimation.addListener(() {
      _norm.value = _resetAnimation.value;
    });
    _resetCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
          return widget.child;
        }
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return MouseRegion(
          onEnter: _onEnter,
          onHover: (e) => _onHover(e, size),
          onExit: _onExit,
          child: RepaintBoundary(
            child: ValueListenableBuilder<Offset>(
              valueListenable: _norm,
              builder: (context, norm, staticChild) {
                // Pitch (X-axis tilt): cursor down tilts top towards viewer
                final double pitch = -norm.dy * widget.maxTiltAngle;
                // Yaw (Y-axis tilt): cursor right tilts right away
                final double yaw = norm.dx * widget.maxTiltAngle;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(pitch)
                    ..rotateY(yaw),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      staticChild!,
                      if (widget.enableGlare)
                        ValueListenableBuilder<bool>(
                          valueListenable: _isHovering,
                          builder: (context, hovering, _) {
                            return Positioned.fill(
                              child: IgnorePointer(
                                child: AnimatedOpacity(
                                  opacity: hovering ? 1.0 : 0.0,
                                  duration: AppMotion.sm,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(widget.borderRadius),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          center: Alignment(norm.dx * 0.8, norm.dy * 0.8),
                                          radius: 1.2,
                                          colors: [
                                            Colors.white.withValues(alpha: 0.15),
                                            Colors.white.withValues(alpha: 0.0),
                                          ],
                                          stops: const [0.0, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
