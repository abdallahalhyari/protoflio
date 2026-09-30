import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/presentation/widgets/project_dossier_card.dart';

class ProjectOutcomesSection extends StatelessWidget {
  const ProjectOutcomesSection({
    super.key,
    required this.project,
    required this.isDesktop,
    required this.isDark,
  });

  final Project project;
  final bool isDesktop;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < project.highlights.length; i++)
          ProjectHighlightRow(
            highlight: project.highlights[i],
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.results != null && project.results!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.5),
                child: Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.accentGreen, size: isDesktop ? 13 : 11),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'MEASURABLE OUTCOME: ',
                        style: TextStyle(
                          fontFamily: AppTypography.monoFont,
                          color: AppColors.accentGreen,
                          fontSize: isDesktop
                              ? AppTypography.editorial
                              : AppTypography.editorialSm,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: project.results!.first,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppColors.slate800,
                          fontSize: isDesktop ? 11 : 9.5,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
