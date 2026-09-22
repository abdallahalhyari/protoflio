import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';

/// Semantic role for a [StatusBadge]. Maps to `AppColors.status*` tokens.
enum BadgeStatus {
  critical('Critical', AppColors.statusCritical),
  warn('Warning', AppColors.statusWarn),
  ok('OK', AppColors.statusOk),
  info('Info', AppColors.statusInfo);

  const BadgeStatus(this.roleLabel, this.color);

  /// Fallback screen-reader announcement when no `label` is provided.
  final String roleLabel;

  /// Fill color for the dot / pill.
  final Color color;
}

/// Two size steps. Dot diameter + label size scale together.
enum BadgeSize { sm, md }

/// Compact status indicator tying `AppColors.status*` tokens to a
/// dot / dot+label / pill trio.
///
/// Replaces the ~20 hand-rolled `Container(BoxDecoration(shape:circle))`
/// patterns that used to encode traffic-light state ad-hoc.
///
/// Screen readers hear `"<role>: <label>"` even when the visual is
/// dot-only — the [BadgeStatus.roleLabel] fallback keeps meaning intact.
class StatusBadge extends StatelessWidget {
  /// Dot only. Use for terminal chrome, inline bullets in dense rows.
  const StatusBadge.dot({
    super.key,
    required this.status,
    this.size = BadgeSize.sm,
  })  : label = null,
        _variant = _Variant.dot;

  /// Dot + monospace label. Use for health rows, monitor grids.
  const StatusBadge.dotLabel({
    super.key,
    required this.status,
    required String this.label,
    this.size = BadgeSize.sm,
  }) : _variant = _Variant.dotLabel;

  /// Filled pill — tinted background + status-color border and text.
  const StatusBadge.pill({
    super.key,
    required this.status,
    required String this.label,
    this.size = BadgeSize.md,
  }) : _variant = _Variant.pill;

  final BadgeStatus status;
  final String? label;
  final BadgeSize size;
  final _Variant _variant;

  double get _dotDiameter => size == BadgeSize.sm ? 8 : 10;
  double get _fontSize =>
      size == BadgeSize.sm ? AppTypography.micro : AppTypography.caption;

  @override
  Widget build(BuildContext context) {
    final semanticsLabel =
        label == null ? status.roleLabel : '${status.roleLabel}: $label';

    Widget visual;
    switch (_variant) {
      case _Variant.dot:
        visual = _dot();
        break;
      case _Variant.dotLabel:
        visual = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(),
            const SizedBox(width: AppSpacing.sm),
            _label(context),
          ],
        );
        break;
      case _Variant.pill:
        visual = Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smd,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: status.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: status.color.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: _label(context),
        );
        break;
    }

    return Semantics(
      label: semanticsLabel,
      container: true,
      child: ExcludeSemantics(child: visual),
    );
  }

  Widget _dot() => Container(
        width: _dotDiameter,
        height: _dotDiameter,
        decoration: BoxDecoration(
          color: status.color,
          shape: BoxShape.circle,
        ),
      );

  Widget _label(BuildContext context) => Text(
        label!,
        style: TextStyle(
          fontFamily: AppTypography.monoFont,
          color: status.color,
          fontSize: _fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      );
}

enum _Variant { dot, dotLabel, pill }
