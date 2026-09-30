import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/theme/surface_tone.dart';

class ProjectTechStackSection extends StatelessWidget {
  const ProjectTechStackSection({
    super.key,
    required this.stack,
    required this.isDesktop,
    required this.isDark,
    required this.scheme,
  });

  final List<String> stack;
  final bool isDesktop;
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        for (final tech in stack)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: AppAlpha.whisper)
                  : AppColors.slate100,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(color: context.divider),
            ),
            child: Text(
              tech.toUpperCase(),
              style: TextStyle(
                fontFamily: AppTypography.monoFont,
                color: scheme.primary,
                fontSize:
                    isDesktop ? AppTypography.editorialSm : AppTypography.nano,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
      ],
    );
  }
}
