import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../data/skills_data.dart';
import '../widget/skill_tile.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final headingSize =
        (size.width * 0.055).clamp(AppTypography.heading, AppTypography.displayLg);
    final cross = size.width >= 900 ? 3 : size.width >= 600 ? 2 : 1;

    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final loc = AppLocalizations.of(context)!;
    
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          child: Column(
            children: [
              Text(
                loc.navSkills.toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontSize: headingSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  itemCount: kSkills.length,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 84,
                  ),
                  itemBuilder: (_, i) => SkillTile(
                    skill: kSkills[i],
                    index: i,
                    delay: Duration(milliseconds: 80 * i), // staggered — keep raw
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

