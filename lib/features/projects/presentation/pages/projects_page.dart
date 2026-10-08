import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_bloc.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_event.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_state.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/shared/widgets/page_activity.dart';
import 'package:profile/features/projects/presentation/widgets/interactive_project_card.dart';
import 'package:profile/features/projects/presentation/widgets/project_domain_filters.dart';
import 'package:profile/shared/utils/grid_math.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/section_masthead.dart';
import 'package:profile/features/projects/presentation/widgets/projects_empty_state.dart';

class ProjectsPage extends StatelessWidget {
  final bool isContinuousMobile;

  const ProjectsPage({
    super.key,
    this.isContinuousMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    // If an external ProjectsFilterBloc is already provided (e.g. in tests), reuse it.
    ProjectsFilterBloc? bloc;
    try {
      bloc = context.read<ProjectsFilterBloc>();
    } catch (_) {
      bloc = null;
    }

    if (bloc != null) {
      return _ProjectsPageView(isContinuousMobile: isContinuousMobile);
    }

    return BlocProvider<ProjectsFilterBloc>(
      create: (ctx) => ProjectsFilterBloc(
        repository: ctx.read<ProjectRepository>(),
      ),
      child: _ProjectsPageView(isContinuousMobile: isContinuousMobile),
    );
  }
}

class _ProjectsPageView extends StatefulWidget {
  final bool isContinuousMobile;

  const _ProjectsPageView({required this.isContinuousMobile});

