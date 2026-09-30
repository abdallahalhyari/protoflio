import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
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
            project.name.toUpperCase(),
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              color: context.onSurface,
              fontSize: isDesktop ? 38 : 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
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
            color: isDark
                ? Colors.white.withValues(alpha: 0.85)
                : AppColors.slate700,
            fontSize: isDesktop ? 13 : 11.5,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
