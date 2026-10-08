import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

/// Glyph for a BlueprintCallout tag. If omitted, pass [BlueprintCallout.number]
/// instead; numeric is appropriate only when the callouts are a legend sequence.
enum CalloutGlyph { diamond, dot, square, triangle }

/// Positional annotation keyed to a diagram element. Renders a tag (number
/// or glyph) + curved leader + label card. The leader is a Bezier, not a
/// straight line, so the composition feels sketched rather than CAD.
///
/// Place inside a `Stack` with [Positioned]; [target] is a local offset to
/// the diagram element the leader should point at.
class BlueprintCallout extends StatelessWidget {
  const BlueprintCallout({
    super.key,
    required this.label,
    required this.target,
    this.number,
    this.glyph,
    this.accent,
  }) : assert(
          number != null || glyph != null,
          'Pass either a number or a glyph for the tag.',
        );

  /// Short descriptive text in the card.
  final String label;

  /// Local offset (relative to this widget's origin) that the leader
  /// points at — typically the diagram feature being called out.
  final Offset target;

  /// Numeric tag (optional). Use when the callouts form a legend sequence.
  final int? number;

  /// Glyph tag (optional). Use when the callouts aren't ordered.
  final CalloutGlyph? glyph;

  /// Accent for tag + leader. Defaults to the theme's primary.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final tone = accent ?? Theme.of(context).colorScheme.primary;
    final isDark = context.isDarkMode;

    // Anchor at (0,0) in this widget's local frame — target can be anywhere.
    // SizedBox gives the Stack bounded constraints; label card can overflow
    // thanks to `clipBehavior: Clip.none`.
    return SizedBox(
      width: target.dx.abs() + 28,
      height: target.dy.abs() + 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: CustomPaint(
              size: Size(target.dx.abs() + 24, target.dy.abs() + 24),
              painter: _LeaderPainter(
                from: const Offset(14, 14),
                to: target,
                color: tone.withValues(alpha: isDark ? 0.55 : 0.45),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: _Tag(number: number, glyph: glyph, tone: tone),
          ),
          Positioned(
            left: 36,
            top: 0,
            child: _LabelCard(label: label),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.number, required this.glyph, required this.tone});
  final int? number;
  final CalloutGlyph? glyph;
  final Color tone;

  String _glyphChar(CalloutGlyph g) => switch (g) {
        CalloutGlyph.diamond => '◆',
        CalloutGlyph.dot => '●',
        CalloutGlyph.square => '■',
        CalloutGlyph.triangle => '▲',
      };

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final content = number != null
        ? Text(
            number.toString().padLeft(2, '0'),
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              color: tone,
              fontSize: AppTypography.label,
              fontWeight: FontWeight.w800,
              height: 1.0,
            ),
          )
        : Text(
            _glyphChar(glyph!),
            style: TextStyle(
              color: tone,
              fontSize: AppTypography.label,
              height: 1.0,
            ),
          );
    return Semantics(
      label: 'Callout ${number ?? ''} ${glyph?.name ?? ''}'.trim(),
      child: Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.cardStock,
          shape: BoxShape.circle,
          border: Border.all(color: tone, width: 1.2),
        ),
        child: content,
      ),
    );
  }
}

class _LabelCard extends StatefulWidget {
  const _LabelCard({required this.label});
  final String label;

  @override
  State<_LabelCard> createState() => _LabelCardState();
}

class _LabelCardState extends State<_LabelCard> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _visible = true),
      onExit: (_) => setState(() => _visible = false),
      child: GestureDetector(
        onTap: () => setState(() => _visible = !_visible),
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: AppMotion.sm,
          child: IgnorePointer(
            ignoring: !_visible,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: context.cardGlass,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: context.glassBorder),
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: context.onSurface,
                  fontSize: AppTypography.body,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeaderPainter extends CustomPainter {
  const _LeaderPainter({
    required this.from,
    required this.to,
    required this.color,
  });

  final Offset from;
  final Offset to;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Bezier curve — one control point offset perpendicular to the line,
    // so the leader bows out rather than running straight.
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final mid = Offset(from.dx + dx / 2, from.dy + dy / 2);
    final perpX = -dy;
    final perpY = dx;
    final mag = math.sqrt(perpX * perpX + perpY * perpY);
    final norm = mag <= 0 ? 1.0 : mag;
    const bow = 18.0;
    final control = Offset(
      mid.dx + perpX / norm * bow,
      mid.dy + perpY / norm * bow,
    );

    final path = Path()
      ..moveTo(from.dx, from.dy)
      ..quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);
    canvas.drawPath(path, paint);

    // Small terminator dot at the target end — reads as "pointing here".
    canvas.drawCircle(to, 2.0, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LeaderPainter oldDelegate) =>
      oldDelegate.from != from ||
      oldDelegate.to != to ||
      oldDelegate.color != color;
}
