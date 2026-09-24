import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';

void main() {
  // Guards against whole-app rebuild storms during a page turn — e.g. an
  // `AnimatedTheme` accent lerp rebuilt every `Theme.of` dependent in every
  // kept-alive page on each frame (~70k element rebuilds vs ~7k today).
  testWidgets('a desktop page turn stays within its rebuild budget',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1400, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const PortfolioApp());
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // Visit every section so all pages are mounted and kept alive.
    for (final key in [
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit1,
    ]) {
      await tester.sendKeyEvent(key);
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    var rebuilds = 0;
    debugOnRebuildDirtyWidget = (_, __) => rebuilds++;
    addTearDown(() => debugOnRebuildDirtyWidget = null);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    for (int i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }
    debugOnRebuildDirtyWidget = null;

    expect(rebuilds, lessThan(20000));
  });
}
