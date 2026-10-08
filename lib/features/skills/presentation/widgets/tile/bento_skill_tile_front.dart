import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
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
    final loc = AppLocalizations.of(context)!;
    final accentText = context.adaptiveAccentText(categoryColor);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHovered ? context.cardGlassHover : context.cardGlass,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: showFocus
              ? categoryColor
              : categoryColor.withValues(
                  alpha: isDark
                      ? (isHovered ? 0.75 : 0.35)
                      : (isHovered ? 0.75 : 0.45)),
          width: showFocus ? 2.5 : (isHovered ? 2.0 : 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? categoryColor.withValues(alpha: isHovered ? 0.35 : 0.12)
                : (isHovered
                    ? categoryColor.withValues(alpha: AppAlpha.fill)
                    : AppColors.ink900.withValues(alpha: 0.05)),
            blurRadius: isHovered ? 24 : 12,
            spreadRadius: isHovered ? 1 : 0,
            offset: Offset(0, isHovered ? 6 : 4),
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
                                  alpha: isDark ? 0.18 : 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: categoryColor.withValues(
                                      alpha: isDark ? 0.4 : 0.5)),
                            ),
                            child: Icon(skill.icon,
                                color: accentText, size: isDesktop ? 36 : 20),
                          ),
                          SizedBox(height: isDesktop ? 16 : 8),
                          // Desktop: fixed three-line slot, title centred
                          // in it. A one-line name and a three-line one
                          // shifted the icon and badge, so tiles in a row
                          // no longer lined up. Mobile tiles have no room
                          // for the slot (the FittedBox shrank them), so
                          // they keep the natural height.
                          SizedBox(
                            height: isDesktop
                                ? 22 * _kTitleLineHeight * _kTitleMaxLines
                                : null,
                            child: Center(
                              child: Text(
                                skill.name,
                                textAlign: TextAlign.center,
                                maxLines: _kTitleMaxLines,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTypography.displayFont,
                                  color: context.onSurface,
                                  fontSize: isDesktop ? 22 : 14,
                                  fontWeight: FontWeight.w900,
                                  height: isDesktop ? _kTitleLineHeight : null,
                                ),
                              ),
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
                              masteryLabel(skill.level, loc),
                              style: TextStyle(
                                color: context.onSurface,
                                fontSize: AppTypography.label,
                                fontWeight: FontWeight.w900,
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

const int _kTitleMaxLines = 3;
const double _kTitleLineHeight = 1.2;
