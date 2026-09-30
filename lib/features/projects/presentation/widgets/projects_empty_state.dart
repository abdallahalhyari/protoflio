import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_bloc.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_event.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded,
              size: 48, color: scheme.primary.withValues(alpha: 0.6)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'NO CASE STUDIES MATCHED',
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              fontSize: isDesktop ? 20 : 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Try selecting another industry domain or clearing the active technology filter.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onSurface.withValues(alpha: 0.7),
              fontSize: AppTypography.small,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {
              SoundService.instance.playClick();
              context
                  .read<ProjectsFilterBloc>()
                  .add(const ProjectsFilterReset());
            },
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('RESET FILTERS'),
          ),
        ],
      ),
    );
  }
}
