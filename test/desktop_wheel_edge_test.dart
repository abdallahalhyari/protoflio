import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/shell/presentation/widgets/desktop_scroll_interceptor.dart';

/// A page with its own long scrolling content, inside the desktop wheel
/// interceptor. Counts page turns instead of performing them.
Widget _harness(PageController pages, void Function() onNext) {
  return MaterialApp(
    home: DesktopScrollInterceptor(
      onNext: onNext,
      onPrev: () {},
      isPageTransitioning: ValueNotifier<bool>(false),
      lastPageTurnCompletedAt:
          ValueNotifier<DateTime>(DateTime.fromMillisecondsSinceEpoch(0)),
      child: PageView(
        controller: pages,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListView(
            children: const [SizedBox(height: 1200)],
          ),
          const SizedBox.expand(),
        ],
      ),
    ),
  );
}

Future<void> _wheel(WidgetTester tester, double dy) async {
  await tester.sendEventToBinding(PointerScrollEvent(
    position: const Offset(400, 300),
    scrollDelta: Offset(0, dy),
  ));
  await tester.pump();
}

void main() {
  testWidgets(
      'wheel over a scroll area (even blank space in it) scrolls the '
      'content; momentum at its end rests; a fresh gesture turns the page',
      (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final pages = PageController();
    var turns = 0;
    await tester.pumpWidget(_harness(pages, () => turns++));

    // One continuous burst: scrolls the 1200px list (600px viewport) to its
    // end, then keeps going. The overshoot must not turn the page.
    for (var i = 0; i < 6; i++) {
      await _wheel(tester, 200);
    }
    expect(turns, 0);

    // The user pauses, then scrolls again: now the page turns.
    await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 350)));
    await _wheel(tester, 200);
    expect(turns, 1);
  });
}
