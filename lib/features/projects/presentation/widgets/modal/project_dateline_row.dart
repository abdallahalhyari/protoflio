import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';

class ProjectDatelineRow extends StatelessWidget {
  const ProjectDatelineRow({
    super.key,
    required this.project,
    required this.index,
    required this.isDesktop,
    required this.isDark,
    required this.scheme,
    required this.onOpenUrl,
  });

  final Project project;
  final int index;
  final bool isDesktop;
  final bool isDark;
  final ColorScheme scheme;
  final void Function(String url) onOpenUrl;

  String _ordinal(int index) => (index + 1).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  project.company,
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  isDesktop
                      ? 'FEATURE ARTICLE // VOL. ${_ordinal(index)}'
                      : 'VOL. ${_ordinal(index)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : AppColors.ink500,
                    fontSize: AppTypography.label,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (project.url != null || project.linkedinUrl != null)
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (project.url != null)
                InkWell(
                  onTap: () => onOpenUrl(project.url!),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.language_rounded,
                            size: 12, color: scheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Website',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: AppTypography.label,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(Icons.arrow_outward_rounded,
                            size: 11, color: scheme.primary),
                      ],
                    ),
                  ),
                ),
              if (project.linkedinUrl != null)
                InkWell(
                  onTap: () => onOpenUrl(project.linkedinUrl!),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.linkedIn.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      border: Border.all(
                          color: AppColors.linkedIn.withValues(alpha: 0.6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.linkedIn,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppTypography.label,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'sans-serif',
                              height: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LinkedIn',
                          style: TextStyle(
                            color: AppColors.linkedIn,
                            fontSize: AppTypography.label,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.arrow_outward_rounded,
                            size: 11, color: AppColors.linkedIn),
                      ],
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
