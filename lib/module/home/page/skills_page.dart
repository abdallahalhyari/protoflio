import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';
import '../data/skills_data.dart';
import '../widget/screen_shell.dart';
import '../widget/skills/bento_skill_tile.dart';
import '../widget/skills/skill_category_filters.dart';
import '../widget/skills/skills_empty_state.dart';
import '../widget/skills/skills_header.dart';

class SkillsPage extends StatefulWidget {
  final bool isContinuousMobile;

  const SkillsPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage>
    with AutomaticKeepAliveClientMixin {
  String _selectedCategory = 'ALL';

  @override
  bool get wantKeepAlive => true;

  static const List<String> _categories = [
    'ALL',
    'Domain Expertise',
    'Mobile Systems',
    'Security & Protocols',
    'Architecture & State',
    'Cloud & Infrastructure',
    'Languages & Comm',
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final scheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

    final displayedSkills = _selectedCategory == 'ALL'
        ? kSkills
        : kSkills.where((s) => s.category == _selectedCategory).toList();

    final grid = displayedSkills.isEmpty
        ? SkillsEmptyState(
            onShowAll: () => setState(() => _selectedCategory = 'ALL'),
          )
        : GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 2 : 1, // Number of rows
              childAspectRatio: isDesktop ? 1.1 : 1.28, // Height / Width
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: displayedSkills.length,
            itemBuilder: (context, index) {
              final skill = displayedSkills[index];
              return RepaintBoundary(
                child: BentoSkillTile(
                  skill: skill,
                  categoryColor:
                      SkillCategoryStyle.getColor(skill.category, scheme),
                  categoryGradient:
                      SkillCategoryStyle.getGradient(skill.category, scheme),
                  isDesktop: isDesktop,
                ),
              );
            },
          );

    return AppScreenShell(
      maxWidth: 1400,
      verticalPadding:
          widget.isContinuousMobile ? AppSpacing.md : AppSpacing.md,
      reserveBottomNav: !widget.isContinuousMobile,
      reserveMobileTop: !widget.isContinuousMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SkillsHeader(isDesktop: isDesktop),
          const SizedBox(height: 12),
          SkillCategoryFilters(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onSelectCategory: (cat) => setState(() => _selectedCategory = cat),
            isDesktop: isDesktop,
          ),
          const SizedBox(height: 12),
          Container(
              height: 1, color: scheme.onSurface.withValues(alpha: 0.12)),
          const SizedBox(height: 16),
          if (widget.isContinuousMobile)
            // Vertical 2-column grid feeds parent scroll — no nested
            // horizontal-in-vertical scrolling. Fixed tile height keeps
            // rows uniform without a horizontal viewport.
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 12.0;
                final tileW = (constraints.maxWidth - spacing) / 2;
                const tileH = 180.0;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final skill in displayedSkills)
                      SizedBox(
                        width: tileW,
                        height: tileH,
                        child: RepaintBoundary(
                          child: BentoSkillTile(
                            skill: skill,
                            categoryColor:
                                SkillCategoryStyle.getColor(skill.category, scheme),
                            categoryGradient:
                                SkillCategoryStyle.getGradient(skill.category, scheme),
                            isDesktop: false,
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          else
            Expanded(child: grid),
        ],
      ),
    );
  }
}
