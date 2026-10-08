import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';

class ProjectTitleSection extends StatelessWidget {
  const ProjectTitleSection({
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
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            project.name,
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              color: context.onSurface,
              fontSize: isDesktop ? 38 : 28,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          project.tagline,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: context.onSurface,
            fontSize: isDesktop ? AppTypography.body : AppTypography.label,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
