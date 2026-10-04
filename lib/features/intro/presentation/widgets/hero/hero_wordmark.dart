import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';

class HeroWordmark extends StatefulWidget {
  final Size size;
  final bool isDark;
  final bool isCompactH;
  final bool isWide;

  const HeroWordmark({
    super.key,
    required this.size,
    required this.isDark,
    required this.isCompactH,
    required this.isWide,
  });

  @override
  State<HeroWordmark> createState() => _HeroWordmarkState();
}

class _HeroWordmarkState extends State<HeroWordmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  TextStyle _wordmarkStyle() {
    return TextStyle(
      fontFamily: AppTypography.displayFont,
      fontSize: AppTypography.watermark,
      fontWeight: FontWeight.w900,
      letterSpacing: 10,
      height: 1.0,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordmarkHeight = widget.isCompactH
        ? (widget.size.height * 0.17).clamp(95.0, 165.0)
        : (widget.isWide
            ? (widget.size.height * 0.21).clamp(120.0, 240.0)
            : (widget.size.height * 0.16).clamp(85.0, 160.0));

    return SnappyEntrance(
      child: Semantics(
        header: true,
        headingLevel: 1,
        label: AppLocalizations.of(context)!.semanticTitle,
        excludeSemantics: true,
        child: SizedBox(
          height: wordmarkHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FittedBox(
              child: AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, child) {
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      final alpha = widget.isDark ? 0.46 : 0.7;
                      return LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (widget.isDark ? Colors.white : AppColors.slate700)
                              .withValues(alpha: alpha),
                          (widget.isDark
                                  ? AppColors.accentIndigo
                                  : AppColors.accentIndigo600)
                              .withValues(alpha: alpha + 0.15),
                          AppColors.accentViolet.withValues(alpha: alpha),
                        ],
                        stops: const [0.0, 0.55, 1.0],
                        transform: GradientRotation(
                            _shimmerController.value * 2 * 3.14159),
                      ).createShader(bounds);
                    },
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppTypography.watermark * 0.12,
                  ),
                  child: Text(
                    'ABDALLAH',
                    style: _wordmarkStyle(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
