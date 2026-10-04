import 'package:flutter/material.dart';

import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/section_masthead.dart';

/// Top editorial header for the Career Trajectory / Experience section.
class ExperienceHeader extends StatelessWidget {
  final bool isDesktop;

  const ExperienceHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SectionMasthead(
      kicker: loc.experienceHeaderKicker,
      // Heading = nav label, so nav, menu and page say the same thing.
      title: loc.navExperience.toUpperCase(),
      subtitle: loc.sectionSubtitleExperience,
      isDesktop: isDesktop,
      badgeIcon: Icons.auto_awesome_rounded,
      badgeLabel: loc.badgeRoles(4),
    );
  }
}
