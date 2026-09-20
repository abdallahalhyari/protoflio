import 'package:flutter/material.dart';
import 'package:profile/shared/widget/screen_shell.dart';
import 'package:profile/theme/tokens.dart';

class ScrollableAppScreenShell extends StatelessWidget {
  final Widget child;
  final bool isContinuousMobile;
  final double maxWidth;

  const ScrollableAppScreenShell({
    super.key,
    required this.child,
    this.isContinuousMobile = false,
    this.maxWidth = 1040,
  });

  @override
  Widget build(BuildContext context) {
    // The entire content is wrapped in a RepaintBoundary. This guarantees
    // 60fps scrolling on the web by converting the page into a single texture
    // and moving the texture during scroll, completely avoiding CanvasKit
    // re-rasterizing heavy shadows or gradients on every frame.
    final cachedChild = RepaintBoundary(child: child);

    return AppScreenShell(
      maxWidth: maxWidth,
      verticalPadding: isContinuousMobile ? AppSpacing.md : AppSpacing.lg,
      reserveBottomNav: !isContinuousMobile,
      reserveMobileTop: !isContinuousMobile,
      child: isContinuousMobile
          ? cachedChild
          : SingleChildScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: cachedChild,
            ),
    );
  }
}
