import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/widgets/keyboard_focus_ring.dart';

Widget _app() => MaterialApp(
      builder: (context, child) => KeyboardFocusRing(child: child!),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(onPressed: () {}, child: const Text('First')),
              TextButton(onPressed: () {}, child: const Text('Second')),
            ],
          ),
        ),
      ),
    );

Rect? _ringRect(WidgetTester tester) {
  final paint = tester.widget<CustomPaint>(find.byWidgetPredicate(
      (w) => w is CustomPaint && w.painter is FocusRingPainter));
  return (paint.painter! as FocusRingPainter).rect;
}

void main() {
  testWidgets('draws a ring around the control focused with Tab',
      (tester) async {
    await tester.pumpWidget(_app());
    expect(_ringRect(tester), isNull);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.pump();

    final ring = _ringRect(tester);
    expect(ring, isNotNull);
    final first = tester.getRect(find.widgetWithText(TextButton, 'First'));
    expect(ring!.overlaps(first), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.pump();
    final second = tester.getRect(find.widgetWithText(TextButton, 'Second'));
    expect(_ringRect(tester)!.center.dy, closeTo(second.center.dy, 1));
  });

  testWidgets('no ring for pointer (touch / mouse) focus', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('First'));
    await tester.pump();
    await tester.pump();
    expect(_ringRect(tester), isNull);
  });
}
