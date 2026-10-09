import 'package:flutter/material.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/presentation/utils/skill_category_labels.dart';
import 'package:profile/features/skills/presentation/widgets/skill_category_filters.dart';
import 'package:profile/features/skills/presentation/widgets/tile/bento_skill_tile_shared.dart';
import 'package:profile/l10n/app_localizations.dart';

/// Skills as a dense, scannable list grouped by area. Each row shows the
/// skill, where it was used and a four-step level; tap a row for the
/// detail and tags.
class SkillList extends StatelessWidget {
  const SkillList({
    super.key,
    required this.skills,
    required this.isDesktop,
    this.order = const [],
    this.groupKeys = const {},
  });

  final List<Skill> skills;
  final bool isDesktop;

  /// Group order (categories); groups not listed follow in data order.
  final List<String> order;

  /// Keys placed on each group's heading so an index can scroll to it.
  final Map<String, GlobalKey> groupKeys;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    // Group by category, keeping the order skills first appear in.
    final unordered = <String, List<Skill>>{};
    for (final s in skills) {
      unordered.putIfAbsent(s.category, () => []).add(s);
    }
    final groups = <String, List<Skill>>{
      for (final c in order)
        if (unordered.containsKey(c)) c: unordered[c]!,
      for (final e in unordered.entries)
        if (!order.contains(e.key)) e.key: e.value,
    };
    final showHeadings = groups.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in groups.entries) ...[
          if (showHeadings)
            Padding(
              key: groupKeys[entry.key],
              // Groups are separated by a full step; the first sits right
              // under the filters.
              padding: EdgeInsets.only(
                top: entry.key == groups.keys.first ? 0 : AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.adaptiveAccentText(
                          SkillCategoryStyle.getColor(entry.key, scheme)),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: SkillCategoryStyle.getColor(entry.key, scheme)
                              .withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      skillCategoryLabel(l10n, entry.key),
                      style: TextStyle(
                        fontSize: AppTypography.body,
                        fontWeight: FontWeight.w700,
                        color: context.adaptiveAccentText(
                            SkillCategoryStyle.getColor(entry.key, scheme)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          LayoutBuilder(builder: (context, c) {
            final cols = isDesktop && c.maxWidth >= 760 ? 2 : 1;
            const gap = AppSpacing.md;
            final w = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: AppSpacing.sm,
              children: [
                for (final s in entry.value)
                  SizedBox(
                    width: w,
                    child: _SkillRow(
                      skill: s,
                      color: context.adaptiveAccentText(
                          SkillCategoryStyle.getColor(s.category, scheme)),
                    ),
                  ),
              ],
            );
          }),
        ],
      ],
    );
  }
}

class _SkillRow extends StatefulWidget {
  const _SkillRow({required this.skill, required this.color});

  final Skill skill;
  final Color color;

  @override
  State<_SkillRow> createState() => _SkillRowState();
}

class _SkillRowState extends State<_SkillRow> {
  bool _open = false;
  bool _hovered = false;

  int _steps(double level) => level >= 0.9
      ? 4
      : level >= 0.75
          ? 3
          : level >= 0.55
              ? 2
              : 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final s = widget.skill;
    final isDark = context.isDarkMode;
    final rule = context.glassBorder;
    final steps = _steps(s.level);
    final label = masteryLabel(s.level, l10n);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: AppMotion.snap,
        decoration: BoxDecoration(
          color: _open
              ? widget.color.withValues(alpha: isDark ? 0.08 : 0.05)
              : (_hovered
                  ? (isDark
                      ? Colors.white.withValues(alpha: 0.035)
                      : AppColors.ink50)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.015)
                      : AppColors.ink50.withValues(alpha: 0.5))),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _open
                ? widget.color.withValues(alpha: 0.45)
                : (_hovered
                    ? widget.color.withValues(alpha: 0.25)
                    : rule.withValues(alpha: isDark ? 0.5 : 0.7)),
            width: _open ? 1.0 : 0.8,
          ),
          boxShadow: _open
              ? [
                  BoxShadow(
                    color: widget.color.withValues(alpha: isDark ? 0.12 : 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : (_hovered
                  ? [
                      BoxShadow(
                        color: widget.color
                            .withValues(alpha: isDark ? 0.08 : 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null),
        ),
        child: Semantics(
          button: true,
          expanded: _open,
          label: '${s.name}. $label. ${s.provenIn}',
          excludeSemantics: true,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.md),
            onTap: () {
              SoundService.instance.playSelection();
              setState(() => _open = !_open);
            },
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: widget.color
                              .withValues(alpha: isDark ? 0.14 : 0.08),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(
                            color: widget.color
                                .withValues(alpha: _open ? 0.4 : 0.2),
                            width: 0.8,
                          ),
                        ),
                        child: Center(
                          child: Icon(s.icon, size: 18, color: widget.color),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: TextStyle(
                                fontSize: AppTypography.lead,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                                color: context.onSurface,
                              ),
                            ),
                            Text(
                              s.provenIn,
                              style: TextStyle(
                                fontSize: AppTypography.label,
                                height: 1.4,
                                color: context.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontFamily: AppTypography.monoFont,
                              fontSize: AppTypography.label - 1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: widget.color,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var i = 0; i < 4; i++)
                                Container(
                                  width: 12,
                                  height: 4,
                                  margin: const EdgeInsetsDirectional.only(
                                      start: 3),
                                  decoration: BoxDecoration(
                                    color: i < steps
                                        ? widget.color
                                        : (isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.12)
                                            : AppColors.ink200),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: i < steps
                                        ? [
                                            BoxShadow(
                                              color: widget.color.withValues(
                                                  alpha: isDark ? 0.4 : 0.25),
                                              blurRadius: 3,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _open ? 0.5 : 0,
                        duration: AppMotion.snap,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: _open ? widget.color : context.mutedText,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: AppMotion.snap,
                    alignment: Alignment.topLeft,
                    child: _open
                        ? Padding(
                            padding: const EdgeInsetsDirectional.only(
                                start: 4, top: 12, end: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(
                                  height: 1,
                                  thickness: 0.6,
                                  color: widget.color.withValues(alpha: 0.2),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.terminal_rounded,
                                      size: 13,
                                      color:
                                          widget.color.withValues(alpha: 0.8),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'SPEC & IMPLEMENTATION',
                                      style: TextStyle(
                                        fontFamily: AppTypography.monoFont,
                                        fontSize: AppTypography.label - 2,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: widget.color,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  s.description,
                                  style: TextStyle(
                                    fontSize: AppTypography.body,
                                    height: 1.55,
                                    color: context.onSurface
                                        .withValues(alpha: 0.88),
                                  ),
                                ),
                                if (s.tags.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      for (final t in s.tags)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: widget.color.withValues(
                                                alpha: isDark ? 0.08 : 0.05),
                                            borderRadius: BorderRadius.circular(
                                                AppRadius.chip),
                                            border: Border.all(
                                              color: widget.color.withValues(
                                                  alpha: isDark ? 0.3 : 0.2),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '#',
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTypography.monoFont,
                                                  fontSize:
                                                      AppTypography.label - 1,
                                                  fontWeight: FontWeight.w700,
                                                  color: widget.color,
                                                ),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                t,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTypography.monoFont,
                                                  fontSize: AppTypography.label,
                                                  color: context.onSurface,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          )
                        : const SizedBox(width: double.infinity),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
