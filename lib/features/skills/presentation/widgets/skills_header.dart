import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
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
      kicker: 'FEATURE 04 · ARCHITECTURAL MASTERY',
      title: loc.navStack.toUpperCase(),
      subtitle: loc.sectionSubtitleSkills,
      isDesktop: isDesktop,
      // Icon, not a '✦' glyph: CanvasKit has no system fonts, so the
      // glyph pulled a 374 KB Noto Symbols 2 download.
      badgeIcon: Icons.auto_awesome_rounded,
      badgeLabel: '${context.read<SkillRepository>().getSkillCount()} CORE DISCIPLINES',
    );
  }
}
