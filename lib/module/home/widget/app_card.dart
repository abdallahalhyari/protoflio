import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Shared card surface: consistent radius, padding rhythm, border style.
/// Two constructors:
///  - `AppCard.outlined()` — dark surface tinted from Theme with onSurface border.
///  - `AppCard.filled(color: ...)` — solid brand color with subtle white border.
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
        _borderOverride = const Color(0x1FFFFFFF); // white @ ~12%

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
