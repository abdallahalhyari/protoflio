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
                  project.company.toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    color: scheme.primary,
                    fontSize: AppTypography.editorialSm,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
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
                    fontFamily: AppTypography.monoFont,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : AppColors.slate500,
                    fontSize: AppTypography.editorialSm,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
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
                          'WEBSITE',
                          style: TextStyle(
                            fontFamily: AppTypography.monoFont,
                            color: scheme.primary,
                            fontSize: AppTypography.micro,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
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
                              fontSize: AppTypography.nano,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'sans-serif',
                              height: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'LINKEDIN',
                          style: TextStyle(
                            fontFamily: AppTypography.monoFont,
                            color: AppColors.linkedIn,
                            fontSize: AppTypography.micro,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
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
