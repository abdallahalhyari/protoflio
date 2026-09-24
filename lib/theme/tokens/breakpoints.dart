import 'package:flutter/material.dart';

/// Breakpoints for Responsive Layouts
class AppBreakpoints {
  AppBreakpoints._();

  /// Narrow smartphones and compact foldable front displays (< 460px)
  static const double compact = 460;

  /// Standard phone portrait boundary (< 600px)
  static const double mobile = 600;

  /// Primary architectural layout boundary (mobile continuous scroll vs desktop magazine mode)
  static const double tablet = 900;

  /// Standard desktop / tablet landscape entry (>= 1024px)
  static const double desktop = 1024;

  /// Large monitors and high-DPI laptops (>= 1440px)
  static const double desktopWide = 1440;

  /// 1440p / 4K / 5K ultrawide monitors (>= 1920px)
  static const double ultraWide = 1920;

  /// Whether the current screen is a compact phone (< 460px)
  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < compact;

  /// Whether the screen is mobile continuous scroll layout (< 900px)
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tablet;

  /// Whether the screen is a tablet between 900px and 1024px
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= tablet && w < desktop;
  }

  /// Whether the screen uses the desktop magazine presentation (>= 900px)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  /// Whether the screen is a wide desktop (>= 1440px)
  static bool isWideDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopWide;

  /// Whether the screen is an ultrawide or 4K display (>= 1920px)
  static bool isUltraWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= ultraWide;
}

/// Runtime-adaptive presentation helpers.
class AppMedia {
  AppMedia._();

  /// Whether the user has requested reduced motion / disabled animations
  /// via OS or browser accessibility settings.
  static bool reduceMotion(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
  }

  /// Whether to skip expensive backdrop blur (shader passes are the
  /// single biggest paint cost on web). Currently gated on the user's
  /// `Reduce Motion` accessibility flag — a proxy for "prefers cheaper
  /// visuals". Callers should fall back to a solid tinted surface.
  static bool reduceBlur(BuildContext context) {
    return reduceMotion(context);
  }

  /// App-wide bounds for the OS/browser text scale. The upper bound is 2.0
  /// to meet WCAG 1.4.4 (resize text to 200%); `text_scale_layout_test`
  /// guards every section against overflow at that size. Fixed-geometry
  /// pieces (hat cards, mobile app bar) cap locally instead.
  static const double minTextScale = 0.85;
  static const double maxTextScale = 2.0;

  static TextScaler clampTextScale(TextScaler scaler) => scaler.clamp(
        minScaleFactor: minTextScale,
        maxScaleFactor: maxTextScale,
      );
}
