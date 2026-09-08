import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

/// Editorial section heading: a small monospaced index label ("01/07"),
/// a huge outlined chapter numeral behind the title, and the title
/// itself rendered on top. Meant for the Skills / Projects / Experience
/// pages so their headings feel like magazine chapters rather than
/// generic page titles.
class SectionHeading extends StatelessWidget {
  final int index; // 0-based
  final int total;
  final String title;
  final double titleSize;
  final Color color;

  const SectionHeading({
    super.key,
    required this.index,
    required this.total,
    required this.title,
    required this.titleSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ordinal = (index + 1).toString().padLeft(2, '0');
    final totalStr = total.toString().padLeft(2, '0');

    final numeralSize = titleSize * 3.4;
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = color.withValues(alpha: 0.08);

    return SizedBox(
      height: numeralSize * 0.92,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                ordinal,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: numeralSize,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -6,
                  foreground: outlinePaint,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$ordinal / $totalStr',
                style: TextStyle(
                  color: color.withValues(alpha: 0.55),
                  fontSize: AppTypography.micro,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
