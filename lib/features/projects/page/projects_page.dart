import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/projects/bloc/projects_filter_bloc.dart';
import 'package:profile/features/projects/bloc/projects_filter_event.dart';
import 'package:profile/features/projects/bloc/projects_filter_state.dart';
import 'package:profile/features/projects/data/projects_data.dart';
import 'package:profile/shared/widget/page_activity.dart';
import 'package:profile/features/projects/widget/interactive_project_card.dart';
import 'package:profile/features/projects/model/project.dart';
import 'package:profile/features/projects/widget/project_domain_filters.dart';
import 'package:profile/shared/widget/screen_shell.dart';

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
      create: (_) => ProjectsFilterBloc(),
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
    final isDesktop = size.width >= AppBreakpoints.tablet;
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<ProjectsFilterBloc, ProjectsFilterState>(
      builder: (context, filterState) {
        final filteredProjects = filterState.filteredProjects;
        final selectedDomain = filterState.selectedDomain;
        final selectedTech = filterState.selectedTech;

        return Focus(
          focusNode: _keyboardFocusNode,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                final curIdx = _domains.indexOf(selectedDomain);
                final nextIdx =
                    (curIdx - 1 + _domains.length) % _domains.length;
                SoundService.instance.playSelection();
                context
                    .read<ProjectsFilterBloc>()
                    .add(DomainFilterSelected(_domains[nextIdx]));
                return KeyEventResult.handled;
              } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                final curIdx = _domains.indexOf(selectedDomain);
                final nextIdx = (curIdx + 1) % _domains.length;
                SoundService.instance.playSelection();
                context
                    .read<ProjectsFilterBloc>()
                    .add(DomainFilterSelected(_domains[nextIdx]));
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: AppScreenShell(
            maxWidth: 1200,
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
                    child: SizedBox(height: AppSpacing.md)),
                SliverToBoxAdapter(
                  child: ProjectDomainFilters(
                    domains: _domains,
                    selectedDomain: selectedDomain,
                    selectedTech: selectedTech,
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
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.lg)),
                SliverToBoxAdapter(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (filteredProjects.isEmpty) {
                        return _buildEmptyState(context, scheme, isDesktop);
                      }

                      if (isDesktop) {
                        const double spacing = AppSpacing.lg;
                        final double itemWidth =
                            (constraints.maxWidth - spacing) / 2;
                        // Fixed-height grid cells: grow the text area with
                        // the user's text scale (up to 2x) instead of
                        // clipping the card body.
                        final double textScale =
                            MediaQuery.textScalerOf(context).scale(1);
                        final double itemHeight =
                            380 + 110 * (textScale - 1).clamp(0.0, 1.0);

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            for (int i = 0; i < filteredProjects.length; i++)
                              SizedBox(
                                width: itemWidth,
                                height: itemHeight,
                                child: _buildProjectItem(
                                  project: filteredProjects[i],
                                  scheme: scheme,
                                  isDesktop: isDesktop,
                                  selectedTech: selectedTech,
                                ),
                              ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < filteredProjects.length; i++) ...[
                            _buildProjectItem(
                              project: filteredProjects[i],
                              scheme: scheme,
                              isDesktop: isDesktop,
                              selectedTech: selectedTech,
                            ),
                            if (i < filteredProjects.length - 1)
                              const SizedBox(height: AppSpacing.md),
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
      BuildContext context, ColorScheme scheme, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded,
              size: 48, color: scheme.primary.withValues(alpha: 0.6)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'NO CASE STUDIES MATCHED',
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              fontSize: isDesktop ? 20 : 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try selecting another industry domain or clearing the active technology filter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.7),
              fontSize: AppTypography.small,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {
              SoundService.instance.playClick();
              context
                  .read<ProjectsFilterBloc>()
                  .add(const ProjectsFilterReset());
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('RESET FILTERS'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      ColorScheme scheme, AppLocalizations loc, Size size, bool isDesktop) {
    final isDark = scheme.brightness == Brightness.dark;
    final accentText = context.adaptiveAccentText(scheme.primary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border:
                    Border.all(color: scheme.primary.withValues(alpha: 0.3)),
              ),
              child: Text(
                'CASE STUDIES',
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  color: accentText,
                  fontWeight: FontWeight.w900,
                  fontSize: AppTypography.micro,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(height: 1, color: context.glassBorderStrong),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'SELECTED WORK',
          style: TextStyle(
            fontFamily: AppTypography.monoFont,
            color: accentText,
            fontWeight: FontWeight.w900,
            fontSize: AppTypography.micro,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          header: true,
          child: Text(
            loc.navProjects,
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              color: context.onSurface,
              fontSize: isDesktop ? 48 : 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppLocalizations.of(context)!.sectionSubtitleWork,
          style: TextStyle(
            color: isDark
                ? Colors.white.withValues(alpha: 0.7)
                : AppColors.slate600,
            fontSize: isDesktop ? 16 : 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProjectItem({
    required Project project,
    required ColorScheme scheme,
    required bool isDesktop,
    required String? selectedTech,
  }) {
    return InteractiveProjectCard(
      project: project,
      index: kProjects.indexOf(project),
      scheme: scheme,
      isDesktop: isDesktop,
      selectedTech: selectedTech,
      onSelectTech: (tech) {
        context.read<ProjectsFilterBloc>().add(TechFilterToggled(tech));
      },
    );
  }
}
