import 'package:flutter/material.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/case_study/presentation/widgets/case_study_widgets.dart';

import 'package:profile/features/projects/presentation/widgets/card/hero/project_card_link_icon.dart';

class CompanyQuickLinks extends StatelessWidget {
  const CompanyQuickLinks({
    super.key,
    required this.project,
    required this.scheme,
    required this.caseStudySlug,
  });

  final Project project;
  final ColorScheme scheme;
  final String? caseStudySlug;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (project.url != null)
          ProjectCardLinkIcon(
            tooltip: 'Visit ${project.company} official website',
            url: project.url,
            icon: Icons.language_rounded,
            company: project.company,
            type: 'website',
            scheme: scheme,
          ),
        if (project.linkedinUrl != null) ...[
          const SizedBox(width: 6),
          ProjectCardLinkIcon(
            tooltip: 'View ${project.company} on LinkedIn',
            url: project.linkedinUrl,
            isLinkedIn: true,
            company: project.company,
            type: 'linkedin',
            scheme: scheme,
          ),
        ],
        if (caseStudySlug != null) ...[
          const SizedBox(width: 6),
          ProjectCardLinkIcon(
            tooltip: 'Copy link to ${project.name} case study',
            icon: Icons.share_rounded,
            onTap: () => shareCaseStudy(
              context,
              slug: caseStudySlug!,
              title: project.name,
            ),
            company: project.company,
            type: 'share_case_study',
            scheme: scheme,
          ),
        ],
      ],
    );
  }
}
