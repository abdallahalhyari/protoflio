import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../util/open_url.dart';
import '../model/project.dart';
import 'app_card.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;

  Future<void> _open(BuildContext context) async {
    final url = widget.project.url;
    if (url == null) return;
    await openUrl(context, url);
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    final canOpen = project.url != null;
    final reduce = MediaQuery.of(context).disableAnimations;
    final hovered = _hover && !reduce;

    return MouseRegion(
      cursor: canOpen ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: AppMotion.sm,
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, hovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: hovered
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.25),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                ]
              : const [],
        ),
        child: AppCard.outlined(
          padding: const EdgeInsets.all(AppSpacing.md + 2),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: TextStyle(
                    color: onSurface,
                    fontSize: AppTypography.titleSm,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (project.url != null)
                IconButton(
                  tooltip: 'projects.open_link'.tr(),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.open_in_new,
                      size: 18, color: scheme.primary),
                  onPressed: () => _open(context),
                ),
            ],
          ),
          Text(
            project.company,
            style: TextStyle(
              color: scheme.primary,
              fontSize: AppTypography.small,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            project.tagline,
            style: TextStyle(
              color: onSurface.withValues(alpha: 0.85),
              fontSize: AppTypography.body,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          ...project.highlights.map(
            (h) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm - 2),
                    child: Icon(Icons.check_circle,
                        size: 12, color: scheme.primary),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      h,
                      style: TextStyle(
                        color: onSurface.withValues(alpha: 0.85),
                        fontSize: AppTypography.small,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          Wrap(
            spacing: AppSpacing.sm - 2,
            runSpacing: AppSpacing.sm - 2,
            children: project.stack
                .map(
                  (t) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.smd - 2,
                        vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.35)),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: AppTypography.micro + 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
        ),
      ),
    );
  }
}
