import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';

/// Where to draw the hairline accent rule relative to the label.
enum KickerRule { none, leading, trailing }

/// Magazine-style section overline: optional numeric badge + uppercase
/// label + optional hairline rule.
///
/// Replaces ~10 hand-rolled `Text(fontSize: overline, letterSpacing: 1.6, …)`
/// combos across intro / experience / case_study pages.
class SectionKicker extends StatelessWidget {
  const SectionKicker({
    super.key,
    required this.label,
    this.number,
    this.rule = KickerRule.none,
    this.tone,
  });

  /// Uppercase section title. Not localized here — pass a translated string.
  final String label;

  /// Optional two-digit section number ("01", "02"). Rendered before label.
  final String? number;

  /// Where the 40×2 hairline accent bar sits.
  final KickerRule rule;

  /// Accent color for number + rule. Defaults to the current theme's
  /// muted text (subdued). Pass a `Theme.of(context).colorScheme.primary`
  /// or an accent for a stronger read.
  final Color? tone;

  static const double _ruleWidth = 40;
  static const double _ruleHeight = 2;

  @override
  Widget build(BuildContext context) {
    final accent = tone ?? context.mutedText;
    final labelStyle = TextStyle(
      color: context.onSurface,
      fontFamily: AppTypography.monoFont,
      fontSize: AppTypography.overline,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
    );

    Widget? ruleBar;
    if (rule != KickerRule.none) {
      ruleBar = Container(
        width: _ruleWidth,
        height: _ruleHeight,
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(AppRadius.hairline),
        ),
      );
    }

    final row = <Widget>[
      if (rule == KickerRule.leading && ruleBar != null) ...[
        ruleBar,
        const SizedBox(width: AppSpacing.md),
      ],
      if (number != null) ...[
        Text(
          number!,
          style: labelStyle.copyWith(color: accent, fontWeight: FontWeight.w900),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
      Flexible(child: Text(label, style: labelStyle)),
      if (rule == KickerRule.trailing && ruleBar != null) ...[
        const SizedBox(width: AppSpacing.md),
        ruleBar,
      ],
    ];

    return Semantics(
      header: true,
      label: number == null ? label : '$number $label',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: row,
        ),
      ),
    );
  }
}
