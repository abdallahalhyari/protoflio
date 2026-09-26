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

  testWidgets(
      'horizontal rows inside a section do not inherit the page scroll '
      'offset', (tester) async {
    // Regression: unkeyed scrollables under the mobile ListView shared its
    // PageStorage slot, so a row built mid-page restored the vertical
    // offset and opened scrolled to its far end.
    final page = ScrollController();
    final row = ScrollController();
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      // The app gets its bucket from the route; provide one directly.
      child: PageStorage(
        bucket: PageStorageBucket(),
        child: ListView(
          key: const PageStorageKey<String>('page'),
          controller: page,
          children: [
            // Far enough down that the section isn't built on first frame.
            const SizedBox(height: 5000),
            DeferredMount(
              sectionIndex: 2,
              placeholderHeight: 50,
              child: SingleChildScrollView(
                controller: row,
                scrollDirection: Axis.horizontal,
                child: const SizedBox(width: 3000, height: 50),
              ),
            ),
            const SizedBox(height: 2000),
          ],
        ),
      ),
    ));
    expect(row.hasClients, isFalse);

    // Scrolling saves the page offset to PageStorage; the row is then
    // built for the first time and restores from PageStorage.
    page.jumpTo(4800);
    await tester.pump();

    expect(row.offset, 0.0);
  });
}
