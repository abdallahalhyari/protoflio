import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_bloc.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_event.dart';
import 'package:profile/l10n/app_localizations.dart';

class ProjectsEmptyState extends StatelessWidget {
  const ProjectsEmptyState({
    super.key,
    required this.scheme,
    required this.isDesktop,
  });

  final ColorScheme scheme;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = scheme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xl,
        horizontal: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.14) : AppColors.ink200,
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.uiNoCaseStudies,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.onSurface,
              fontSize: isDesktop ? AppTypography.title : AppTypography.lead,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              l10n.projectsEmptyHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.mutedText,
                fontSize: AppTypography.body,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () {
              SoundService.instance.playClick();
              context
                  .read<ProjectsFilterBloc>()
                  .add(const ProjectsFilterReset());
            },
            child: Text(l10n.projectsEmptyShowAll),
          ),
        ],
      ),
    );
  }
}
