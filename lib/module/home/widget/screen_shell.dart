import 'package:flutter/material.dart';

import '../../../theme/tokens.dart';

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
    if (width >= 1440) return 48;
    if (width >= 1024) return 32;
    if (width >= 600) return 24;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final wide = width >= AppBreakpoints.tablet;
    final topExtra = wide ? (reserveTopNav ? kTopNavReserve : 0.0) : kMobileTopReserve;
    final mobileTopExtra = (!wide && reserveMobileTop) ? kMobileTopReserve : 0.0;
    final mobileBottomExtra = (!wide && reserveBottomNav) ? kBottomNavReserve : 0.0;

    final shellPadding = padding ??
        EdgeInsets.fromLTRB(
          hPad ?? horizontalPadding(context),
          verticalPadding + topExtra + mobileTopExtra,
          hPad ?? horizontalPadding(context),
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
    return content;
  }
}
