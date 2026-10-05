import 'package:flutter/material.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/presentation/widgets/nfc_architecture_diagram.dart';
import 'package:profile/features/projects/presentation/widgets/pipeline_topology_diagram.dart';
import 'package:profile/features/projects/presentation/widgets/project_dossier_card.dart';

class ProjectDossierSection extends StatelessWidget {
  const ProjectDossierSection({
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        PipelineTopologyDiagram(
          project: project,
          isDesktop: isDesktop,
          isDark: isDark,
        ),
        if (project.problem != null)
          ProjectDossierCard(
            label: 'Core problem',
            value: project.problem!,
            accentColor: AppColors.signalLight,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.architecture != null)
          ProjectDossierCard(
            label: 'Architecture',
            value: project.architecture!,
            accentColor: AppColors.teal,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.hasArchitectureDiagram)
          NfcArchitectureDiagram(
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.solution != null)
          ProjectDossierCard(
            label: 'Engineering solution',
            value: project.solution!,
            accentColor: AppColors.teal,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.technicalDecisions != null &&
            project.technicalDecisions!.isNotEmpty)
          ProjectDossierCard(
            label: 'Decision',
            value: project.technicalDecisions!.first,
            accentColor: AppColors.goldSoft,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.lessonsLearned != null)
          ProjectDossierCard(
            label: 'Lesson learned',
            value: project.lessonsLearned!,
            accentColor: AppColors.gold,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
      ],
    );
  }
}
