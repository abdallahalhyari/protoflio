import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/theme/tokens.dart';
import 'package:profile/features/skills/bloc/skills_filter_bloc.dart';
import 'package:profile/features/skills/bloc/skills_filter_event.dart';
import 'package:profile/features/skills/bloc/skills_filter_state.dart';
import 'package:profile/features/skills/data/skills_data.dart';
import 'package:profile/shared/widget/screen_shell.dart';
import 'package:profile/features/skills/widget/bento_skill_tile.dart';
import 'package:profile/features/skills/widget/skill_category_filters.dart';
import 'package:profile/features/skills/widget/skills_empty_state.dart';
import 'package:profile/features/skills/widget/skills_header.dart';
import 'package:profile/features/skills/widget/skill_search_bar.dart';

class SkillsPage extends StatelessWidget {
  final bool isContinuousMobile;

  const SkillsPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    SkillsFilterBloc? bloc;
    try {
      bloc = context.read<SkillsFilterBloc>();
    } catch (_) {
      bloc = null;
    }

    if (bloc != null) {
      return _SkillsPageView(isContinuousMobile: isContinuousMobile);
    }

    return BlocProvider<SkillsFilterBloc>(
      create: (_) => SkillsFilterBloc(),
      child: _SkillsPageView(isContinuousMobile: isContinuousMobile),
    );
  }
}

class _SkillsPageView extends StatefulWidget {
  final bool isContinuousMobile;

  const _SkillsPageView({required this.isContinuousMobile});

  @override
  State<_SkillsPageView> createState() => _SkillsPageViewState();
}

class _SkillsPageViewState extends State<_SkillsPageView>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _searchController;

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
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin requirement
    final scheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width >= AppBreakpoints.tablet;

    return BlocBuilder<SkillsFilterBloc, SkillsFilterState>(
      builder: (context, state) {
        final displayedSkills = state.filteredSkills;
        final selectedCategory = state.selectedCategory;

        final grid = displayedSkills.isEmpty
            ? SkillsEmptyState(
                onShowAll: () {
                  _searchController.clear();
                  context
                      .read<SkillsFilterBloc>()
                      .add(const SkillsFilterReset());
                },
              )
            : GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsetsDirectional.only(end: 20),
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
                      categoryGradient: SkillCategoryStyle.getGradient(
                          skill.category, scheme),
                      isDesktop: isDesktop,
                    ),
                  );
                },
              );

        return AppScreenShell(
          maxWidth: 1400,
          verticalPadding: AppSpacing.md,
          reserveBottomNav: !widget.isContinuousMobile,
          reserveMobileTop: !widget.isContinuousMobile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkillsHeader(isDesktop: isDesktop),
              const SizedBox(height: AppSpacing.smd),
              SkillSearchBar(
                controller: _searchController,
                onChanged: (val) {
                  context
                      .read<SkillsFilterBloc>()
                      .add(SkillSearchQueryChanged(val));
                },
                onClear: () {
                  _searchController.clear();
                  context
                      .read<SkillsFilterBloc>()
                      .add(const SkillSearchQueryChanged(''));
                },
                totalCount: kSkills.length,
                filteredCount: displayedSkills.length,
                isDesktop: isDesktop,
              ),
              const SizedBox(height: AppSpacing.smd),
              SkillCategoryFilters(
                categories: _categories,
                selectedCategory: selectedCategory,
                onSelectCategory: (cat) {
                  context
                      .read<SkillsFilterBloc>()
                      .add(SkillCategorySelected(cat));
                },
                isDesktop: isDesktop,
              ),
              const SizedBox(height: AppSpacing.smd),
              Container(
                  height: 1, color: scheme.onSurface.withValues(alpha: AppAlpha.hover)),
              const SizedBox(height: AppSpacing.md),
              if (widget.isContinuousMobile)
                LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = AppSpacing.smd;
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
                                categoryColor: SkillCategoryStyle.getColor(
                                    skill.category, scheme),
                                categoryGradient:
                                    SkillCategoryStyle.getGradient(
                                        skill.category, scheme),
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
      },
    );
  }
}
