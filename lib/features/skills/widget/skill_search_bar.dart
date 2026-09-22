import 'package:flutter/material.dart';
import 'package:profile/theme/surface_tone.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/tokens.dart';

/// Glassmorphic, real-time search and filter bar for the Skills matrix.
/// Includes interactive query input, instant clear action, and live count badge.
class SkillSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final int totalCount;
  final int filteredCount;
  final bool isDesktop;

  const SkillSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.totalCount,
    required this.filteredCount,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isFiltered =
        controller.text.trim().isNotEmpty || filteredCount < totalCount;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : AppColors.slate100.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: isFiltered
              ? scheme.primary.withValues(alpha: 0.5)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.slate200),
          width: isFiltered ? 1.2 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6, end: 8),
            child: Icon(
              Icons.search_rounded,
              size: 18,
              color: isFiltered
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                fontSize: AppTypography.small,
                fontWeight: FontWeight.w600,
                color: context.onSurface,
              ),
              cursorColor: scheme.primary,
              decoration: InputDecoration(
                hintText: l10n.skillsSearchHint,
                hintStyle: TextStyle(
                  fontSize:
                      isDesktop ? AppTypography.small : AppTypography.caption,
                  color: scheme.onSurface.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 16),
              tooltip: l10n.skillsClearSearch,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              color: scheme.onSurface.withValues(alpha: 0.6),
              onPressed: () {
                SoundService.instance.playClick();
                onClear();
              },
            ),
          const SizedBox(width: 4),
          // Live Results Count Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isFiltered
                  ? scheme.primary.withValues(alpha: isDark ? 0.16 : 0.12)
                  : (isDark
                      ? Colors.white.withValues(alpha: AppAlpha.whisper)
                      : Colors.black.withValues(alpha: 0.05)),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isFiltered
                    ? scheme.primary.withValues(alpha: AppAlpha.border)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isFiltered) ...[
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  isFiltered
                      ? l10n.skillsCountFiltered(filteredCount, totalCount)
                      : l10n.skillsCountAll(totalCount),
                  style: TextStyle(
                    fontSize: AppTypography.overlineTight,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isFiltered
                        ? scheme.primary
                        : scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
