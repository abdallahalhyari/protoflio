import 'dart:math' as math;
import 'package:flutter/material.dart';

class MagazinePageTransformer extends StatelessWidget {
  final Widget child;
  final PageController controller;
  final int index;

  const MagazinePageTransformer({
    super.key,
    required this.child,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations ||
        MediaQuery.of(context).accessibleNavigation;

    if (reduceMotion) {
      return child;
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double position = 0.0;
        if (controller.hasClients &&
            controller.positions.length == 1 &&
            controller.position.haveDimensions) {
          position = (controller.page ?? controller.initialPage.toDouble()) - index;
        }

        // When page is active
        if (position == 0.0) {
          return child!;
        }

        // Page is scrolling away (turning up / upwards fold)
        if (position > 0.0 && position <= 1.0) {
          final double turnProgress = position.clamp(0.0, 1.0);
          // 3D rotation around top edge (spine)
          final double angle = -turnProgress * (math.pi / 5); // Up to ~36 degrees perspective fold
          final double scale = 1.0 - (turnProgress * 0.05);

          return Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0012)
              ..scaleByDouble(scale, scale, 1.0, 1.0)
              ..rotateX(angle),
            child: Stack(
              children: [
                child!,
                // Crease & paper curl shadow overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: turnProgress * 0.45),
                            Colors.black.withValues(alpha: turnProgress * 0.15),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Incoming page from below
        if (position < 0.0 && position >= -1.0) {
          final double emergeProgress = (-position).clamp(0.0, 1.0);
          final double scale = 0.94 + (1.0 - emergeProgress) * 0.06;

          return Transform.scale(
            scale: scale,
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                child!,
                // Ambient shadow cast from the page above
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Colors.black.withValues(alpha: emergeProgress * 0.25),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Pages far off screen
        return child!;
      },
      child: child,
    );
  }
}
