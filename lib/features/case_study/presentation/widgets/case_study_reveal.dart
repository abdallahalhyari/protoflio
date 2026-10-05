import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:profile/core/theme/tokens.dart';

/// Scrolls the case study until the section under [key] is on screen.
///
/// The article is a lazy list, so a chapter far from the reading position
/// has no element yet and `Scrollable.ensureVisible` alone has nothing to
/// scroll to (the chapter dock's "Outcomes" did nothing from the top).
/// This sweeps toward it a screen and a half at a time, downward first,
/// until it is built, then settles on it.
Future<void> revealCaseStudySection(
  ScrollController controller,
  GlobalKey key, {
  bool reduceMotion = false,
}) async {
  Future<bool> sweep({required bool down}) async {
    while (key.currentContext == null && controller.hasClients) {
      final position = controller.position;
      final step = position.viewportDimension * 1.5;
      final target = down
          ? math.min(position.pixels + step, position.maxScrollExtent)
          : math.max(position.pixels - step, position.minScrollExtent);
      if (target == position.pixels) return false;
      if (reduceMotion) {
        controller.jumpTo(target);
        await WidgetsBinding.instance.endOfFrame;
      } else {
        await controller.animateTo(target,
            duration: AppMotion.micro, curve: Curves.linear);
      }
    }
    return key.currentContext != null;
  }

  if (key.currentContext == null && !await sweep(down: true)) {
    await sweep(down: false);
  }
  final context = key.currentContext;
  if (context == null || !context.mounted) return;
  await Scrollable.ensureVisible(
    context,
    duration: reduceMotion ? Duration.zero : AppMotion.sectionScroll,
    curve: AppMotion.easeInOutCubic,
    alignment: 0.08,
  );
}
