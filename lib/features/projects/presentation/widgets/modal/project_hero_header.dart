import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';

class ProjectHeroHeader extends StatelessWidget {
  const ProjectHeroHeader({
    super.key,
    required this.project,
    required this.isDesktop,
  });

  final Project project;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = context.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [scheme.primary, AppColors.accentPurpleSoft],
            ),
          ),
        ),
        if (project.heroImagePath != null)
          Container(
            width: double.infinity,
            height: isDesktop ? 300 : 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(project.heroImagePath!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    isDark
                        ? Colors.black.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.5),
                  ],
                ),
              ),
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(AppSpacing.smd),
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black45,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
