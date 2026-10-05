import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class DarkFarOrbs extends StatelessWidget {
  final Size size;
  final Color primary;
  final Color secondary;

  const DarkFarOrbs({
    super.key,
    required this.size,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -100,
          right: -80,
          width: 540,
          height: 540,
          child: DecoratedBox(
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
        Positioned(
          bottom: -120,
          left: -100,
          width: 580,
          height: 580,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  secondary.withValues(alpha: 0.08),
                  secondary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DarkNearOrb extends StatelessWidget {
  final Size size;

  const DarkNearOrb({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.35,
          left: size.width * 0.4,
          width: 440,
          height: 440,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accentViolet.withValues(alpha: 0.05),
                  AppColors.accentViolet.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LightFarOrbs extends StatelessWidget {
  final Size size;
  final Color primary;
  final Color secondary;

  const LightFarOrbs({
    super.key,
    required this.size,
    required this.primary,
    required this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -60,
          width: 480,
          height: 480,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primary.withValues(alpha: AppAlpha.hover),
                  primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -80,
          width: 520,
          height: 520,
          child: DecoratedBox(
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
      ],
    );
  }
}

class LightNearOrb extends StatelessWidget {
  final Size size;

  const LightNearOrb({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: size.height * 0.35,
          left: size.width * 0.45,
          width: 380,
          height: 380,
          child: DecoratedBox(
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
    );
  }
}
