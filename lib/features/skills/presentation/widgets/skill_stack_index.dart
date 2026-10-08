import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/skills/presentation/utils/skill_category_labels.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Order of the skill groups, top of the stack first: how an app is
/// structured, the mobile platforms, the security and protocol layer, the
/// services behind it, then the domains and languages around the code.
const List<String> kSkillStackOrder = [
  'Architecture & State',
  'Mobile Systems',
  'Security & Protocols',
  'Cloud & Infrastructure',
  'Domain Expertise',
  'Languages & Comm',
];

/// The skill groups as one vertical path, the hero trace's vocabulary: the
/// line warms to gold going down, the current group is lit. Tapping a
/// group scrolls the list to it.
class SkillStackIndex extends StatelessWidget {
  const SkillStackIndex({
    super.key,
    required this.groups,
    required this.counts,
    required this.active,
    required this.onSelect,
    this.horizontal = false,
  });

  final List<String> groups;
  final Map<String, int> counts;
  final String? active;
  final ValueChanged<String> onSelect;

  /// Phones and tablets: a single scrolling row instead of the rail.
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gold = context.isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;
    final rule = context.glassBorderStrong;

    Widget label(String g, bool on) => Text(
          skillCategoryLabel(l10n, g),
          style: TextStyle(
            fontSize: AppTypography.body,
            height: 1.3,
            fontWeight: on ? FontWeight.w700 : FontWeight.w500,
            color: on ? context.onSurface : context.mutedText,
          ),
        );

    Widget count(String g) => Text(
          '${counts[g] ?? 0}',
          style: TextStyle(
            fontSize: AppTypography.label,
            color: context.mutedText,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );

    void tap(String g) {
      SoundService.instance.playSelection();
      onSelect(g);
    }

    if (horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final g in groups)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 20),
                child: Semantics(
                  container: true,
                  button: true,
                  selected: g == active,
                  label: '${skillCategoryLabel(l10n, g)}, ${counts[g] ?? 0}',
                  excludeSemantics: true,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    onTap: () => tap(g),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          label(g, g == active),
                          const SizedBox(width: 6),
                          count(g),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < groups.length; i++)
          Semantics(
            container: true,
            button: true,
            selected: groups[i] == active,
            label: '${skillCategoryLabel(l10n, groups[i])}, '
                '${counts[groups[i]] ?? 0}',
            excludeSemantics: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: () => tap(groups[i]),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 22,
                      child: CustomPaint(
                        painter: _RailPainter(
                          depth:
                              groups.length < 2 ? 1 : i / (groups.length - 1),
                          first: i == 0,
                          last: i == groups.length - 1,
                          on: groups[i] == active,
                          rule: rule,
                          gold: gold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: label(groups[i], groups[i] == active)),
                            const SizedBox(width: 8),
                            count(groups[i]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _RailPainter extends CustomPainter {
  _RailPainter({
    required this.depth,
    required this.first,
    required this.last,
    required this.on,
    required this.rule,
    required this.gold,
  });

  final double depth;
  final bool first;
  final bool last;
  final bool on;
  final Color rule;
  final Color gold;

  @override
  void paint(Canvas canvas, Size size) {
    const x = 6.0;
    final cy = size.height / 2;
    final tone = Color.lerp(rule, gold, depth)!;
    final line = Paint()
      ..strokeWidth = 1.5
      ..color = tone;
    canvas.drawLine(
        Offset(x, first ? cy : 0), Offset(x, last ? cy : size.height), line);
    if (on) {
      canvas.drawCircle(
        Offset(x, cy),
        9,
        Paint()
          ..color = gold.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
    }
    canvas.drawCircle(
        Offset(x, cy), on ? 5 : 3.5, Paint()..color = on ? gold : tone);
  }

  @override
  bool shouldRepaint(_RailPainter old) =>
      old.depth != depth ||
      old.on != on ||
      old.rule != rule ||
      old.gold != gold;
}
