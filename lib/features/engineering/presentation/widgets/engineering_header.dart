import 'package:flutter/material.dart';

import 'package:profile/features/engineering/data/datasources/architecture_data.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/section_masthead.dart';

/// The top editorial header for the Systems Architecture / Engineering Expertise section.
class EngineeringHeader extends StatelessWidget {
  final bool isDesktop;

  const EngineeringHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SectionMasthead(
      kicker: loc.engineeringHeaderKicker,
      title: loc.navEngineering.toUpperCase(),
      subtitle: loc.sectionSubtitleEngineering,
      isDesktop: isDesktop,
      badgeIcon: Icons.hub_rounded,
      badgeLabel: loc.badgeArchitectures(kArchitectureTopics.length),
    );
  }
}
