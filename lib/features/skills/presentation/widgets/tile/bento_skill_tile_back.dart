import 'package:flutter/material.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/presentation/widgets/tile/bento_skill_tile_shared.dart';

class TileBackFace extends StatelessWidget {
  const TileBackFace({
    super.key,
    required this.skill,
    required this.categoryColor,
    required this.categoryGradient,
    required this.isDesktop,
  });

  final Skill skill;
  final Color categoryColor;
  final List<Color> categoryGradient;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accentText = context.adaptiveAccentText(categoryColor);
    final pct = (skill.level * 100).toInt();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.cardGlassHover,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: categoryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? categoryColor.withValues(alpha: 0.3)
                : AppColors.ink900.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: categoryGradient),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 16.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(skill.icon,
                            color: accentText, size: isDesktop ? 20 : 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            skill.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTypography.displayFont,
                              color: context.onSurface,
                              fontSize: isDesktop ? 16 : 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor.withValues(
                                alpha: isDark ? 0.12 : 0.10),
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flip_to_front_rounded,
                                  size: 10, color: accentText),
                              const SizedBox(width: 3),
                              Text(
                                'FLIP',
                                style: TextStyle(
                                  color: accentText,
                                  fontSize: AppTypography.label,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isDesktop ? 12 : 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          skill.description,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.85)
                                : AppColors.ink700,
                            fontSize: AppTypography.label,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isDesktop ? 8 : 6),
                    Row(
                      children: [
                        Text(
                          'MASTERY $pct%',
                          style: TextStyle(
                            color: accentText,
                            fontSize: AppTypography.label,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                            child: LinearProgressIndicator(
                              value: skill.level,
                              minHeight: 4,
                              backgroundColor: categoryColor.withValues(
                                  alpha: isDark ? 0.15 : 0.10),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                categoryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (skill.tags.isNotEmpty) ...[
                      SizedBox(height: isDesktop ? 10 : 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          for (final tag in skill.tags)
                            SkillTagChip(
                              tag: tag,
                              categoryColor: categoryColor,
                              isDesktop: isDesktop,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
