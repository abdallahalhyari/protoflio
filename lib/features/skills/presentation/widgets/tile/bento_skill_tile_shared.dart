import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';

String masteryLabel(double level, AppLocalizations loc) {
  if (level >= 0.9) return loc.skillMasteryLead;
  if (level >= 0.75) return loc.skillMasteryCore;
  if (level >= 0.55) return loc.skillMasterySolid;
  return loc.skillMasteryGrowing;
}

class FlipHintPill extends StatelessWidget {
  const FlipHintPill({
    super.key,
    required this.isDark,
    required this.isDesktop,
  });

  final bool isDark;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: AppAlpha.hover)
              : AppColors.ink300,
          width: 0.8,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app_rounded,
              size: 11,
              color: context.mutedText,
            ),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context)?.flipHintTap ?? 'Tap to flip',
              style: TextStyle(
                color: context.mutedText,
                fontSize: AppTypography.label,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              Icons.refresh_rounded,
              size: 11,
              color: context.mutedText,
            ),
          ],
        ),
      ),
    );
  }
}

class SkillTagChip extends StatelessWidget {
  const SkillTagChip({
    super.key,
    required this.tag,
    required this.categoryColor,
    required this.isDesktop,
  });

  final String tag;
  final Color categoryColor;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.ink100,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: isDark ? Colors.white24 : AppColors.ink200),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: isDark
              ? categoryColor.withValues(alpha: 0.9)
              : context.adaptiveAccentText(categoryColor),
          fontSize: isDesktop ? 9.5 : 8.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
