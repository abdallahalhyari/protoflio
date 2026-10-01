import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/presentation/widgets/tile/bento_skill_tile_shared.dart';

class TileFrontFace extends StatelessWidget {
  const TileFrontFace({
    super.key,
    required this.skill,
    required this.categoryColor,
    required this.categoryGradient,
    required this.isDesktop,
    required this.isHovered,
    required this.showFocus,
  });

  final Skill skill;
  final Color categoryColor;
  final List<Color> categoryGradient;
  final bool isDesktop;
  final bool isHovered;
  final bool showFocus;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final accentText = context.adaptiveAccentText(categoryColor);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHovered ? context.cardGlassHover : context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: showFocus
              ? categoryColor
              : categoryColor.withValues(alpha: isDark ? 0.3 : 0.4),
          width: showFocus ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? categoryColor.withValues(alpha: 0.1)
                : AppColors.slate900.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                child: LayoutBuilder(
                  builder: (context, constraints) => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(isDesktop ? 12 : 6),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(
                                  alpha: isDark ? 0.15 : 0.10),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: categoryColor.withValues(
                                      alpha: isDark ? 0.3 : 0.4)),
                            ),
                            child: Icon(skill.icon,
                                color: accentText, size: isDesktop ? 36 : 20),
                          ),
                          SizedBox(height: isDesktop ? 16 : 8),
                          Text(
                            skill.name.toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTypography.displayFont,
                              color: context.onSurface,
                              fontSize: isDesktop ? 22 : 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: isDesktop ? 8 : 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(
                                  alpha: isDark ? 0.2 : 0.12),
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Text(
                              masteryLabel(skill.level),
                              style: TextStyle(
                                fontFamily: AppTypography.monoFont,
                                color: context.onSurface,
                                fontSize: isDesktop ? 11 : 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          if (!isDesktop) ...[
                            const SizedBox(height: 8),
                            FlipHintPill(isDark: isDark, isDesktop: isDesktop),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
