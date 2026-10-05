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
      child: RepaintBoundary(
        child: ValueListenableBuilder<Offset>(
          valueListenable: mousePos,
          builder: (context, pos, _) {
            return CustomPaint(
              painter: _SpotlightPainter(pos, primary, isDark),
            );
          },
        ),
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset pos;
  final Color primary;
  final bool isDark;

  _SpotlightPainter(this.pos, this.primary, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final rect = Offset.zero & size;
    final cx = (pos.dx / size.width).clamp(0.0, 1.0);
    final cy = (pos.dy / size.height).clamp(0.0, 1.0);

    final paint = Paint()
      ..blendMode = isDark ? BlendMode.plus : BlendMode.overlay
      ..shader = RadialGradient(
        center: FractionalOffset(cx, cy),
        radius: 0.8,
        colors: [
          primary.withValues(alpha: isDark ? 0.45 : 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) =>
      pos != old.pos || primary != old.primary || isDark != old.isDark;
}
