import 'package:flutter/material.dart';

class CardSpotlightOverlay extends StatelessWidget {
  const CardSpotlightOverlay({
    super.key,
    required this.mousePos,
    required this.primary,
    required this.isDark,
  });

  final ValueNotifier<Offset> mousePos;
  final Color primary;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth > 0 ? constraints.maxWidth : 400.0;
          final h = constraints.maxHeight > 0 ? constraints.maxHeight : 200.0;
          return RepaintBoundary(
            child: ValueListenableBuilder<Offset>(
              valueListenable: mousePos,
              builder: (context, pos, _) => Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: FractionalOffset(
                      (pos.dx / w).clamp(0.0, 1.0),
                      (pos.dy / h).clamp(0.0, 1.0),
                    ),
                    radius: 0.65,
                    colors: [
                      primary.withValues(alpha: isDark ? 0.32 : 0.22),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
