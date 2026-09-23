import 'package:flutter/material.dart';

import 'package:profile/shared/util/hover_reset_offset_controller.dart';
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
  final ValueNotifier<bool> _isHovering = ValueNotifier<bool>(false);
  late final _hover = HoverResetOffsetController(
    vsync: this,
    duration: AppMotion.sm,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _isHovering.dispose();
    _hover.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent _) {
    _isHovering.value = true;
  }

  void _onHover(PointerEvent event, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final nx =
        (((event.localPosition.dx / size.width) - 0.5) * 2.0).clamp(-1.0, 1.0);
    final ny =
        (((event.localPosition.dy / size.height) - 0.5) * 2.0).clamp(-1.0, 1.0);
    final next = Offset(nx, ny);

    if ((next - _hover.offset.value).distanceSquared < 0.0004) return;
    _hover.set(next);
  }

  void _onExit(PointerEvent _) {
    _isHovering.value = false;
    _hover.animateToZero();
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
              valueListenable: _hover.offset,
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
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          center: Alignment(
                                              norm.dx * 0.8, norm.dy * 0.8),
                                          radius: 1.2,
                                          colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.15),
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.0),
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
