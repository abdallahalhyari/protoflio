import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../data/projects_data.dart';
import '../widget/project_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    final cross = size.width >= 1100 ? 2 : 1;
    final loc = AppLocalizations.of(context)!;

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.lg + 4, AppSpacing.lg, AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                loc.navProjects.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: headingSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: cross == 1
                    ? ListView.separated(
                        itemCount: kProjects.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.smd),
                        itemBuilder: (_, i) => ProjectCard(project: kProjects[i], index: i),
                      )
                    : GridView.builder(
                        itemCount: kProjects.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.smd,
                          crossAxisSpacing: AppSpacing.smd,
                          mainAxisExtent: 380,
                        ),
                        itemBuilder: (_, i) =>
                            ProjectCard(project: kProjects[i], index: i),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

