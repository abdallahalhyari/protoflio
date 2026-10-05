import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/shell/presentation/widgets/background/page_background_painters.dart';

class DarkBaseCanvas extends StatelessWidget {
  final bool showDecoLayers;
  final Color? overlay;

  const DarkBaseCanvas({
    super.key,
    required this.showDecoLayers,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
        if (overlay != null)
          Positioned.fill(child: ColoredBox(color: overlay!)),
        if (showDecoLayers)
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: DarkGridPainter(),
              ),
            ),
          ),
        if (showDecoLayers)
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
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
}

class LightBaseCanvas extends StatelessWidget {
  final bool showDecoLayers;
  final Color primary;
  final Color surface;
  final Color? overlay;

  const LightBaseCanvas({
    super.key,
    required this.showDecoLayers,
    required this.primary,
    required this.surface,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ColoredBox(color: surface),
        ),
        if (overlay != null)
          Positioned.fill(child: ColoredBox(color: overlay!)),
        if (showDecoLayers)
          Positioned(
            top: -120,
            left: 0,
            right: 0,
            height: 500,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.2,
                    colors: [
                      primary.withValues(alpha: 0.05),
                      primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (showDecoLayers)
          const Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: LightGridPainter(),
              ),
            ),
          ),
      ],
    );
  }
}
