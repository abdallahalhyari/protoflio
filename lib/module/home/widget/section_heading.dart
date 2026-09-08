import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

/// Editorial section heading: a small monospaced index label ("01/07"),
/// a huge outlined chapter numeral behind the title, and the title
/// itself rendered on top. Meant for the Skills / Projects / Experience
/// pages so their headings feel like magazine chapters rather than
/// generic page titles.
///
/// On first mount the outlined numeral counts up from `00` to its
/// target ordinal (~800 ms) — small odometer flourish so the chapter
/// entry reads as intentional. Count-up is skipped when
/// `MediaQueryData.disableAnimations` is on.
class SectionHeading extends StatefulWidget {
  final int index;
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
  State<SectionHeading> createState() => _SectionHeadingState();
}

class _SectionHeadingState extends State<SectionHeading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) {
      _c.value = 1;
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.index + 1;
    final ordinal = target.toString().padLeft(2, '0');
    final totalStr = widget.total.toString().padLeft(2, '0');

    final numeralSize = widget.titleSize * 3.4;
    final outlinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = widget.color.withValues(alpha: 0.08);

    return SizedBox(
      height: numeralSize * 0.92,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: AnimatedBuilder(
                animation: _t,
                builder: (_, __) {
                  final current = (target * _t.value).round();
                  return Text(
                    current.toString().padLeft(2, '0'),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: numeralSize,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -6,
                      foreground: outlinePaint,
                    ),
                  );
                },
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
                  color: widget.color.withValues(alpha: 0.55),
                  fontSize: AppTypography.micro,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.color,
                  fontSize: widget.titleSize,
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
