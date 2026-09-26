import 'package:flutter/material.dart';

import 'package:profile/features/engineering/data/architecture_data.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widget/section_masthead.dart';

/// The top editorial header for the Systems Architecture / Engineering Expertise section.
class EngineeringHeader extends StatelessWidget {
  final bool isDesktop;

  const EngineeringHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return SectionMasthead(
      kicker: 'FEATURE 05 · SYSTEMS ARCHITECTURE',
      title: AppLocalizations.of(context)!.navEngineering.toUpperCase(),
      subtitle: AppLocalizations.of(context)!.sectionSubtitleEngineering,
      isDesktop: isDesktop,
      badgeIcon: Icons.hub_outlined,
      badgeLabel: '${kArchitectureTopics.length} ARCHITECTURES',
    );
  }
}
