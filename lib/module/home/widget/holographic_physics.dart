import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

/// A 3D interactive physics wrapper that tilts its child based on the mouse
/// cursor's local position, and renders a dynamic specular glare.
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

class _HolographicCardPhysicsState extends State<HolographicCardPhysics> {
  Offset _localMouse = Offset.zero;
  bool _isHovering = false;
  Size _size = Size.zero;

  void _onHover(PointerEvent event) {
    if (kIsWeb && MediaQuery.of(context).disableAnimations) return; // Prevent Web CanvasKit jitter
    setState(() {
      _localMouse = event.localPosition;
    });
  }

  void _onEnter(PointerEvent event) {
    setState(() {
      _isHovering = true;
      _localMouse = event.localPosition;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      _isHovering = false;
      // Mouse is reset to the center of the card
      _localMouse = Offset(_size.width / 2, _size.height / 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onHover: _onHover,
      onExit: _onExit,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // If unconstrained or 0, fallback gracefully.
          if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
            return widget.child;
          }
          _size = Size(constraints.maxWidth, constraints.maxHeight);

          // If not hovering, target the center so it springs back to flat (0,0)
          final targetMouse = _isHovering 
              ? _localMouse 
              : Offset(_size.width / 2, _size.height / 2);

          // Tween to the target mouse position to create a spring effect
          return TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(begin: targetMouse, end: targetMouse),
            duration: _isHovering ? Duration.zero : AppMotion.sm,
            curve: Curves.easeOutCubic,
            builder: (context, animatedMouse, child) {
              
              // Normalize mouse position to range [-1, 1] relative to center
              final double nx = (animatedMouse.dx - _size.width / 2) / (_size.width / 2);
              final double ny = (animatedMouse.dy - _size.height / 2) / (_size.height / 2);
              
              // Clamp to prevent wild rotations if mouse flies out
              final double clampedNx = nx.clamp(-1.0, 1.0);
              final double clampedNy = ny.clamp(-1.0, 1.0);

              // Calculate pitch (X-axis) and yaw (Y-axis)
              // Pitch is inverted: mouse moving down (positive Y) tilts bottom away (negative X rotation)
              final double pitch = -clampedNy * widget.maxTiltAngle;
              final double yaw = clampedNx * widget.maxTiltAngle;

              return RepaintBoundary(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(pitch)
                    ..rotateY(yaw),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.child,
                      if (widget.enableGlare)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              opacity: _isHovering ? 1.0 : 0.0,
                              duration: AppMotion.sm,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(widget.borderRadius),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment(clampedNx * 0.8, clampedNy * 0.8),
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
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
