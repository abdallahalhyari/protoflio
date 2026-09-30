import 'package:flutter/material.dart';
import 'package:profile/theme/tokens.dart';
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
            label: 'CORE PROBLEM',
            value: project.problem!,
            accentColor: AppColors.accentRoseSoft,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.architecture != null)
          ProjectDossierCard(
            label: 'ARCHITECTURE',
            value: project.architecture!,
            accentColor: AppColors.accentIndigo,
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
            label: 'ENGINEERING SOLUTION',
            value: project.solution!,
            accentColor: AppColors.accentGreen,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.technicalDecisions != null &&
            project.technicalDecisions!.isNotEmpty)
          ProjectDossierCard(
            label: 'DECISION',
            value: project.technicalDecisions!.first,
            accentColor: AppColors.accentAmberSoft,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
        if (project.lessonsLearned != null)
          ProjectDossierCard(
            label: 'LESSON LEARNED',
            value: project.lessonsLearned!,
            accentColor: AppColors.accentAmber,
            isDesktop: isDesktop,
            isDark: isDark,
          ),
      ],
    );
  }
}
