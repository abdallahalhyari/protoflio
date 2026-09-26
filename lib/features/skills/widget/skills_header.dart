import 'package:flutter/material.dart';

import 'package:profile/features/skills/data/skills_data.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widget/section_masthead.dart';

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
      kicker: isDesktop
          ? 'FEATURE 04 · ARCHITECTURAL MASTERY'
          : 'FEATURE 04 · CORE SKILLS',
      title: loc.navSkills.toUpperCase(),
      subtitle: loc.sectionSubtitleSkills,
      isDesktop: isDesktop,
      // Icon, not a '✦' glyph: CanvasKit has no system fonts, so the
      // glyph pulled a 374 KB Noto Symbols 2 download.
      badgeIcon: Icons.auto_awesome,
      badgeLabel: '${kSkills.length} CORE DISCIPLINES',
    );
  }
}
