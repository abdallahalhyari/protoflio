import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/shell/presentation/widgets/deferred_page.dart';

void main() {
  testWidgets('mounts one page per frame, nearest first', (tester) async {
    await tester.pumpWidget(const SizedBox());
    final order = <String>[];
    void far() => order.add('far');
    void near() => order.add('near');
    void mid() => order.add('mid');
    void gone() => order.add('gone');

    // All become ready in the same burst, farthest first.
    StaggeredMount.request(5, far);
    StaggeredMount.request(3, gone);
    StaggeredMount.request(0, near);
    StaggeredMount.request(2, mid);
    StaggeredMount.cancel(gone); // e.g. the page was disposed

    expect(order, isEmpty, reason: 'waits for the current frame to end');
    await tester.pump();
    expect(order, ['near']);
    await tester.pump();
    expect(order, ['near', 'mid']);
    await tester.pump();
    expect(order, ['near', 'mid', 'far']);
    await tester.pump();
    expect(order, ['near', 'mid', 'far']);
  });

  testWidgets('DeferredPage with a priority still ends up showing content',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: DeferredPage(
        loader: () async {},
        mountPriority: 1,
        builder: () => const Text('content'),
      ),
    ));
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
    expect(find.text('content'), findsOneWidget);
  });
}
