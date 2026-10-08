import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';

class SpecularGleam extends StatelessWidget {
  const SpecularGleam({
    super.key,
    required this.isHovered,
    required this.tiltOffset,
  });

  final bool isHovered;
  final ValueNotifier<Offset> tiltOffset;

  @override
  Widget build(BuildContext context) {
    if (!isHovered) return const SizedBox.shrink();
    return Positioned.fill(
      child: IgnorePointer(
        child: ValueListenableBuilder<Offset>(
          valueListenable: tiltOffset,
          builder: (context, tilt, _) {
            return RepaintBoundary(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  gradient: RadialGradient(
                    center: Alignment(tilt.dx, tilt.dy),
                    radius: 0.9,
                    colors: [
                      AppColors.gold.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: AppAlpha.whisper),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CardOrdinalHeader extends StatelessWidget {
  const CardOrdinalHeader({
    super.key,
    required this.ordinal,
    required this.accent,
  });

  final String ordinal;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppColors.goldSoft,
                  AppColors.gold,
                  AppColors.goldSoft,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                ordinal,
                style: const TextStyle(
                  fontFamily: AppTypography.displayFont,
                  color: Colors.white,
                  fontSize: AppTypography.heading,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
            Text(
              'Role',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.65),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AccentUnderRule extends StatelessWidget {
  const AccentUnderRule({
    super.key,
    required this.accent,
    this.height = 1.5,
    this.width = 64,
    this.alignment,
  });

  final Color accent;
  final double height;
  final double width;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0),
            accent,
            accent.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class FlipHintRow extends StatelessWidget {
  const FlipHintRow({
    super.key,
    required this.text,
    required this.isStandalone,
    this.showTrailingIcon = false,
    this.leadingIcon = Icons.touch_app_rounded,
    this.trailingIcon = Icons.autorenew_rounded,
    this.spaceBetween = false,
  });

  final String text;
  final bool isStandalone;
  final bool showTrailingIcon;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final bool spaceBetween;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: spaceBetween || isStandalone
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: [
        Icon(leadingIcon,
            size: 12, color: Colors.white.withValues(alpha: 0.60)),
        if (!isStandalone) const SizedBox(width: 6),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        if (showTrailingIcon)
          Icon(trailingIcon,
              size: 12, color: Colors.white.withValues(alpha: 0.60)),
      ],
    );
  }
}
