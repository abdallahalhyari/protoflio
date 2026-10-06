import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:profile/core/theme/tokens.dart';

/// Extension on [BuildContext] that resolves the "glass surface" recipe
/// widgets across `lib/module/home/` were previously hand-rolling via
/// inline `isDark ?` forks. One brightness read, one shared vocabulary
/// — swap dark/light palettes in one place instead of grepping 42
/// widgets.
///
/// Colors are the same ones the widgets were computing manually before,
/// but derived from `AppColors.darkSurface` and the seed slate palette
/// so any future rebrand ripples out from `tokens.dart`.
extension SurfaceTone on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Translucent glass surface for floating toolbars — top nav pill,
  /// mobile app bar, folio bar, pager pill. Slightly opaque so text
  /// stays legible over any canvas.
  ///
  /// 78% dark glass was tuned to sit on a backdrop blur, but
  /// ConditionalBlur skips the blur on web (too costly in CanvasKit), so
  /// there scrolling copy read crisply straight through the chrome. Without
  /// a blur the dark glass is denser.
  Color get glassSurface {
    // No backdrop blur on web (ConditionalBlur skips it), so the glass has
    // to hide scrolled copy on its own: at 92% headings still read through
    // the app bar in both themes.
    final unblurred = kIsWeb || AppMedia.reduceBlur(this);
    return isDarkMode
        ? AppColors.darkSurface.withValues(alpha: unblurred ? 0.97 : 0.78)
        : Theme.of(this)
            .scaffoldBackgroundColor
            .withValues(alpha: unblurred ? 0.97 : 0.92);
  }

  /// Slightly denser glass — used for raised toggles (theme puck,
  /// audio puck) that sit on top of `glassSurface` panels.
  Color get glassRaised => isDarkMode
      ? AppColors.darkSurfaceElevated.withValues(alpha: 0.92)
      : Theme.of(this).scaffoldBackgroundColor.withValues(alpha: 0.98);

  /// Rest-state hairline border on any glass surface.
  Color get glassBorder =>
      isDarkMode ? Colors.white.withValues(alpha: 0.14) : AppColors.ink300;

  /// Focused / hovered border — a step brighter than [glassBorder].
  Color get glassBorderStrong =>
      isDarkMode ? Colors.white.withValues(alpha: 0.24) : AppColors.ink400;

  /// Dense frosted glass fill for content cards across all sections.
  /// Balanced at 88% in Dark and 92% in Light so background orbs
  /// peek through without compromising text legibility or WCAG contrast.
  Color get cardGlass => isDarkMode ? AppColors.darkCard : AppColors.cardStock;

  /// Hover / active state for [cardGlass] — slightly denser for focus.
  Color get cardGlassHover =>
      isDarkMode ? AppColors.darkSurfaceElevated : Colors.white;

  /// Solid modal / dialog fill. Denser than [cardGlass] because full-screen
  /// dialogs should not let the canvas show through. Use on `Dialog`,
  /// full-page modals, floating dock panels.
  Color get modalSurface =>
      isDarkMode ? AppColors.darkModal : AppColors.cardStock;

  /// Primary body text on the current canvas.
  Color get onSurface => isDarkMode ? Colors.white : AppColors.ink900;

  /// Muted text on the current canvas. Bumped from the old 0.60 in
  /// dark to 0.72 so 12pt copy passes 4.5:1 over `darkSurface`.
  Color get mutedText =>
      isDarkMode ? Colors.white.withValues(alpha: 0.72) : AppColors.ink600;

  /// Very-muted meta text (folio bar counter, timestamp). Passes
  /// AA-large only — reserve for 11pt+ semibold.
  /// Quiet secondary text. Slate-600 in light mode: slate-500 fell to
  /// 4.3:1 on the slate-100 panels it sits on.
  Color get subtleText =>
      isDarkMode ? Colors.white.withValues(alpha: 0.55) : AppColors.ink600;

  /// Divider hairline between rows / puck separators.
  Color get divider =>
      isDarkMode ? Colors.white.withValues(alpha: 0.12) : AppColors.ink200;

  /// Signature accent used for the resume-download CTA.
  /// Amber in dark mode, deep rich bronze/amber in light mode for 5.8:1 contrast.
  Color get resumeAccent =>
      isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;

  /// Border for the resume CTA.
  Color get resumeBorder => isDarkMode ? AppColors.goldSoft : AppColors.gold;

  /// Semantic accessible accent text colors (>4.5:1 contrast in both modes)
  Color get amberText => isDarkMode ? AppColors.goldSoft : AppColors.goldDeep;
  Color get greenText => isDarkMode ? AppColors.tealLight : AppColors.tealDeep;
  Color get indigoText => isDarkMode ? AppColors.tealLight : AppColors.tealDeep;

  /// [color] as legible text: its accessible deep counterpart in light
  /// mode; in dark mode lifted just enough to clear 5:1 on the card
  /// surface (mid-tones like violet sat at 4.3:1).
  Color adaptiveAccentText(Color color) => isDarkMode
      ? AppColors.legibleOn(color, AppColors.darkCard, target: 6.0)
      : AppColors.toAccessibleLightText(color);

  // ---------------------------------------------------------------------------
  // Top Nav & Chip Helpers (Migrated from inline `isDark` checks)
  // ---------------------------------------------------------------------------

  Color get navDivider => isDarkMode
      ? Colors.white.withValues(alpha: 0.24)
      : Colors.black.withValues(alpha: 0.12);

  Color navSurfaceBorder(Color accent) =>
      accent.withValues(alpha: isDarkMode ? 0.35 : 0.22);

  /// Resting lift for floating chrome. Ink-tinted, never coloured.
  List<BoxShadow> ambientGlow(Color accent) => [
        BoxShadow(
          color: isDarkMode ? AppColors.shadowMedium : AppColors.shadowSoft,
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  Color activeChipSurface(Color accent) =>
      accent.withValues(alpha: isDarkMode ? 0.24 : 0.14);

  Color hoverChipSurface(Color accent) =>
      accent.withValues(alpha: isDarkMode ? 0.08 : 0.06);

  Color activeChipBorder(Color accent) =>
      accent.withValues(alpha: isDarkMode ? 0.55 : 0.40);

  /// Chips sit flat on the page; state shows in fill and border.
  List<BoxShadow> activeChipShadow(Color accent) => const [];

  List<BoxShadow> hoverChipShadow(Color accent) => const [];

  // ---------------------------------------------------------------------------
  // Case Study Companion & Progress Indicators
  // ---------------------------------------------------------------------------

  Color get progressTrack => isDarkMode
      ? Colors.white.withValues(alpha: AppAlpha.whisper)
      : Colors.black.withValues(alpha: 0.05);

  Color glowAccent(Color accent) =>
      accent.withValues(alpha: isDarkMode ? 0.8 : 0.6);

  Color glowSecondary(Color accent) =>
      accent.withValues(alpha: isDarkMode ? 0.6 : 0.4);

  Color get dockSurface => isDarkMode
      ? AppColors.darkCanvas.withValues(alpha: 0.91)
      : Colors.white.withValues(alpha: 0.94);

  Color get dockBorder => glassBorder;

  List<BoxShadow> get dockShadows => [
        BoxShadow(
          color: isDarkMode ? AppColors.shadowDeep : AppColors.shadowMedium,
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  Color railDot(Color color) =>
      color.withValues(alpha: isDarkMode ? 0.35 : 0.45);

  // ---------------------------------------------------------------------------
  // Card & Container Decoration Helpers
  // ---------------------------------------------------------------------------

  /// The card recipe: an opaque card-stock fill, a hairline border that
  /// takes the accent on hover/selection, and a soft ink shadow when
  /// lifted. No coloured glow.
  BoxDecoration cardDecoration({
    Color? accent,
    bool isHovered = false,
    bool isSelected = false,
    double radius = AppRadius.card,
    Color? customFill,
    List<BoxShadow>? shadows,
  }) {
    final active = isHovered || isSelected;
    final fill = customFill ?? (active ? cardGlassHover : cardGlass);
    final borderColor = active
        ? (accent ?? Theme.of(this).colorScheme.primary)
            .withValues(alpha: isSelected ? 0.9 : 0.6)
        : glassBorder;

    final defaultShadows = active
        ? [
            BoxShadow(
              color: isDarkMode ? AppColors.shadowDeep : AppColors.shadowMedium,
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ]
        : [
            BoxShadow(
              color: AppColors.shadowSoft,
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ];

    return BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: borderColor,
        width: isSelected ? 1.5 : 1.0,
      ),
      boxShadow: shadows ?? defaultShadows,
    );
  }
}
