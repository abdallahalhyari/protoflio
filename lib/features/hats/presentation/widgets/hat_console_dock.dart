import 'package:flutter/material.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/hats/domain/entities/hat_info.dart';
import 'package:profile/shared/widgets/conditional_blur.dart';
import 'package:profile/shared/widgets/directional_icon.dart';
import 'package:profile/core/theme/surface_tone.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/core/services/sound_service.dart';
import 'package:profile/features/hats/presentation/utils/hat_labels.dart';
import 'package:profile/shared/utils/bidi.dart';

/// Floating interactive bottom console dock on desktop for navigating roles,
/// triggering deck shuffle/align, and showing active keyboard shortcuts.
class HatConsoleDock extends StatelessWidget {
  final int selectedIndex;
  final int totalCount;
  final HatInfo currentHat;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onShuffle;
  final VoidCallback onReset;

  const HatConsoleDock({
    super.key,
    required this.selectedIndex,
    required this.totalCount,
    required this.currentHat,
    required this.onPrev,
    required this.onNext,
    required this.onShuffle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;

    return Center(
      child: ConditionalBlur(
        sigma: 14,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: context.modalSurface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: context.divider,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DockNavButton(
                  label: loc.perspectivePrev,
                  tooltip: '${loc.perspectivePrev} (Left arrow / A)',
                  icon: const DirIcon(Icons.arrow_back_rounded, size: 14),
                  onPressed: onPrev,
                  isDark: isDark,
                  iconLeading: true,
                ),
                const SizedBox(width: AppSpacing.sm),
                _ActiveRolePill(
                  currentHat: currentHat,
                  selectedIndex: selectedIndex,
                  totalCount: totalCount,
                ),
                const SizedBox(width: AppSpacing.sm),
                _DockNavButton(
                  label: loc.perspectiveNext,
                  tooltip: '${loc.perspectiveNext} (Right arrow / D)',
                  icon: const DirIcon(Icons.arrow_forward_rounded, size: 14),
                  onPressed: onNext,
                  isDark: isDark,
                  iconLeading: false,
                ),
                const SizedBox(width: AppSpacing.sm),
                const _DockDivider(),
                const SizedBox(width: AppSpacing.sm),
                // Quick Shuffle Button
                IconButton(
                  tooltip: '${loc.spreadAction} [S]',
                  onPressed: () {
                    SoundService.instance.playSelection();
                    onShuffle();
                  },
                  iconSize: 16,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    foregroundColor: isDark ? primary : AppColors.accentSkyDeep,
                  ),
                  icon: const Icon(Icons.auto_awesome_motion_rounded),
                ),
                const SizedBox(width: AppSpacing.xs),
                // Quick Reset/Align Button
                IconButton(
                  tooltip: '${loc.alignAction} [R]',
                  onPressed: () {
                    SoundService.instance.playClick();
                    onReset();
                  },
                  iconSize: 16,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    foregroundColor:
                        isDark ? Colors.white60 : AppColors.slate500,
                  ),
                  icon: const Icon(Icons.layers_clear_rounded),
                ),
                const SizedBox(width: AppSpacing.sm),
                const _DockDivider(),
                const SizedBox(width: AppSpacing.sm),
                const _ShortcutBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Extracted widgets
// ---------------------------------------------------------------------------

/// Prev / Next navigation button — shared style, parameterised direction.
class _DockNavButton extends StatelessWidget {
  const _DockNavButton({
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    required this.isDark,
    required this.iconLeading,
  });

  final String label;
  final String tooltip;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isDark;

  /// When `true` the icon appears before the label (prev); when `false`
  /// it appears after (next). `OutlinedButton.icon` always places the icon
  /// before the label, so we swap the arguments for the next button's
  /// visual order by relying on DirIcon + RTL layout.
  final bool iconLeading;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: OutlinedButton.icon(
        onPressed: () {
          SoundService.instance.playClick();
          onPressed();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white70 : AppColors.slate700,
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.2)
                : AppColors.slate300,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 32),
          visualDensity: VisualDensity.standard,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.monoFont,
            fontSize: AppTypography.editorialSm,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

/// Animated pill showing the glowing dot, ordinal counter, and role title.
class _ActiveRolePill extends StatelessWidget {
  const _ActiveRolePill({
    required this.currentHat,
    required this.selectedIndex,
    required this.totalCount,
  });

  final HatInfo currentHat;
  final int selectedIndex;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: AppMotion.sm,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: currentHat.color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(
          color: currentHat.color.withValues(alpha: 0.55),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentHat.color,
              boxShadow: [
                BoxShadow(
                  color: currentHat.color.withValues(alpha: 0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(
            ltrAlways(context, '0${selectedIndex + 1} / 0$totalCount'),
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              color: _readable(context, currentHat.color),
              fontSize: AppTypography.editorialSm,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '·',
            style: TextStyle(
              color: currentHat.color.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            hatTitleLabel(loc, currentHat.title).toUpperCase(),
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              color: context.onSurface,
              fontSize: AppTypography.editorialSm,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin vertical separator between dock sections.
class _DockDivider extends StatelessWidget {
  const _DockDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 18,
      color: context.glassBorderStrong,
    );
  }
}

/// Keyboard shortcut hint badge (⌨ A/D/S/R).
class _ShortcutBadge extends StatelessWidget {
  const _ShortcutBadge();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.slate100,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.slate200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.keyboard_rounded,
            size: 13,
            color: context.subtleText,
          ),
          const SizedBox(width: 5),
          Text(
            loc.perspectiveShortcutsHint,
            style: TextStyle(
              fontFamily: AppTypography.monoFont,
              fontSize: AppTypography.micro,
              color: context.subtleText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// A role colour made legible as text on the dock: dark-mode colours too
/// dim for the near-black dock are lifted toward white; light mode uses
/// the shared accessible-text mapping.
Color _readable(BuildContext context, Color color) {
  if (!context.isDarkMode) return context.adaptiveAccentText(color);
  return color.computeLuminance() < 0.2
      ? Color.lerp(color, Colors.white, 0.55)!
      : color;
}
