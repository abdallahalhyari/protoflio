import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile/features/shell/home_controller.dart';

HomeController _stub() => HomeController(
      pageIndex: ValueNotifier<int>(0),
      showScrollToTop: ValueNotifier<bool>(false),
      pageCount: 7,
      goTo: (int _, {bool syncUrl = true}) {},
      next: () {},
      prev: () {},
      scrollToMobileSection: (int _, {bool syncUrl = true}) {},
      downloadResume: () async {},
    );

void main() {
  group('HomeController lookup', () {
    testWidgets('of() returns the ambient controller', (tester) async {
      final controller = _stub();
      late HomeController resolved;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: HomeControllerScope(
            controller: controller,
            child: Builder(
              builder: (context) {
                resolved = HomeController.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(resolved, same(controller));
    });

    testWidgets('maybeOf returns null outside a scope', (tester) async {
      HomeController? resolved;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              resolved = HomeController.maybeOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(resolved, isNull);
    });

    testWidgets('scope publishes the current controller identity',
        (tester) async {
      final a = _stub();
      final b = _stub();
      final resolved = <HomeController>[];

      Widget scopedWith(HomeController c) => Directionality(
            textDirection: TextDirection.ltr,
            child: HomeControllerScope(
              controller: c,
              child: Builder(
                builder: (context) {
                  resolved.add(HomeController.of(context));
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

      await tester.pumpWidget(scopedWith(a));
      await tester.pumpWidget(scopedWith(b));
      expect(resolved.first, same(a));
      expect(resolved.last, same(b));
    });
  });
}
