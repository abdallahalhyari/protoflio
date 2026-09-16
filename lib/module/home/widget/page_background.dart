import 'package:flutter/material.dart';
import '../../../theme/surface_tone.dart';
import '../../../theme/tokens.dart';

class PageBackground extends StatefulWidget {
  final Widget child;
  final Color? overlay;

  const PageBackground({
    super.key,
    required this.child,
    this.overlay,
  });

  @override
  State<PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<PageBackground> {
  final ValueNotifier<Offset> _mouseOffset = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _mouseOffset.dispose();
    super.dispose();
  }

  Widget _buildDarkBackground(BuildContext context, Offset mouseOffset) {
    final size = MediaQuery.sizeOf(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    // Skip decorative micro-dot painter + vignette full-screen fill on
    // mobile — those layers only cost fill-rate and are barely visible
    // on smaller viewports.
    final showDecoLayers = size.width >= AppBreakpoints.tablet;

    final shiftX = reduceMotion ? 0.0 : (mouseOffset.dx / size.width * 24.0);
    final shiftY = reduceMotion ? 0.0 : (mouseOffset.dy / size.height * 24.0);

    return Stack(
      children: [
        // 1. Base Deep Obsidian Midnight Canvas
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.slate950,
                  AppColors.darkNight,
                  AppColors.slate950,
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // 2. Dynamic Ambient Glow Orbs with Parallax Float
        Transform.translate(
          offset: Offset(shiftX, shiftY),
          child: Stack(
            children: [
              // Top-right dynamic active accent glow (harmonizes with current section)
              Positioned(
                top: -100,
                right: -80,
                width: 540,
                height: 540,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        primary.withValues(alpha: 0.16),
                        primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom-left harmonic secondary ambient glow
              Positioned(
                bottom: -120,
                left: -100,
                width: 580,
                height: 580,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        secondary.withValues(alpha: 0.12),
                        secondary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Center-right electric violet depth aura
              Positioned(
                top: size.height * 0.35,
                left: size.width * 0.4,
                width: 440,
                height: 440,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentViolet.withValues(alpha: 0.08),
                        AppColors.accentViolet.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 4. Architectural Precision Micro-Dot Matrix (desktop only)
        if (showDecoLayers)
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _DarkGridPainter(),
              ),
            ),
          ),

        // 5. Subtle Edge Vignette (desktop only — saves full-screen fill
        // on mobile where the LinearGradient base already provides depth)
        if (showDecoLayers)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.25,
                    colors: [
                      Colors.transparent,
                      AppColors.slate950.withValues(alpha: 0.65),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLightBackground(BuildContext context, Offset mouseOffset) {
    final size = MediaQuery.sizeOf(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final showDecoLayers = size.width >= AppBreakpoints.tablet;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;

    final shiftX = reduceMotion ? 0.0 : (mouseOffset.dx / size.width * 20.0);
    final shiftY = reduceMotion ? 0.0 : (mouseOffset.dy / size.height * 20.0);

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
                  AppColors.lightMist,
                  AppColors.slate100,
                  AppColors.slate200,
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
              // Top-right dynamic active accent glow (harmonizes with current section)
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
                        primary.withValues(alpha: 0.12),
                        primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom-left harmonic secondary soft glow
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
                        secondary.withValues(alpha: 0.10),
                        secondary.withValues(alpha: 0.0),
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
                        AppColors.accentAmber.withValues(alpha: 0.07),
                        AppColors.accentAmber.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tactile micro-dot architectural pattern (desktop only)
        if (showDecoLayers)
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
    final isDark = context.isDarkMode;

    return MouseRegion(
      onHover: (event) {
        if (MediaQuery.disableAnimationsOf(context)) return;
        final size = MediaQuery.sizeOf(context);
        final center = Offset(size.width / 2, size.height / 2);
        final next = event.localPosition - center;
        // Skip micro-jitter rebuilds: only repaint when the delta is
        // large enough to actually shift the parallax visibly.
        if ((next - _mouseOffset.value).distanceSquared < 36) return;
        _mouseOffset.value = next;
      },
      onExit: (_) {
        if (_mouseOffset.value == Offset.zero) return;
        _mouseOffset.value = Offset.zero;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: ValueListenableBuilder<Offset>(
                valueListenable: _mouseOffset,
                builder: (context, mouseOffset, _) {
                  return AnimatedCrossFade(
                    duration: AppMotion.sm,
                    crossFadeState: isDark
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: _buildDarkBackground(context, mouseOffset),
                    secondChild: _buildLightBackground(context, mouseOffset),
                    layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(key: bottomKey, child: bottomChild),
                          Positioned.fill(key: topKey, child: topChild),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: RepaintBoundary(
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkGridPainter extends CustomPainter {
  const _DarkGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.045)
      ..style = PaintingStyle.fill;

    const step = 32.0;
    for (double x = 16; x < size.width; x += step) {
      for (double y = 16; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.75, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LightGridPainter extends CustomPainter {
  const _LightGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.slate400.withValues(alpha: 0.20)
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
