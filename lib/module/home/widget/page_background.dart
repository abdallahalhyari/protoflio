import 'package:flutter/material.dart';

class PageBackground extends StatefulWidget {
  final String asset;
  final Widget child;
  final Color? overlay;
  final PageController? controller;
  final int? pageIndex;

  const PageBackground({
    super.key,
    required this.asset,
    required this.child,
    this.overlay,
    this.controller,
    this.pageIndex,
  });

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground> {
  Offset _mouseOffset = Offset.zero;

  Widget _buildDarkBackground(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget baseImage = Transform.scale(
      scale: 1.35,
      child: Image.asset(widget.asset, fit: BoxFit.cover),
    );

    if (widget.controller == null || widget.pageIndex == null) {
      return AnimatedSlide(
        duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 150),
        offset: Offset(
          _mouseOffset.dx / size.width * 0.04,
          _mouseOffset.dy / size.height * 0.04,
        ),
        child: baseImage,
      );
    }

    return AnimatedBuilder(
      animation: widget.controller!,
      builder: (context, child) {
        double pageOffset = 0.0;
        if (widget.controller!.position.haveDimensions) {
          pageOffset = widget.controller!.page! - widget.pageIndex!;
        }

        // Use a plain Transform inside the AnimatedBuilder — nesting an
        // AnimatedContainer here would re-trigger its implicit tween on
        // every scroll frame and defeat the parallax.
        return Transform(
          transform: Matrix4.identity()
            ..translateByDouble(
              _mouseOffset.dx * -0.05,
              (pageOffset * size.height * 0.28) + (_mouseOffset.dy * -0.05),
              0.0,
              1.0,
            ),
          child: child,
        );
      },
      child: baseImage,
    );
  }

  Widget _buildLightBackground(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    double pageOffset = 0.0;
    if (widget.controller != null &&
        widget.pageIndex != null &&
        widget.controller!.position.haveDimensions) {
      pageOffset = widget.controller!.page! - widget.pageIndex!;
    }

    final shiftX = reduceMotion ? 0.0 : (_mouseOffset.dx / size.width * 20.0);
    final shiftY = reduceMotion ? 0.0 : (pageOffset * 40.0 + _mouseOffset.dy / size.height * 20.0);

    return Stack(
      children: [
        // Base editorial light gradient
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0xFFFAFBFC),
                  Color(0xFFF1F5F9),
                  Color(0xFFE2E8F0),
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // Ambient glow orbs with parallax
        Transform.translate(
          offset: Offset(shiftX, shiftY),
          child: Stack(
            children: [
              // Top-right soft indigo glow
              Positioned(
                top: -80,
                right: -60,
                width: 480,
                height: 480,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6366F1).withValues(alpha: 0.12),
                        const Color(0xFF6366F1).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom-left soft sky glow
              Positioned(
                bottom: -100,
                left: -80,
                width: 520,
                height: 520,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF38BDF8).withValues(alpha: 0.10),
                        const Color(0xFF38BDF8).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Center warm gold accent glow
              Positioned(
                top: size.height * 0.35,
                left: size.width * 0.45,
                width: 380,
                height: 380,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFBBF24).withValues(alpha: 0.07),
                        const Color(0xFFFBBF24).withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tactile micro-dot architectural pattern
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _LightGridPainter(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onHover: (event) {
        if (MediaQuery.of(context).disableAnimations) return;
        final size = MediaQuery.sizeOf(context);
        final center = Offset(size.width / 2, size.height / 2);
        final next = event.localPosition - center;
        // Skip micro-jitter rebuilds: only repaint when the delta is
        // large enough to actually shift the parallax visibly.
        if ((next - _mouseOffset).distanceSquared < 36) return;
        setState(() {
          _mouseOffset = next;
        });
      },
      onExit: (_) {
        if (_mouseOffset == Offset.zero) return;
        setState(() {
          _mouseOffset = Offset.zero;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: isDark ? _buildDarkBackground(context) : _buildLightBackground(context),
          ),
          if (isDark && widget.overlay != null)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.overlay!.withValues(alpha: 0.65),
                      widget.overlay!.withValues(alpha: 0.9),
                    ],
                  ),
                ),
              ),
            ),
          Positioned.fill(child: widget.child),
        ],
      ),
    );
  }
}

class _LightGridPainter extends CustomPainter {
  const _LightGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.24)
      ..style = PaintingStyle.fill;

    const step = 28.0;
    for (double x = 14; x < size.width; x += step) {
      for (double y = 14; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.8, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
