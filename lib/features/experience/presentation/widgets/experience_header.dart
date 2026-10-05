import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/editorial_chip.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionMasthead(
          kicker: loc.experienceHeaderKicker,
          title: loc.navExperience.toUpperCase(),
          subtitle: loc.sectionSubtitleExperience,
          isDesktop: isDesktop,
          badgeIcon: Icons.auto_awesome_rounded,
          badgeLabel: loc.badgeRoles(4),
        ),
        const SizedBox(height: AppSpacing.xs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              EditorialChip(
                label: 'HEALTHCARE & SMART CARDS',
                icon: Icons.health_and_safety_rounded,
                tone: ChipTone.sky,
                dense: true,
              ),
              SizedBox(width: 6),
              EditorialChip(
                label: 'ENTERPRISE HIS',
                icon: Icons.corporate_fare_rounded,
                tone: ChipTone.amber,
                dense: true,
              ),
              SizedBox(width: 6),
              EditorialChip(
                label: 'FLEET & TELEMATICS',
                icon: Icons.directions_car_rounded,
                tone: ChipTone.green,
                dense: true,
              ),
              SizedBox(width: 6),
              EditorialChip(
                label: 'M-COMMERCE & STREAMING',
                icon: Icons.storefront_rounded,
                tone: ChipTone.indigo,
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
