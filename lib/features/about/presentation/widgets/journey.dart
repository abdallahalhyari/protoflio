import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

/// The four roles as one path down the stack, screen at the top, hardware
/// at the bottom. The line darkens to gold as it goes down, the same
/// vocabulary as the hero's trace.
class Journey extends StatelessWidget {
  const Journey({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;
    final rule = context.glassBorderStrong;
    final muted = context.mutedText;

    final stops = [
      ('2021', 'Future Advanced Internet Solutions', l10n.aboutJourneyFais),
      ('2021–2022', 'Solutions Now IT', l10n.aboutJourneySolutions),
      ('2022–2024', 'ESKADENIA Software', l10n.aboutJourneyEskadenia),
      ('2024–${l10n.aboutJourneyNow}', 'NatHealth', l10n.aboutJourneyNatHealth),
    ];

    Widget end(String text) => Padding(
          padding: const EdgeInsetsDirectional.only(start: 28),
          child: Text(
            text,
            style: TextStyle(fontSize: AppTypography.label, color: muted),
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.aboutJourneyTitle,
          style: TextStyle(
            fontSize: AppTypography.lead,
            fontWeight: FontWeight.w700,
            color: context.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        end(l10n.aboutJourneyTop),
        const SizedBox(height: 6),
        for (var i = 0; i < stops.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28,
                  child: CustomPaint(
                    painter: _StopPainter(
                      // 0 at the screen end, 1 at the hardware end.
                      depth: i / (stops.length - 1),
                      first: i == 0,
                      last: i == stops.length - 1,
                      rule: rule,
                      gold: gold,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stops[i].$1,
                          style: TextStyle(
                            fontSize: AppTypography.label,
                            fontWeight: FontWeight.w700,
                            color: Color.lerp(muted, gold, i / 3),
                          ),
                        ),
                        Text(
                          stops[i].$2,
                          style: TextStyle(
                            fontSize: AppTypography.body,
                            fontWeight: FontWeight.w700,
                            color: context.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stops[i].$3,
                          style: TextStyle(
                            fontSize: AppTypography.body,
                            height: 1.45,
                            color: context.onSurface.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        end(l10n.aboutJourneyBottom),
      ],
    );
  }
}

class _StopPainter extends CustomPainter {
  _StopPainter({
    required this.depth,
    required this.first,
    required this.last,
    required this.rule,
    required this.gold,
  });

  final double depth;
  final bool first;
  final bool last;
  final Color rule;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    const x = 7.0;
    const dotY = 8.0;
    final line = Paint()
      ..strokeWidth = 1.5
      ..color = Color.lerp(rule, gold, depth)!;
    canvas.drawLine(const Offset(x, 0), Offset(x, size.height), line);
    canvas.drawCircle(
      const Offset(x, dotY),
      5,
      Paint()..color = Color.lerp(rule, gold, depth)!,
    );
    if (last) {
      canvas.drawCircle(
        const Offset(x, dotY),
        9,
        Paint()
          ..color = gold.withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
  }

  @override
  bool shouldRepaint(_StopPainter old) =>
      old.depth != depth || old.rule != rule || old.gold != gold;
}
