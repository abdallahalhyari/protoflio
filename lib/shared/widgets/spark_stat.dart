import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// A stat value with a tiny stroke-ramp sparkline and optional delta.
///
/// The sparkline grows thicker toward the latest sample — a "signal
/// strength" cue instead of the default gradient fill that reads as the
/// generic SaaS metric card.
///
/// Pass [invertedGood] when a lower trend is the good outcome (latency,
/// errors). The delta chip's color flips so the signal always matches
/// the intent, not the arithmetic.
class SparkStat extends StatelessWidget {
  const SparkStat({
    super.key,
    required this.value,
    required this.label,
    required this.samples,
    this.accent,
    this.invertedGood = false,
  });

  final String value;
  final String label;

  /// Chronological samples. Last entry = most recent.
  final List<double> samples;

  /// Series accent. Falls back to the theme primary.
  final Color? accent;

  /// If true, a downward delta is good and gets the ok color.
  final bool invertedGood;

  double get _delta {
    final first = samples.first;
    final last = samples.last;
    if (first == 0) return 0;
    return ((last - first) / first) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final tone = accent ?? Theme.of(context).colorScheme.primary;
    return Semantics(
      label: _a11yLabel(),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ValueBlock(value: value, label: label),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: 56,
              height: 28,
              child: CustomPaint(
                painter: _SparkPainter(
                  samples: samples,
                  accent: tone,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _DeltaChip(delta: _delta, invertedGood: invertedGood),
          ],
        ),
      ),
    );
  }

  String _a11yLabel() {
    final direction = _delta > 0.1
        ? 'up'
        : _delta < -0.1
            ? 'down'
            : 'flat';
    return '$label: $value, trend $direction ${_delta.abs().toStringAsFixed(1)} percent';
  }
}

class _ValueBlock extends StatelessWidget {
  const _ValueBlock({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: context.onSurface,
            fontSize: AppTypography.display,
            fontWeight: FontWeight.w900,
            height: 1.0,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.monoFont,
            color: context.mutedText,
            fontSize: AppTypography.label,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _DeltaChip extends StatelessWidget {
  const _DeltaChip({required this.delta, required this.invertedGood});
  final double delta;
  final bool invertedGood;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final flat = delta.abs() < 0.1;
    // Resolve "did the metric move in a good direction?" first.
    final goodDirection = invertedGood ? delta < 0 : delta > 0;
    final color = flat
        ? context.mutedText
        : (goodDirection
            ? (isDark ? AppColors.tealLight : AppColors.tealDeep)
            : (isDark ? AppColors.signalLight : AppColors.signalDeep));
    final glyph = flat
        ? Icons.remove_rounded
        : (delta > 0
            ? Icons.arrow_upward_rounded
            : Icons.arrow_downward_rounded);
    final text = flat ? '—' : '${delta.abs().toStringAsFixed(1)}%';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(glyph, size: 12, color: color),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            fontFamily: AppTypography.monoFont,
            color: color,
            fontSize: AppTypography.label,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _SparkPainter extends CustomPainter {
  const _SparkPainter({required this.samples, required this.accent});
  final List<double> samples;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.length < 2) return;
    final minV = samples.reduce((a, b) => a < b ? a : b);
    final maxV = samples.reduce((a, b) => a > b ? a : b);
    final range = (maxV - minV).abs() < 0.0001 ? 1.0 : (maxV - minV);
    final stepX = size.width / (samples.length - 1);

    double y(double v) => size.height - ((v - minV) / range) * size.height;

    // Stroke-width ramps 0.8 → 2.0 across the series.
    final segments = samples.length - 1;
    for (var i = 0; i < segments; i++) {
      final t = i / segments;
      final width = 0.8 + (2.0 - 0.8) * t;
      final paint = Paint()
        ..color = accent.withValues(alpha: 0.5 + 0.5 * t)
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final p0 = Offset(stepX * i, y(samples[i]));
      final p1 = Offset(stepX * (i + 1), y(samples[i + 1]));
      canvas.drawLine(p0, p1, paint);
    }

    // End marker — solid dot at the most recent point.
    canvas.drawCircle(
      Offset(size.width, y(samples.last)),
      2.4,
      Paint()..color = accent,
    );
  }

  @override
  bool shouldRepaint(_SparkPainter oldDelegate) =>
      oldDelegate.samples != samples || oldDelegate.accent != accent;
}
