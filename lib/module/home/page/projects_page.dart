import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../service/sound_service.dart';
import '../../../theme/tokens.dart';
import '../bloc/projects/projects_filter_bloc.dart';
import '../bloc/projects/projects_filter_event.dart';
import '../bloc/projects/projects_filter_state.dart';
import '../data/projects_data.dart';
import '../widget/directional_icon.dart';
import '../widget/projects/interactive_project_card.dart';
import '../widget/projects/project_domain_filters.dart';
import '../widget/screen_shell.dart';

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
    with AutomaticKeepAliveClientMixin {
  int _mobileSelectedIndex = 0;

  static const List<String> _domains = [
    'ALL',
    'Healthcare & Smart Cards',
    'Enterprise HIS & LMS',
    'Fleet & Telematics',
    'M-Commerce & Streaming',
  ];

  @override
  bool get wantKeepAlive => true;

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

        return AppScreenShell(
          maxWidth: 1200,
          verticalPadding: AppSpacing.xl,
          reserveBottomNav: !widget.isContinuousMobile,
          reserveMobileTop: !widget.isContinuousMobile,
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            physics: widget.isContinuousMobile
                ? const NeverScrollableScrollPhysics()
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(scheme, loc, size, isDesktop),
                const SizedBox(height: AppSpacing.md),
                ProjectDomainFilters(
                  domains: _domains,
                  selectedDomain: selectedDomain,
                  selectedTech: selectedTech,
                  domainCounts: filterState.domainCounts,
                  isDesktop: isDesktop,
                  onSelectDomain: (domain) {
                    context
                        .read<ProjectsFilterBloc>()
                        .add(DomainFilterSelected(domain));
                    setState(() {
                      _mobileSelectedIndex = 0;
                    });
                  },
                  onClearTech: () {
                    context
                        .read<ProjectsFilterBloc>()
                        .add(const ProjectsFilterReset());
                    setState(() {
                      _mobileSelectedIndex = 0;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (filteredProjects.isEmpty)
                  _buildEmptyState(context, scheme, isDesktop)
                else if (isDesktop)
                  Column(
                    children: [
                      for (int i = 0; i < filteredProjects.length; i += 2) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 380,
                                child: InteractiveProjectCard(
                                  project: filteredProjects[i],
                                  index: kProjects.indexOf(filteredProjects[i]),
                                  scheme: scheme,
                                  isDesktop: isDesktop,
                                  selectedTech: selectedTech,
                                  onSelectTech: (tech) {
                                    context
                                        .read<ProjectsFilterBloc>()
                                        .add(TechFilterToggled(tech));
                                    setState(() {
                                      _mobileSelectedIndex = 0;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            if (i + 1 < filteredProjects.length)
                              Expanded(
                                child: SizedBox(
                                  height: 380,
                                  child: InteractiveProjectCard(
                                    project: filteredProjects[i + 1],
                                    index: kProjects
                                        .indexOf(filteredProjects[i + 1]),
                                    scheme: scheme,
                                    isDesktop: isDesktop,
                                    selectedTech: selectedTech,
                                    onSelectTech: (tech) {
                                      context
                                          .read<ProjectsFilterBloc>()
                                          .add(TechFilterToggled(tech));
                                      setState(() {
                                        _mobileSelectedIndex = 0;
                                      });
                                    },
                                  ),
                                ),
                              )
                            else
                              const Spacer(),
                          ],
                        ),
                        if (i + 2 < filteredProjects.length)
                          const SizedBox(height: AppSpacing.lg),
                      ],
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < filteredProjects.length; i++) ...[
                        Container(
                          decoration: i == _mobileSelectedIndex
                              ? BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                  border: Border.all(
                                    color:
                                        scheme.primary.withValues(alpha: 0.35),
                                    width: 1,
                                  ),
                                )
                              : null,
                          child: InteractiveProjectCard(
                            project: filteredProjects[i],
                            index: kProjects.indexOf(filteredProjects[i]),
                            scheme: scheme,
                            isDesktop: isDesktop,
                            selectedTech: selectedTech,
                            onSelectTech: (tech) {
                              context
                                  .read<ProjectsFilterBloc>()
                                  .add(TechFilterToggled(tech));
                              setState(() {
                                _mobileSelectedIndex = 0;
                              });
                            },
                          ),
                        ),
                        if (i < filteredProjects.length - 1)
                          const SizedBox(height: AppSpacing.md),
                      ],
                      if (filteredProjects.length > 1) ...[
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () => setState(() {
                                _mobileSelectedIndex = (_mobileSelectedIndex -
                                        1 +
                                        filteredProjects.length) %
                                    filteredProjects.length;
                              }),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(88, 36),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md),
                              ),
                              icon: const DirIcon(Icons.chevron_left_rounded,
                                  size: 16),
                              label: Text(loc.previousAction),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm),
                                child: Text(
                                  'CASE ${(_mobileSelectedIndex + 1).clamp(1, filteredProjects.length)}/${filteredProjects.length}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontFamily: AppTypography.monoFont,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                    fontSize: AppTypography.micro,
                                  ),
                                ),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => setState(() {
                                _mobileSelectedIndex =
                                    (_mobileSelectedIndex + 1) %
                                        filteredProjects.length;
                              }),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(88, 36),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md),
                              ),
                              icon: const DirIcon(Icons.chevron_right_rounded,
                                  size: 16),
                              label: Text(loc.nextAction),
                            ),
                          ],
                        ),
                      ],
                    ],
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
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {
              SoundService.instance.playClick();
              context
                  .read<ProjectsFilterBloc>()
                  .add(const ProjectsFilterReset());
              setState(() {
                _mobileSelectedIndex = 0;
              });
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
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: AppTypography.micro,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Container(
                  height: 1,
                  color: isDark ? Colors.white24 : AppColors.slate300),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'SELECTED WORK',
          style: TextStyle(
            fontFamily: AppTypography.monoFont,
            color: scheme.primary,
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
              color: isDark ? Colors.white : AppColors.slate900,
              fontSize: isDesktop ? 48 : 36,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'In-depth looks at architecture, implementation, and measurable outcomes.',
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
}
