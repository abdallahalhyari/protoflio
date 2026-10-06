import 'package:flutter/material.dart';

import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/section_masthead.dart';

/// Top editorial header for the Skills & Disciplines section.
class SkillsHeader extends StatelessWidget {
  final bool isDesktop;

  const SkillsHeader({
    super.key,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SectionMasthead(
      title: loc.skillsHeaderTitle,
      subtitle: loc.skillsHeaderSubtitle,
      isDesktop: isDesktop,
    );
  }
}
