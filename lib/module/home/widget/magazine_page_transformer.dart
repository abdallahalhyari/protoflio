import 'dart:math' as math;
import 'package:flutter/foundation.dart';
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

        // Page is scrolling away (moving up)
        // It fades out and scales down into the background
        if (position > 0.0 && position <= 1.0) {
          final double turnProgress = position.clamp(0.0, 1.0);
          final double scale = 1.0 - (turnProgress * 0.1);
          final double opacity = (1.0 - turnProgress).clamp(0.0, 1.0);

          return Opacity(
            opacity: opacity,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scaleByDouble(scale, scale, 1.0, 1.0)
                ..translate(0.0, turnProgress * 50.0), // Slight downward drift
              child: child!,
            ),
          );
        }

        // Incoming page from below
        if (position < 0.0 && position >= -1.0) {
          final double emergeProgress = (-position).clamp(0.0, 1.0);
          
          return Transform.translate(
            // Slide up slightly faster than the scroll to create overlap
            offset: Offset(0, emergeProgress * 20.0),
            child: Stack(
              children: [
                child!,
                // Drop shadow cast onto the page below it
                Positioned(
                  top: 0, left: 0, right: 0, height: 100,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: emergeProgress * 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
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
