import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:profile/theme/tokens.dart';

/// Vertical space (px) the floating desktop TopNav pill occupies from
/// the top edge of the viewport: SafeArea top + margin (smd) + pill
/// height (~44px) + shadow slop. Screens that live under the nav must
/// reserve this much extra top padding on desktop so their headings /
/// content don't render behind the pill.
const double kTopNavReserve = 64;

/// Space (px) the floating MobileNav pill occupies at the bottom on
/// narrow viewports: bottom:16 offset + pill (~48) + safe area slop.
/// Screens reserve this much bottom padding on narrow viewports so
/// trailing content doesn't render behind the pill.
const double kBottomNavReserve = 80;

/// Space (px) the floating global icon cluster occupies at the top on
/// narrow viewports. Screens reserve this much top padding so mastheads
/// don't collide with the globe/theme toggles.
const double kMobileTopReserve = 64;

/// Distance from the viewport's right edge kept clear on desktop for the
/// vertical page-indicator dots (pinned 12px in, ~20px wide).
const double kSideRailReserve = 48;

/// Shared screen shell: SafeArea + centered content column + capped
/// max-width + top-nav reserve. (backdrop system removed).
class AppScreenShell extends StatelessWidget {
  const AppScreenShell({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
    this.verticalPadding = AppSpacing.lg,
    this.hPad,
    this.safeArea = true,
    this.reserveTopNav = true,
    this.reserveBottomNav = true,
    this.reserveMobileTop = true,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;
  final double verticalPadding;
  final double? hPad;
  final bool safeArea;

  /// Add `kTopNavReserve` to the top padding on viewports wide enough
  /// for the floating TopNav pill to render (>= `AppBreakpoints.tablet`,
  /// which matches the width at which `HomeScreen` mounts the pill).
  /// Turn off for pages that fully own the viewport (e.g. splash / hero
  /// wordmarks that intentionally sit under the nav).
  final bool reserveTopNav;
  final bool reserveBottomNav;
  final bool reserveMobileTop;

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= AppBreakpoints.desktopWide) return 48;
    if (width >= AppBreakpoints.desktop) return 32;
    if (width >= AppBreakpoints.mobile) return 24;
    if (width < 360) {
      return 12; // Extra breathability for compact displays (e.g. 320px iPhone SE)
    }
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= AppBreakpoints.tablet;
    final topExtra = wide
        ? (reserveTopNav ? kTopNavReserve : 0.0)
        : (reserveMobileTop ? kMobileTopReserve : 0.0);
    final mobileBottomExtra =
        (!wide && reserveBottomNav) ? kBottomNavReserve : 0.0;

    // On desktop the content must not run under the page-indicator dots.
    // Whatever of [kSideRailReserve] the centred max-width box doesn't
    // already leave free becomes padding (on both sides, to stay centred).
    var side = hPad ?? horizontalPadding(context);
    if (wide) {
      final freeEachSide = math.max(0.0, (width - maxWidth) / 2);
      side = math.max(side, kSideRailReserve - freeEachSide);
    }
    final shellPadding = padding ??
        EdgeInsets.fromLTRB(
          side,
          verticalPadding + topExtra,
          side,
          verticalPadding + mobileBottomExtra,
        );

    Widget content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: shellPadding,
          child: child,
        ),
      ),
    );

    if (safeArea) content = SafeArea(child: content);
    return Semantics(
      container: true,
      child: content,
    );
  }
}
