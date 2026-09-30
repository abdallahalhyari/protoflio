import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/intro/widget/hero_motion.dart';

class HeroWordmark extends StatelessWidget {
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
    final wordmarkHeight = isCompactH
        ? (size.height * 0.17).clamp(95.0, 165.0)
        : (isWide
            ? (size.height * 0.21).clamp(120.0, 240.0)
            : (size.height * 0.16).clamp(85.0, 160.0));

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
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  final alpha = isDark ? 0.46 : 0.7;
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (isDark ? Colors.white : AppColors.slate700)
                          .withValues(alpha: alpha),
                      (isDark
                              ? AppColors.accentIndigo
                              : AppColors.accentIndigo600)
                          .withValues(alpha: alpha + 0.08),
                      AppColors.accentViolet.withValues(alpha: alpha),
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ).createShader(bounds);
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
