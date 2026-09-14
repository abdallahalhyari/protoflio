import 'package:flutter/material.dart';
import 'package:profile/module/home/widget/screen_shell.dart';
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
    return AppScreenShell(
      maxWidth: maxWidth,
      verticalPadding: isContinuousMobile ? AppSpacing.md : AppSpacing.lg,
      reserveBottomNav: !isContinuousMobile,
      reserveMobileTop: !isContinuousMobile,
      child: isContinuousMobile
          ? child
          : SingleChildScrollView(
              primary: false,
              physics: const ClampingScrollPhysics(),
              child: child,
            ),
    );
  }
}
