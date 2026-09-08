import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Shared card surface: consistent radius, padding rhythm, border style.
///
/// | Variant | Use when |
/// | ------- | -------- |
/// | `AppCard.outlined()` | Neutral card on a theme scaffold background — used for skill / project / education tiles. Fill is a low-alpha `onSurface` tint; border is a stronger `onSurface` line so the shape reads without competing with hero content. |
/// | `AppCard.filled(color:)` | Card whose identity comes from a brand or category color — used for `HatCard`, where each hat has its own tinted surface. Border is a 12 %-white hairline (`AppColors.borderOverlay`) so any fill color still has a soft edge on dark backgrounds. |
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? _fillOverride;
  final Color? _borderOverride;
  final EdgeInsets padding;
  final double radius;

  const AppCard.outlined({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadius.md,
  })  : _fillOverride = null,
        _borderOverride = null;

  const AppCard.filled({
    super.key,
    required this.child,
    required Color color,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadius.md,
  })  : _fillOverride = color,
        _borderOverride = AppColors.borderOverlay;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill = _fillOverride ?? scheme.onSurface.withValues(alpha: 0.05);
    final borderColor =
        _borderOverride ?? scheme.onSurface.withValues(alpha: 0.18);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
