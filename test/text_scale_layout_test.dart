import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/main.dart';

/// Renders the whole app at a given viewport and OS text scale, visits every
/// section, and returns the layout errors (overflows) reported on the way.
Future<List<String>> _layoutErrors(
    WidgetTester tester, Size size, double textScale) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final location =
        RegExp(r'lib/[\w/]+\.dart:\d+').firstMatch(details.toString());
    errors.add('${details.exceptionAsString().split('\n').first} '
        '@ ${location?.group(0) ?? '?'}');
  };
  addTearDown(() => FlutterError.onError = previous);

  await tester.pumpWidget(const PortfolioApp());
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
  if (size.width >= 900) {
    for (final key in [
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
    ]) {
      await tester.sendKeyEvent(key);
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }
  } else {
    for (int i = 0; i < 60; i++) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }
  FlutterError.onError = previous;
  return errors.toSet().toList();
}

void main() {
  // WCAG 1.4.4: text must stay usable up to 200%. Before this guard the
  // project grid, contact card, hat cards and the mobile app bar all
  // overflowed — the app bar even at 1x on a 390px phone.
  const sizes = {
    'phone 360': Size(360, 740),
    'phone 390': Size(390, 844),
    'tablet 820': Size(820, 1180),
    'desktop 1440': Size(1440, 900),
  };
  for (final scale in [1.0, 2.0]) {
    for (final entry in sizes.entries) {
      testWidgets('no layout overflow — ${entry.key} @ ${scale}x text',
          (tester) async {
        expect(await _layoutErrors(tester, entry.value, scale), isEmpty);
      });
    }
  }
}
