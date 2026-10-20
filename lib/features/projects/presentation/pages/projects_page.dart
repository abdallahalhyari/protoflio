import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
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
import 'package:profile/shared/widgets/swipe_affordance.dart';

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
  final ScrollController _workScrollController = ScrollController();

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
    _workScrollController.dispose();
    super.dispose();
  }

  void _handleWorkScrollSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_workScrollController.hasClients) {
      return;
    }

    final delta = event.scrollDelta.dx.abs() > event.scrollDelta.dy.abs()
        ? event.scrollDelta.dx
        : event.scrollDelta.dy;
    if (delta == 0) return;

    final position = _workScrollController.position;
    _workScrollController.jumpTo(
      (position.pixels + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final isDark = context.isDarkMode;
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
            SliverToBoxAdapter(
              child: SizedBox(
                  height:
                      isDesktop ? AppSpacing.sm : AppSpacing.sectionControls),
            ),
            SliverToBoxAdapter(
              child: _buildHallmarksStrip(loc, scheme, isDark),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                  height:
                      isDesktop ? AppSpacing.md : AppSpacing.sectionControls),
            ),
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
                          ? 540 + 170 * (textScale - 1).clamp(0.0, 1.2)
                          : 500 + 160 * (textScale - 1).clamp(0.0, 1.0);

                      const double spacing = AppSpacing.lg;
                      final double itemWidth = isDesktop
                          ? columnWidth(constraints.maxWidth, 3, spacing)
                              .clamp(320.0, 400.0)
                          : constraints.maxWidth * 0.75;
                      final double mobileCardWidth =
                          filteredProjects.length == 1
                              ? (constraints.maxWidth - AppSpacing.md * 2)
                                  .clamp(290.0, 480.0)
                              : itemWidth;

                      final projectsList = SizedBox(
                        height: itemHeight,
                        child: isDesktop
                            ? Scrollbar(
                                controller: _workScrollController,
                                thumbVisibility: true,
                                interactive: true,
                                child: Listener(
                                  onPointerSignal: _handleWorkScrollSignal,
                                  child: ListView.separated(
                                    key: const Key('projects_horizontal_list'),
                                    controller: _workScrollController,
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.md,
                                    ),
                                    itemCount: filteredProjects.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: spacing),
                                    itemBuilder: (context, i) => SizedBox(
                                      width: itemWidth,
                                      child: _buildProjectItem(
                                        project: filteredProjects[i],
                                        index: i,
                                        scheme: scheme,
                                        isDesktop: isDesktop,
                                        selectedTech: selectedTech,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                key: const Key('projects_horizontal_list'),
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.md,
                                ),
                                clipBehavior: Clip.none,
                                itemCount: filteredProjects.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: spacing),
                                itemBuilder: (context, i) => SizedBox(
                                  width: mobileCardWidth,
                                  child: _buildProjectItem(
                                    project: filteredProjects[i],
                                    index: i,
                                    scheme: scheme,
                                    isDesktop: isDesktop,
                                    selectedTech: selectedTech,
                                  ),
                                ),
                              ),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!isDesktop && filteredProjects.length > 1) ...[
                            SwipeAffordance(
                              label: loc.projectSwipeHint,
                              margin: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                            ),
                          ],
                          projectsList,
                        ],
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

  Widget _buildHallmarksStrip(
      AppLocalizations loc, ColorScheme scheme, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _HallmarkPill(
          icon: Icons.contactless_rounded,
          title: loc.projectHallmarkNfc,
          subtitle: loc.projectHallmarkNfcDetail,
          accentColor: isDark ? AppColors.tealLight : AppColors.tealDeep,
          isDark: isDark,
        ),
        _HallmarkPill(
          icon: Icons.cloud_sync_rounded,
          title: loc.projectHallmarkOffline,
          subtitle: loc.projectHallmarkOfflineDetail,
          accentColor: isDark ? AppColors.tealLight : AppColors.tealDeep,
          isDark: isDark,
        ),
        _HallmarkPill(
          icon: Icons.speed_rounded,
          title: loc.projectHallmarkPerformance,
          subtitle: loc.projectHallmarkPerformanceDetail,
          accentColor: isDark ? AppColors.goldSoft : AppColors.goldDeep,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildHeader(
      ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    return SectionMasthead(
      kicker: loc.projectsHeaderKicker,
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
    return TweenAnimationBuilder<double>(
      key: ValueKey('project_${project.name}_$index'),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: AppMotion.pageTurn,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
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

class _HallmarkPill extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool isDark;

  const _HallmarkPill({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.isDark,
  });

  @override
  State<_HallmarkPill> createState() => _HallmarkPillState();
}

class _HallmarkPillState extends State<_HallmarkPill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final fgAccent = widget.accentColor;
    final isHovered = _isHovered;

    final borderColor = isHovered
        ? widget.accentColor.withValues(alpha: isDark ? 0.6 : 0.45)
        : (isDark ? Colors.white.withValues(alpha: 0.10) : AppColors.ink200);

    final bgColor = isHovered
        ? widget.accentColor.withValues(alpha: isDark ? 0.12 : 0.08)
        : (isDark
            ? Colors.white.withValues(alpha: 0.04)
            : AppColors.ink100.withValues(alpha: 0.6));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: AppMotion.snap,
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: borderColor,
            width: isHovered ? 1.1 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppMotion.snap,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isHovered
                    ? widget.accentColor.withValues(alpha: isDark ? 0.28 : 0.20)
                    : widget.accentColor
                        .withValues(alpha: isDark ? 0.16 : 0.12),
                borderRadius: BorderRadius.circular(AppRadius.hairline),
              ),
              child: Icon(widget.icon, size: 13, color: fgAccent),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.onSurface,
                      fontSize: AppTypography.label,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      color: context.mutedText,
                      fontSize: AppTypography.label - 2,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
