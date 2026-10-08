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
          LayoutBuilder(builder: (context, c) {
            final cols = isDesktop && c.maxWidth >= 760 ? 2 : 1;
            const gap = AppSpacing.md;
            final w = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
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
    final rule = context.glassBorder;
    final steps = _steps(s.level);
    final label = masteryLabel(s.level, l10n);

    return DecoratedBox(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: rule))),
      child: Semantics(
        button: true,
        expanded: _open,
        label: '${s.name}. $label. ${s.provenIn}',
        excludeSemantics: true,
        child: InkWell(
          onTap: () {
            SoundService.instance.playSelection();
            setState(() => _open = !_open);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(s.icon, size: 20, color: widget.color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: TextStyle(
                              fontSize: AppTypography.lead,
                              fontWeight: FontWeight.w600,
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
                            fontSize: AppTypography.label,
                            fontWeight: FontWeight.w700,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < 4; i++)
                              Container(
                                width: 14,
                                height: 4,
                                margin:
                                    const EdgeInsetsDirectional.only(start: 3),
                                decoration: BoxDecoration(
                                  color: i < steps
                                      ? widget.color
                                      : context.glassBorderStrong,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: AppMotion.snap,
                      child: Icon(Icons.expand_more_rounded,
                          size: 20, color: context.mutedText),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: AppMotion.snap,
                  alignment: Alignment.topLeft,
                  child: _open
                      ? Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 32, top: 8, end: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.description,
                                style: TextStyle(
                                  fontSize: AppTypography.body,
                                  height: 1.55,
                                  color:
                                      context.onSurface.withValues(alpha: 0.88),
                                ),
                              ),
                              if (s.tags.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    for (final t in s.tags)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppRadius.chip),
                                          border: Border.all(
                                              color: context.glassBorderStrong),
                                        ),
                                        child: Text(
                                          t,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            fontFamily: AppTypography.monoFont,
                                            fontSize: AppTypography.label,
                                            color: context.onSurface,
                                          ),
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
    );
  }
}
