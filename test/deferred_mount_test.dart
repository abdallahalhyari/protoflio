import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/deferred_mount.dart';

Widget _wrap({
  required ValueNotifier<int> pageIndex,
  required Widget child,
}) {
  final controller = HomeController(
    pageIndex: pageIndex,
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int _, {bool syncUrl = true}) {},
    next: () {},
    prev: () {},
    scrollToMobileSection: (int _, {bool syncUrl = true}) {},
    downloadResume: () async {},
  );
  return Directionality(
    textDirection: TextDirection.ltr,
    child: HomeControllerScope(controller: controller, child: child),
  );
}

void main() {
  testWidgets('renders placeholder when page is far from section',
      (tester) async {
    await tester.pumpWidget(_wrap(
      pageIndex: ValueNotifier<int>(0),
      child: const DeferredMount(
        sectionIndex: 5,
        placeholderHeight: 720,
        child: Text('mounted'),
      ),
    ));
    expect(find.text('mounted'), findsNothing);
  });

  testWidgets('mounts child when page is within distance', (tester) async {
    await tester.pumpWidget(_wrap(
      pageIndex: ValueNotifier<int>(4),
      child: const DeferredMount(
        sectionIndex: 5,
        placeholderHeight: 720,
        child: Text('mounted'),
      ),
    ));
    expect(find.text('mounted'), findsOneWidget);
  });

  testWidgets('mounts eagerly when rendered outside a HomeControllerScope',
      (tester) async {
    // No HomeControllerScope wraps the child — DeferredMount should
    // fall back to mounting immediately rather than freezing on the
    // placeholder.
    await tester.pumpWidget(const Directionality(
      textDirection: TextDirection.ltr,
      child: DeferredMount(
        sectionIndex: 5,
        placeholderHeight: 720,
        child: Text('mounted'),
      ),
    ));
    expect(find.text('mounted'), findsOneWidget);
  });

  testWidgets('mounts on notifier change without unmounting again',
      (tester) async {
    final pageIndex = ValueNotifier<int>(0);
    await tester.pumpWidget(_wrap(
      pageIndex: pageIndex,
      child: const DeferredMount(
        sectionIndex: 3,
        placeholderHeight: 720,
        child: Text('mounted'),
      ),
    ));
    expect(find.text('mounted'), findsNothing);

    pageIndex.value = 2; // within distance 1
    await tester.pumpAndSettle();
    expect(find.text('mounted'), findsOneWidget);

    // Move far away — must stay mounted (sticky).
    pageIndex.value = 0;
    await tester.pumpAndSettle();
    expect(find.text('mounted'), findsOneWidget);
  });
}
