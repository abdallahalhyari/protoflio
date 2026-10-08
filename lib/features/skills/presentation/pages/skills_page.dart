import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_bloc.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_event.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_state.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/features/skills/presentation/widgets/skill_list.dart';
import 'package:profile/features/skills/presentation/widgets/skill_category_filters.dart';
import 'package:profile/features/skills/presentation/widgets/skills_empty_state.dart';
import 'package:profile/features/skills/presentation/widgets/skills_header.dart';
import 'package:profile/features/skills/presentation/widgets/skill_search_bar.dart';

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
      create: (ctx) =>
          SkillsFilterBloc(repository: ctx.read<SkillRepository>()),
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
    final isDesktop = AppBreakpoints.isDesktop(context);

    return BlocBuilder<SkillsFilterBloc, SkillsFilterState>(
      builder: (context, state) {
        final displayedSkills = state.filteredSkills;
        final selectedCategory = state.selectedCategory;

        final Widget content = displayedSkills.isEmpty
            ? SkillsEmptyState(
                key: const ValueKey('skills_empty'),
                query: state.searchQuery,
                onShowAll: () {
                  _searchController.clear();
                  context
                      .read<SkillsFilterBloc>()
                      .add(const SkillsFilterReset());
                },
              )
            : SkillList(
                key: ValueKey(
                    'skills_list_${selectedCategory}_${state.searchQuery}'),
                skills: displayedSkills,
                isDesktop: isDesktop,
              );

        return AppScreenShell(
          maxWidth: kSectionMaxWidth,
          verticalPadding: AppSpacing.md,
          reserveBottomNav: !widget.isContinuousMobile,
          reserveMobileTop: !widget.isContinuousMobile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkillsHeader(isDesktop: isDesktop),
              const SizedBox(height: AppSpacing.sectionControls),
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
                totalCount: context.read<SkillRepository>().getSkillCount(),
                filteredCount: displayedSkills.length,
                isDesktop: isDesktop,
              ),
              const SizedBox(height: AppSpacing.sm),
              SkillCategoryFilters(
                categories: _categories,
                selectedCategory: selectedCategory,
                onSelectCategory: (cat) {
                  context
                      .read<SkillsFilterBloc>()
                      .add(SkillCategorySelected(cat));
                },
                isDesktop: isDesktop,
                counts: state.categoryCounts,
              ),
              const SizedBox(height: AppSpacing.sectionContent),
              if (widget.isContinuousMobile)
                content
              else
                Expanded(
                  child: SingleChildScrollView(
                    primary: false,
                    child: content,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
