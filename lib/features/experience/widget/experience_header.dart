import 'package:flutter/material.dart';

import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widget/section_masthead.dart';

/// Top editorial header for the Career Trajectory / Experience section.
class ExperienceHeader extends StatelessWidget {
  final bool isDesktop;

  const ExperienceHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SectionMasthead(
      kicker: isDesktop
          ? 'FEATURE 02 · CAREER TRAJECTORY'
          : 'FEATURE 02 · EXPERIENCE',
      title: 'CAREER TRAJECTORY',
      subtitle: AppLocalizations.of(context)!.sectionSubtitleExperience,
      isDesktop: isDesktop,
      badgeIcon: Icons.auto_awesome,
      badgeLabel: '4 ROLES · ENTERPRISE IMPACT',
    );
  }
}
