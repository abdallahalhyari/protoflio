import 'package:flutter/material.dart';

/// Editorial `— LABEL —` kicker: hairline rule, small-caps letter-spaced
/// label, hairline rule. Every page's "eyebrow" strip goes through this
/// so masthead / issue-strip / kicker treatment is identical across the
/// portfolio.
///
/// ```dart
/// SectionKicker(
///   label: 'ESSAY 01 · OPERATING PHILOSOPHY',
///   color: AppColors.accentIndigoSoft,
///   ruleColor: AppColors.accentIndigo,
/// )
/// ```
class SectionKicker extends StatelessWidget {
  final String label;
  final Color color;
  final Color ruleColor;
  final double fontSize;
  final double letterSpacing;
  final double ruleWidth;

  const SectionKicker({
    super.key,
    required this.label,
    this.color = Colors.white,
    Color? ruleColor,
    this.fontSize = 11,
    this.letterSpacing = 4,
    this.ruleWidth = 32,
  }) : ruleColor = ruleColor ?? color;

  @override
  Widget build(BuildContext context) {
    Widget rule() => Container(
        width: ruleWidth,
        height: 1,
        color: ruleColor.withValues(alpha: 0.75));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        rule(),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: letterSpacing,
          ),
        ),
        const SizedBox(width: 10),
        rule(),
      ],
    );
  }
}
