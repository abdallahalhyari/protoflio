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

  static IconData _iconForCategory(String category) {
    switch (category) {
      case 'Architecture & State':
        return Icons.layers_rounded;
      case 'Mobile Systems':
        return Icons.phone_android_rounded;
      case 'Security & Protocols':
        return Icons.security_rounded;
      case 'Cloud & Infrastructure':
        return Icons.cloud_queue_rounded;
      case 'Domain Expertise':
        return Icons.business_center_rounded;
      case 'Languages & Comm':
        return Icons.terminal_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDarkMode;
    final gold = isDark ? AppColors.goldSoft : AppColors.goldDeep;
    final rule = context.glassBorderStrong;

    Widget label(String g, bool on) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconForCategory(g),
              size: 15,
              color: on ? gold : context.mutedText,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                skillCategoryLabel(l10n, g),
                style: TextStyle(
                  fontSize: AppTypography.body,
                  height: 1.3,
                  fontWeight: on ? FontWeight.w800 : FontWeight.w600,
                  color: on ? context.onSurface : context.mutedText,
                ),
              ),
            ),
          ],
        );

    Widget count(String g, bool on) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: on
                ? gold.withValues(alpha: isDark ? 0.20 : 0.12)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColors.ink100),
            borderRadius: BorderRadius.circular(AppRadius.chip),
            border: Border.all(
              color: on
                  ? gold.withValues(alpha: 0.6)
                  : context.glassBorder.withValues(alpha: 0.3),
              width: 0.8,
            ),
            boxShadow: on
                ? [
                    BoxShadow(
                      color: gold.withValues(alpha: isDark ? 0.3 : 0.15),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          child: Text(
            '${counts[g] ?? 0}',
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.label - 1,
              fontWeight: FontWeight.w800,
              color: on ? context.onSurface : context.mutedText,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        );

    void tap(String g) {
      SoundService.instance.playSelection();
      onSelect(g);
    }

    if (horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            for (final g in groups) ...[
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Semantics(
                  container: true,
                  button: true,
                  selected: g == active,
                  label: '${skillCategoryLabel(l10n, g)}, ${counts[g] ?? 0}',
                  excludeSemantics: true,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    onTap: () => tap(g),
                    child: AnimatedContainer(
                      duration: AppMotion.snap,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: g == active
                            ? gold.withValues(alpha: isDark ? 0.22 : 0.14)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.04)
                                : AppColors.ink100),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(
                          color: g == active
                              ? gold.withValues(alpha: 0.7)
                              : context.glassBorder.withValues(alpha: 0.4),
                          width: g == active ? 1.2 : 1.0,
                        ),
                        boxShadow: g == active
                            ? [
                                BoxShadow(
                                  color: gold.withValues(
                                      alpha: isDark ? 0.25 : 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _iconForCategory(g),
                            size: 13,
                            color: g == active ? gold : context.mutedText,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            skillCategoryLabel(l10n, g),
                            style: TextStyle(
                              fontSize: AppTypography.label,
                              fontWeight: g == active
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: g == active
                                  ? context.onSurface
                                  : context.mutedText,
                            ),
                          ),
                          const SizedBox(width: 6),
                          count(g, g == active),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
              child: AnimatedContainer(
                duration: AppMotion.snap,
                decoration: BoxDecoration(
                  color: groups[i] == active
                      ? gold.withValues(alpha: isDark ? 0.08 : 0.05)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 4),
                          child: Row(
                            children: [
                              Expanded(
                                  child: label(groups[i], groups[i] == active)),
                              const SizedBox(width: 8),
                              count(groups[i], groups[i] == active),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
      ..strokeWidth = on ? 2.0 : 1.5
      ..color = on ? gold.withValues(alpha: 0.8) : tone;
    canvas.drawLine(
        Offset(x, first ? cy : 0), Offset(x, last ? cy : size.height), line);
    if (on) {
      canvas.drawCircle(
        Offset(x, cy),
        10,
        Paint()
          ..color = gold.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
    canvas.drawCircle(
        Offset(x, cy), on ? 5.5 : 3.5, Paint()..color = on ? gold : tone);
  }

  @override
  bool shouldRepaint(_RailPainter old) =>
      old.depth != depth ||
      old.on != on ||
      old.rule != rule ||
      old.gold != gold;
}
