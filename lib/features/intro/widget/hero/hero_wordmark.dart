import 'dart:async';

import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/intro/widget/hero_motion.dart';

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

/// The outlined wordmark gets one pass of light across its strokes as the
/// boot screen dissolves, then rests on its plain gradient. The sheen lives
/// in the gradient the wordmark is already masked with, so it adds no layer;
/// it repaints only the wordmark, for 1.2s, once.
class _HeroWordmarkState extends State<HeroWordmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheen = AnimationController(
    vsync: this,
    duration: AppMotion.heroSheen,
  );
  Timer? _start;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_start != null || _sheen.isCompleted) return;
    if (AppMedia.reduceMotion(context)) {
      _sheen.value = 1;
      return;
    }
    // Starts while the boot screen is still fading, so the light lands as
    // the wordmark comes into full view.
    _start = Timer(AppMotion.md, () {
      if (mounted) _sheen.forward();
    });
  }

  @override
  void dispose() {
    _start?.cancel();
    _sheen.dispose();
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
    final size = widget.size;
    final wordmarkHeight = widget.isCompactH
        ? (size.height * 0.17).clamp(95.0, 165.0)
        : (widget.isWide
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
              child: AnimatedBuilder(
                animation: _sheen,
                builder: (context, child) => ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => heroWordmarkGradient(
                    isDark: widget.isDark,
                    sheen: _sheen.isAnimating ? _sheen.value : null,
                  ).createShader(bounds),
                  child: child,
                ),
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

/// Half-width of the sheen's light band, in gradient units (0..1 across
/// the wordmark's diagonal).
const double _sheenBand = 0.14;

/// The wordmark's resting gradient, with a band of light at [sheen]
/// (0 → 1 carries it from before the first letter to past the last).
@visibleForTesting
LinearGradient heroWordmarkGradient({
  required bool isDark,
  double? sheen,
}) {
  final alpha = isDark ? 0.46 : 0.7;
  final base = <(double, Color)>[
    (
      0.0,
      (isDark ? Colors.white : AppColors.slate700).withValues(alpha: alpha)
    ),
    (
      0.55,
      (isDark ? AppColors.accentIndigo : AppColors.accentIndigo600)
          .withValues(alpha: alpha + 0.08)
    ),
    (1.0, AppColors.accentViolet.withValues(alpha: alpha)),
  ];

  if (sheen == null) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [for (final (_, c) in base) c],
      stops: [for (final (s, _) in base) s],
    );
  }

  Color baseAt(double t) {
    for (var i = 1; i < base.length; i++) {
      final (s0, c0) = base[i - 1];
      final (s1, c1) = base[i];
      if (t <= s1) return Color.lerp(c0, c1, (t - s0) / (s1 - s0))!;
    }
    return base.last.$2;
  }

  final highlight = isDark ? Colors.white : AppColors.accentIndigo600;
  final center = -_sheenBand +
      AppMotion.easeInOutSine.transform(sheen) * (1 + 2 * _sheenBand);
  final stops = <double>{
    for (final (s, _) in base) s,
    for (final s in [center - _sheenBand, center, center + _sheenBand])
      s.clamp(0.0, 1.0),
  }.toList()
    ..sort();

  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: stops,
    colors: [
      for (final t in stops)
        Color.lerp(
          baseAt(t),
          highlight.withValues(alpha: 0.95),
          (1 - (t - center).abs() / _sheenBand).clamp(0.0, 1.0),
        )!,
    ],
  );
}
