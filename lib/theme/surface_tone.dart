import 'package:flutter/material.dart';

import 'tokens.dart';

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
  Color get glassSurface => isDarkMode
      ? AppColors.darkSurface.withValues(alpha: 0.78)
      : Theme.of(this).scaffoldBackgroundColor.withValues(alpha: 0.92);

  /// Slightly denser glass — used for raised toggles (theme puck,
  /// audio puck) that sit on top of `glassSurface` panels.
  Color get glassRaised => isDarkMode
      ? AppColors.darkSurfaceElevated.withValues(alpha: 0.92)
      : Theme.of(this).scaffoldBackgroundColor.withValues(alpha: 0.98);

  /// Rest-state hairline border on any glass surface.
  Color get glassBorder =>
      isDarkMode ? Colors.white.withValues(alpha: 0.14) : AppColors.slate200;

  /// Focused / hovered border — a step brighter than [glassBorder].
  Color get glassBorderStrong =>
      isDarkMode ? Colors.white.withValues(alpha: 0.24) : AppColors.slate300;

  /// Card fill used for resting cards on the canvas — slightly warmer
  /// than [glassSurface] to sit "below" the floating chrome.
  Color get raisedCard => isDarkMode ? AppColors.darkCard : Theme.of(this).scaffoldBackgroundColor;

  /// Dense frosted glass fill for content cards across all sections.
  /// Balanced at 88% in Dark and 92% in Light so background orbs
  /// peek through without compromising text legibility or WCAG contrast.
  Color get cardGlass => isDarkMode
      ? AppColors.darkCard.withValues(alpha: 0.88)
      : Theme.of(this).scaffoldBackgroundColor.withValues(alpha: 0.92);

  /// Hover / active state for [cardGlass] — slightly denser for focus.
  Color get cardGlassHover => isDarkMode
      ? AppColors.darkSurfaceElevated.withValues(alpha: 0.95)
      : Theme.of(this).scaffoldBackgroundColor.withValues(alpha: 0.96);

  /// Solid modal / dialog fill. Denser than [cardGlass] because full-screen
  /// dialogs should not let the canvas show through. Use on `Dialog`,
  /// full-page modals, floating dock panels.
  Color get modalSurface =>
      isDarkMode ? AppColors.darkModal : Colors.white;

  /// Near-black terminal chrome for CLI-styled panels (telemetry strips,
  /// code readouts). Denser than [modalSurface] to feel like a headless
  /// shell.
  Color get terminalSurface =>
      isDarkMode ? AppColors.darkTerminal : AppColors.slate900;

  /// Primary body text on the current canvas.
  Color get onSurface => isDarkMode ? Colors.white : AppColors.slate900;

  /// Muted text on the current canvas. Bumped from the old 0.60 in
  /// dark to 0.72 so 12pt copy passes 4.5:1 over `darkSurface`.
  Color get mutedText =>
      isDarkMode ? Colors.white.withValues(alpha: 0.72) : AppColors.slate600;

  /// Very-muted meta text (folio bar counter, timestamp). Passes
  /// AA-large only — reserve for 11pt+ semibold.
  Color get subtleText =>
      isDarkMode ? Colors.white.withValues(alpha: 0.55) : AppColors.slate500;

  /// Divider hairline between rows / puck separators.
  Color get divider =>
      isDarkMode ? Colors.white.withValues(alpha: 0.12) : AppColors.slate200;

  /// Signature accent used for the resume-download CTA.
  /// Amber in dark mode, deep rich bronze/amber in light mode for 5.8:1 contrast.
  Color get resumeAccent =>
      isDarkMode ? AppColors.accentAmberSoft : AppColors.accentAmberDeep;

  /// Border for the resume CTA.
  Color get resumeBorder =>
      isDarkMode ? AppColors.accentAmber : AppColors.accentAmberBright;

  /// Semantic accessible accent text colors (>4.5:1 contrast in both modes)
  Color get amberText =>
      isDarkMode ? AppColors.accentAmberSoft : AppColors.accentAmberDeep;
  Color get greenText =>
      isDarkMode ? AppColors.accentGreenLight : AppColors.accentGreenDeep;
  Color get skyText =>
      isDarkMode ? AppColors.accentSkySoft : AppColors.accentSkyDeep;
  Color get indigoText =>
      isDarkMode ? AppColors.accentIndigoSoft : AppColors.accentIndigoDeepText;
  Color get violetText =>
      isDarkMode ? AppColors.accentVioletLight : AppColors.accentVioletDeep;
  Color get roseText =>
      isDarkMode ? AppColors.accentRoseLight : AppColors.accentRoseDeep;
  Color get cyanText =>
      isDarkMode ? AppColors.accentCyanLight : AppColors.accentCyanDeep;

  /// Returns [color] in dark mode, or its accessible high-contrast counterpart in light mode.
  Color adaptiveAccentText(Color color) =>
      isDarkMode ? color : AppColors.toAccessibleLightText(color);
}
