import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/projects/presentation/widgets/interactive_project_card.dart';
import 'package:profile/shared/widgets/screen_shell.dart';
import 'package:profile/shared/widgets/section_masthead.dart';

/// The four case studies, all on screen at once: two columns where there
/// is room, one stacked column where there is not. Cards take their
/// natural height so nothing is clipped; in a two-column row both cards
/// stretch to the taller one, so the "Read case study" rows line up.
///
/// There is no filtering: with four projects, one per domain, a filter
/// only ever hid work.
class ProjectsPage extends StatelessWidget {
  final bool isContinuousMobile;

  const ProjectsPage({
    super.key,
    this.isContinuousMobile = false,
  });

  /// Below this content width the cards stack in one column.
  static const double _twoColumnMinWidth = 720;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final loc = AppLocalizations.of(context)!;
    final projects = context.read<ProjectRepository>().getProjects();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionMasthead(
          title: loc.navWork,
          subtitle: loc.sectionSubtitleWork,
          isDesktop: isDesktop,
        ),
        const SizedBox(height: AppSpacing.sectionContent),
        LayoutBuilder(
          builder: (context, constraints) {
            Widget card(int i, {bool fill = false}) => InteractiveProjectCard(
                  key: ValueKey('project_card_${projects[i].company}'),
                  project: projects[i],
                  index: i,
                  scheme: scheme,
                  isDesktop: isDesktop,
                  fillHeight: fill,
                );

            if (constraints.maxWidth < _twoColumnMinWidth) {
              return Column(
                key: const Key('projects_list'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (int i = 0; i < projects.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.lg),
                    card(i),
                  ],
                ],
              );
            }

            return Column(
              key: const Key('projects_grid'),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < projects.length; i += 2) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.lg),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: card(i, fill: true)),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(
                          child: i + 1 < projects.length
                              ? card(i + 1, fill: true)
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );

    return AppScreenShell(
      maxWidth: kSectionMaxWidth,
      verticalPadding: AppSpacing.xl,
      reserveBottomNav: !isContinuousMobile,
      reserveMobileTop: !isContinuousMobile,
      child: isContinuousMobile
          ? content
          : SingleChildScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: content,
            ),
    );
  }
}
