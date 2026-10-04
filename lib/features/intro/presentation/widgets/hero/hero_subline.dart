import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/intro/presentation/widgets/hero_motion.dart';
import 'package:profile/shared/widgets/retrying_asset_image.dart';

class HeroSubline extends StatelessWidget {
  final Size size;
  final bool isWide;
  final bool isDark;
  final bool isCompactH;
  final Animation<double> rimAnimation;

  const HeroSubline({
    super.key,
    required this.size,
    required this.isWide,
    required this.isDark,
    required this.isCompactH,
    required this.rimAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final letterSize = isCompactH
        ? (size.width * 0.03).clamp(18.0, 32.0)
        : (size.width * 0.035).clamp(20.0, 40.0);
    final portraitSize = isCompactH
        ? (size.height * 0.082).clamp(52.0, 78.0)
        : (isWide
            ? (size.height * 0.095).clamp(60.0, 96.0)
            : (size.width * 0.12).clamp(56.0, 80.0));

    final content = isWide
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroPortrait(size: portraitSize, animation: rimAnimation),
              SizedBox(width: portraitSize * 0.26),
              ExcludeSemantics(
                  child: Text(
                'ALHYARI',
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  fontSize: letterSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 12,
                  color: context.onSurface,
                  shadows: isDark
                      ? [
                          const Shadow(blurRadius: 16),
                          Shadow(color: AppColors.glowIndigo, blurRadius: 24),
                        ]
                      : const [Shadow(color: Colors.black12, blurRadius: 4)],
                ),
              )),
            ],
          )
        : Column(
            children: [
              HeroPortrait(size: portraitSize, animation: rimAnimation),
              const SizedBox(height: AppSpacing.smd),
              ExcludeSemantics(
                  child: Text(
                'ALHYARI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTypography.displayFont,
                  fontSize: letterSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 10,
                  color: context.onSurface,
                  shadows: isDark
                      ? [
                          const Shadow(blurRadius: 8),
                          Shadow(color: AppColors.glowIndigo, blurRadius: 12),
                        ]
                      : const [Shadow(color: Colors.black12, blurRadius: 2)],
                ),
              )),
            ],
          );

    return SnappyEntrance(
      delayMs: 30,
      child: isWide ? HeroParallax(child: content) : content,
    );
  }
}

class HeroPortrait extends StatelessWidget {
  final double size;
  final Animation<double> animation;
  static const _gold = AppColors.accentAmberSoft;

  const HeroPortrait({super.key, required this.size, required this.animation});

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(13.5),
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.4),
        child: Hero(
          tag: 'abdallah_avatar_headshot',
          child: RetryingAssetImage(
            'assets/my_image.webp',
            fit: BoxFit.cover,
            cacheWidth: 280,
            cacheHeight: 280,
            filterQuality: FilterQuality.high,
            semanticLabel: AppLocalizations.of(context)!.semanticPortrait,
          ),
        ),
      ),
    );

    return Semantics(
      label: AppLocalizations.of(context)!.semanticPortrait,
      image: true,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.40),
              blurRadius: 36,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: AppColors.accentViolet.withValues(alpha: 0.18),
              blurRadius: 48,
              spreadRadius: 4,
            ),
          ],
        ),
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: animation,
            child: image,
            builder: (context, child) {
              final angle = animation.value * 2 * 3.14159265;
              return Container(
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  gradient: SweepGradient(
                    transform: GradientRotation(angle),
                    colors: [
                      accent,
                      _gold.withValues(alpha: 0.9),
                      AppColors.accentVioletLight,
                      accent,
                    ],
                    stops: const [0.0, 0.3, 0.65, 1.0],
                  ),
                ),
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
