import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/home_controller.dart';
import 'package:profile/module/home/widget/portfolio_nav.dart';
import 'package:profile/theme/app_theme.dart';

HomeController _stub({
  ValueNotifier<int>? pageIndex,
  int Function()? onGoTo,
  Future<void> Function()? onResume,
}) {
  return HomeController(
    pageIndex: pageIndex ?? ValueNotifier<int>(0),
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int page, {bool syncUrl = true}) {
      onGoTo?.call();
    },
    next: () {},
    prev: () {},
    scrollToMobileSection: (int _, {bool syncUrl = true}) {},
    downloadResume: onResume ?? () async {},
  );
}

Widget _wrap(Widget child, HomeController controller) {
  return MaterialApp(
    theme: AppTheme.dark(),
    themeMode: ThemeMode.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: HomeControllerScope(
      controller: controller,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('TopNav highlights label matching controller.pageIndex',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final pageIndex = ValueNotifier<int>(3);
    await tester.pumpWidget(_wrap(const TopNav(), _stub(pageIndex: pageIndex)));
    await tester.pumpAndSettle();

    // NavItem for the fourth label (index 3) is the selected Semantics node.
    final selected = find.byWidgetPredicate((w) => w is NavItem && w.active);
    expect(selected, findsOneWidget);
  });

  testWidgets('TopNav goTo is invoked on nav item tap', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    var tapped = 0;
    await tester.pumpWidget(_wrap(
      const TopNav(),
      _stub(onGoTo: () {
        tapped++;
        return 0;
      }),
    ));
    await tester.pumpAndSettle();

    final items = find.byType(NavItem);
    expect(items, findsWidgets);
    await tester.tap(items.first);
    await tester.pump();
    expect(tapped, greaterThan(0));
  });

  testWidgets('PageIndicator dot count matches controller.pageCount',
      (tester) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_wrap(const PageIndicator(), _stub()));
    await tester.pumpAndSettle();

    // 7 InkResponses (one per section dot).
    final dots = find.byType(InkResponse);
    expect(dots, findsNWidgets(7));
  });
}
