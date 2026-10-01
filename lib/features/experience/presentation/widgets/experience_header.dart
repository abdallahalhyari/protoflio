import 'package:flutter/material.dart';

import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widget/section_masthead.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';

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
      kicker: 'FEATURE 02 · CAREER TRAJECTORY',
      // Heading = nav label, so nav, menu and page say the same thing.
      title: AppLocalizations.of(context)!.navExperience.toUpperCase(),
      subtitle: AppLocalizations.of(context)!.sectionSubtitleExperience,
      isDesktop: isDesktop,
      badgeIcon: Icons.auto_awesome_rounded,
      badgeLabel: AppLocalizations.of(context)!.badgeRoles(
          context.read<ExperienceRepository>().getExperiences().length),
    );
  }
}