  @override
  State<_ProjectsPageView> createState() => _ProjectsPageViewState();
}

class _ProjectsPageViewState extends State<_ProjectsPageView>
    with AutomaticKeepAliveClientMixin, ActivePageFocusMixin {
  final FocusNode _keyboardFocusNode = FocusNode(debugLabel: 'ProjectsPage');

  static const List<String> _domains = [
    'ALL',
    'Healthcare & Smart Cards',
    'Enterprise HIS & LMS',
    'Fleet & Telematics',
    'M-Commerce & Streaming',
  ];

  @override
  bool get wantKeepAlive => true;

  // `autofocus` only wins when nothing in the enclosing scope already has
  // focus — DesktopKeyboardNav's app-wide Focus claims it first, so this
  // page's arrow-key filter shortcut would otherwise never fire. The mixin
  // requests focus explicitly whenever this page becomes the visible one.
  @override
  FocusNode get pageFocusNode => _keyboardFocusNode;

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final loc = AppLocalizations.of(context)!;

    return Focus(
      focusNode: _keyboardFocusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          final filterBloc = context.read<ProjectsFilterBloc>();
          final selectedDomain = filterBloc.state.selectedDomain;
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            final curIdx = _domains.indexOf(selectedDomain);
            final nextIdx = (curIdx - 1 + _domains.length) % _domains.length;
            SoundService.instance.playSelection();
            filterBloc.add(DomainFilterSelected(_domains[nextIdx]));
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            final curIdx = _domains.indexOf(selectedDomain);
            final nextIdx = (curIdx + 1) % _domains.length;
            SoundService.instance.playSelection();
            filterBloc.add(DomainFilterSelected(_domains[nextIdx]));
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: AppScreenShell(
        maxWidth: kSectionMaxWidth,
        verticalPadding: AppSpacing.xl,
        reserveBottomNav: !widget.isContinuousMobile,
        reserveMobileTop: !widget.isContinuousMobile,
        child: CustomScrollView(
          shrinkWrap: widget.isContinuousMobile,
          physics: widget.isContinuousMobile
              ? const NeverScrollableScrollPhysics()
              : null,
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(scheme, loc, size, isDesktop),
            ),
            const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.sectionControls)),
            SliverToBoxAdapter(
              child: BlocBuilder<ProjectsFilterBloc, ProjectsFilterState>(
                buildWhen: (prev, curr) =>
                    prev.selectedDomain != curr.selectedDomain ||
                    prev.selectedTech != curr.selectedTech ||
                    prev.domainCounts != curr.domainCounts,
                builder: (context, filterState) {
                  return ProjectDomainFilters(
                    domains: _domains,
                    selectedDomain: filterState.selectedDomain,
                    selectedTech: filterState.selectedTech,
                    domainCounts: filterState.domainCounts,
                    isDesktop: isDesktop,
                    onSelectDomain: (domain) {
                      context
                          .read<ProjectsFilterBloc>()
                          .add(DomainFilterSelected(domain));
                    },
                    onClearTech: () {
                      context
                          .read<ProjectsFilterBloc>()
                          .add(const ProjectsFilterReset());
                    },
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.sectionContent)),
            SliverToBoxAdapter(
              child: BlocBuilder<ProjectsFilterBloc, ProjectsFilterState>(
                buildWhen: (prev, curr) =>
                    prev.filteredProjects != curr.filteredProjects ||
                    prev.selectedTech != curr.selectedTech,
                builder: (context, filterState) {
                  final filteredProjects = filterState.filteredProjects;
                  final selectedTech = filterState.selectedTech;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (filteredProjects.isEmpty) {
                        return ProjectsEmptyState(
                          scheme: scheme,
                          isDesktop: isDesktop,
                        );
                      }

                      final double textScale =
                          MediaQuery.textScalerOf(context).scale(1);
                      final double itemHeight = isDesktop
                          ? 540 + 160 * (textScale - 1).clamp(0.0, 1.0)
                          : 500 + 160 * (textScale - 1).clamp(0.0, 1.0);

                      const double spacing = AppSpacing.lg;
                      final double itemWidth = isDesktop
                          ? columnWidth(constraints.maxWidth, 3, spacing)
                              .clamp(320.0, 400.0)
                          : constraints.maxWidth * 0.75;

                      if (isDesktop) {
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          alignment: WrapAlignment.center,
                          children: [
                            for (int i = 0; i < filteredProjects.length; i++)
                              SizedBox(
                                width: itemWidth,
                                height: itemHeight,
                                child: _buildProjectItem(
                                  project: filteredProjects[i],
                                  index: i,
                                  scheme: scheme,
                                  isDesktop: isDesktop,
                                  selectedTech: selectedTech,
                                ),
                              )
                          ],
                        );
                      }

                      return SizedBox(
                        height: itemHeight,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md),
                          clipBehavior: Clip.none,
                          itemCount: filteredProjects.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: spacing),
                          itemBuilder: (context, i) {
                            return SizedBox(
                              width: itemWidth,
                              child: _buildProjectItem(
                                project: filteredProjects[i],
                                index: i,
                                scheme: scheme,
                                isDesktop: isDesktop,
                                selectedTech: selectedTech,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    return SectionMasthead(
      title: loc.navWork,
      subtitle: loc.sectionSubtitleWork,
      isDesktop: isDesktop,
    );
  }

  Widget _buildProjectItem({
    required Project project,
    required int index,
    required ColorScheme scheme,
    required bool isDesktop,
    required String? selectedTech,
  }) {
    // Basic stagger logic: delay slightly based on index, maxing out at a certain point.
    // The tween animation builder handles the entrance without needing external delays right now.

    return TweenAnimationBuilder<double>(
      key: ValueKey('project_${project.name}_$index'),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: AppMotion.pageTurn,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // We delay the start of the animation by checking if the animation should have started.
        // For a more precise stagger, we can just use the value directly with a modified curve or
        // standard flutter animation tools. We'll simulate it beautifully by mapping value.
        // Alternatively, since TweenAnimationBuilder starts immediately, we can map the value.
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: InteractiveProjectCard(
        project: project,
        index: index,
        scheme: scheme,
        isDesktop: isDesktop,
        selectedTech: selectedTech,
        onSelectTech: (tech) {
          context.read<ProjectsFilterBloc>().add(TechFilterToggled(tech));
        },
      ),
    );
  }
}
