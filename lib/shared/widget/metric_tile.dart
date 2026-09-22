import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Direction of a `MetricTile` delta indicator.
enum DeltaDirection { up, down, flat }

/// Delta annotation shown under a metric value (e.g. "+12.4% vs last month").
class MetricDelta {
  const MetricDelta({
    required this.direction,
    required this.magnitude,
    this.suffix = '',
  });

  const MetricDelta.up(this.magnitude, [this.suffix = ''])
      : direction = DeltaDirection.up;
  const MetricDelta.down(this.magnitude, [this.suffix = ''])
      : direction = DeltaDirection.down;
  const MetricDelta.flat([this.suffix = ''])
      : direction = DeltaDirection.flat,
        magnitude = 0;

  final DeltaDirection direction;

  /// Absolute delta percentage. `.flat` ignores this.
  final double magnitude;

  /// Trailing context ("vs last month"). Optional.
  final String suffix;
}

/// Size tier — controls value font, tile radius, and label size.
enum MetricSize { sm, md, lg }

/// Bento-style stat display: big number + label + optional delta arrow.
///
/// Replaces bespoke `Column(Text bignum, Text label, Row(arrow, delta))`
/// blocks across projects / experience / case_study pages.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.value,
    required this.label,
    this.delta,
    this.size = MetricSize.md,
    this.onTap,
  });

  final String value;
  final String label;
  final MetricDelta? delta;
  final MetricSize size;
  final VoidCallback? onTap;

  double get _valueFont => switch (size) {
        MetricSize.sm => AppTypography.titleLg,
        MetricSize.md => AppTypography.displaySm,
        MetricSize.lg => AppTypography.heroSm,
      };
  double get _labelFont => switch (size) {
        MetricSize.sm => AppTypography.micro,
        MetricSize.md => AppTypography.caption,
        MetricSize.lg => AppTypography.small,
      };
  double get _radius => switch (size) {
        MetricSize.sm => AppRadius.sm,
        MetricSize.md => AppRadius.tile,
        MetricSize.lg => AppRadius.card,
      };
  EdgeInsets get _padding => switch (size) {
        MetricSize.sm =>
          const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        MetricSize.md => const EdgeInsets.all(AppSpacing.md),
        MetricSize.lg => const EdgeInsets.all(AppSpacing.lg),
      };

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(color: context.glassBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: context.onSurface,
              fontSize: _valueFont,
              fontWeight: FontWeight.w900,
              height: 1.0,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              color: context.mutedText,
              fontFamily: AppTypography.monoFont,
              fontSize: _labelFont,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _DeltaRow(delta: delta!, mono: AppTypography.monoFont),
          ],
        ],
      ),
    );

    final semanticsLabel = _semanticsLabel();

    if (onTap == null) {
      return Semantics(label: semanticsLabel, child: ExcludeSemantics(child: content));
    }
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: ExcludeSemantics(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_radius),
            onTap: onTap,
            child: content,
          ),
        ),
      ),
    );
  }

  String _semanticsLabel() {
    final base = '$label: $value';
    if (delta == null) return base;
    final d = delta!;
    switch (d.direction) {
      case DeltaDirection.up:
        return '$base, up ${d.magnitude.toStringAsFixed(1)} percent ${d.suffix}'.trim();
      case DeltaDirection.down:
        return '$base, down ${d.magnitude.toStringAsFixed(1)} percent ${d.suffix}'.trim();
      case DeltaDirection.flat:
        return '$base, unchanged ${d.suffix}'.trim();
    }
  }
}

class _DeltaRow extends StatelessWidget {
  const _DeltaRow({required this.delta, required this.mono});

  final MetricDelta delta;
  final String mono;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (delta.direction) {
      DeltaDirection.up =>
        (Icons.arrow_upward_rounded, AppColors.statusOk),
      DeltaDirection.down =>
        (Icons.arrow_downward_rounded, AppColors.statusCritical),
      DeltaDirection.flat =>
        (Icons.remove_rounded, context.mutedText),
    };

    final text = switch (delta.direction) {
      DeltaDirection.flat => delta.suffix.isEmpty ? '—' : delta.suffix,
      _ => '${delta.magnitude.toStringAsFixed(1)}%'
          '${delta.suffix.isEmpty ? '' : ' ${delta.suffix}'}',
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppTypography.body, color: color),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontFamily: mono,
              fontSize: AppTypography.micro,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
