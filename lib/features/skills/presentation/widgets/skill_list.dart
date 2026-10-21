import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/presentation/utils/skill_category_labels.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/bidi.dart';

/// Skills as a spec sheet grouped by area. Each entry states the skill,
/// where it was used, what it covered and the tools involved, all on the
/// page: the evidence is the claim, so there is no self-rated level and
/// nothing to expand.
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
              // under the search.
              padding: EdgeInsets.only(
                top: entry.key == groups.keys.first ? 0 : AppSpacing.xl,
                bottom: AppSpacing.xs,
              ),
              child: Semantics(
                header: true,
                child: Text(
                  skillCategoryLabel(l10n, entry.key),
                  style: TextStyle(
                    fontSize: AppTypography.title,
                    fontWeight: FontWeight.w600,
                    color: context.onSurface,
                  ),
                ),
              ),
            ),
          LayoutBuilder(builder: (context, c) {
            final skillsInGroup = entry.value;
            // Two columns where a line still holds ~60 characters.
            if (!(isDesktop && c.maxWidth >= 760)) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final s in skillsInGroup) _SkillEntry(skill: s),
                ],
              );
            }
            // Pairs, so each row's top rules line up across the columns.
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < skillsInGroup.length; i += 2)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _SkillEntry(skill: skillsInGroup[i])),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        child: i + 1 < skillsInGroup.length
                            ? _SkillEntry(skill: skillsInGroup[i + 1])
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
              ],
            );
          }),
        ],
      ],
    );
  }
}

class _SkillEntry extends StatelessWidget {
  const _SkillEntry({required this.skill});

  final Skill skill;

  @override
  Widget build(BuildContext context) {
    final s = skill;

    return Container(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.name,
            style: TextStyle(
              fontSize: AppTypography.lead,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            ltrContent(context, s.provenIn),
            style: TextStyle(
              fontSize: AppTypography.label + 1,
              height: 1.4,
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            ltrContent(context, s.description),
            style: TextStyle(
              fontSize: AppTypography.body,
              height: 1.55,
              color: context.onSurface.withValues(alpha: 0.88),
            ),
          ),
          if (s.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in s.tags)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(color: context.divider),
                    ),
                    child: Text(
                      t,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: AppTypography.label,
                        fontWeight: FontWeight.w500,
                        color: context.mutedText,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
