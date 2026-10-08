import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_bloc.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_event.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_state.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/features/skills/presentation/widgets/skill_list.dart';
import 'package:profile/features/skills/presentation/widgets/skill_stack_index.dart';
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

  final Map<String, GlobalKey> _groupKeys = {
    for (final c in kSkillStackOrder) c: GlobalKey(debugLabel: 'skills_$c'),
  };
  final GlobalKey _listViewport = GlobalKey(debugLabel: 'skills_list');
  String? _active;

  final ScrollController _listController = ScrollController();

  void _jumpTo(String group) {
    final ctx = _groupKeys[group]?.currentContext;
    setState(() => _active = group);
    if (ctx == null) return;
    // Paged layouts scroll only the list: ensureVisible would also move the
    // page pager and start a page turn. The continuous phone layout has no
    // list of its own, so there the outer scroll is the right one.
    if (!_listController.hasClients) {
      Scrollable.ensureVisible(
        ctx,
        // A little below the top, clear of the phone app bar.
        alignment: 0.1,
        duration: AppMotion.md,
        curve: AppMotion.emphasized,
      );
      return;
    }
    final viewport = _listViewport.currentContext?.findRenderObject();
    final box = ctx.findRenderObject();
    if (viewport is! RenderBox || box is! RenderBox) return;
    final delta = box.localToGlobal(Offset.zero).dy -
        viewport.localToGlobal(Offset.zero).dy;
    final target = (_listController.offset + delta).clamp(
      0.0,
      _listController.position.maxScrollExtent,
    );
    _listController.animateTo(
      target,
      duration: AppMotion.md,
      curve: AppMotion.emphasized,
    );
  }

  /// The lit group follows the list: the last heading that has reached the
  /// top of the list viewport.
  void _trackActive(List<String> present) {
    final viewport = _listViewport.currentContext?.findRenderObject();
    if (viewport is! RenderBox || !viewport.hasSize) return;
    final top = viewport.localToGlobal(Offset.zero).dy;
    String? current = present.isEmpty ? null : present.first;
    for (final g in present) {
      final box = _groupKeys[g]?.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.hasSize) continue;
      if (box.localToGlobal(Offset.zero).dy - top <= 32) current = g;
    }
    if (current != _active) setState(() => _active = current);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listController.dispose();
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
                order: kSkillStackOrder,
                groupKeys: _groupKeys,
              );

        final counts = <String, int>{};
        for (final s in displayedSkills) {
          counts[s.category] = (counts[s.category] ?? 0) + 1;
        }
        final present = [
          for (final c in kSkillStackOrder)
            if (counts.containsKey(c)) c,
        ];
        final active = present.contains(_active)
            ? _active
            : (present.isEmpty ? null : present.first);
        // The rail needs room beside the list; below that it becomes a row.
        final railBeside = isDesktop && !widget.isContinuousMobile;
        final index = SkillStackIndex(
          groups: present,
          counts: counts,
          active: active,
          onSelect: _jumpTo,
          horizontal: !railBeside,
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
              // Its own semantics node: merged into the page's container, the
              // field's tap made the whole page announce as one control.
              Semantics(
                container: true,
                child: SkillSearchBar(
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
              ),
              const SizedBox(height: AppSpacing.sectionContent),
              if (widget.isContinuousMobile) ...[
                index,
                const SizedBox(height: AppSpacing.md),
                content,
              ] else if (!railBeside) ...[
                index,
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: SingleChildScrollView(
                    key: _listViewport,
                    controller: _listController,
                    child: content,
                  ),
                ),
              ] else
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 220,
                        child: SingleChildScrollView(
                          primary: false,
                          child: index,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (_) {
                            _trackActive(present);
                            return false;
                          },
                          child: SingleChildScrollView(
                            key: _listViewport,
                            controller: _listController,
                            child: content,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
