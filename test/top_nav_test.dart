import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/portfolio_nav.dart';
import 'package:profile/theme/app_theme.dart';

HomeController _stub({
  ValueNotifier<int>? pageIndex,
  void Function(int page)? onGoTo,
  Future<void> Function()? onResume,
}) {
  return HomeController(
    pageIndex: pageIndex ?? ValueNotifier<int>(0),
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int page, {bool syncUrl = true}) {
      onGoTo?.call(page);
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

  testWidgets('TopNav goTo is invoked on non-active nav item tap',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    int? goToArg;
    // Start on section 0 so tapping the last NavItem is not a no-op.
    await tester.pumpWidget(_wrap(
      const TopNav(),
      _stub(
        pageIndex: ValueNotifier<int>(0),
        onGoTo: (page) => goToArg = page,
      ),
    ));
    await tester.pumpAndSettle();

    final items = find.byType(NavItem);
    expect(items, findsWidgets);

    // Tap a non-active NavItem (index != 0) — should call HomeController.goTo.
    // The links scroll horizontally beside the pinned Resume button, so
    // bring the last one into view first, as a user would.
    await tester.ensureVisible(items.last);
    await tester.pumpAndSettle();
    await tester.tap(items.last);
    await tester.pumpAndSettle();
    expect(goToArg, 6);
  });

  testWidgets('TopNav swallows tap on the already-active nav item',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    int? goToArg;
    await tester.pumpWidget(_wrap(
      const TopNav(),
      _stub(
        pageIndex: ValueNotifier<int>(0),
        onGoTo: (page) => goToArg = page,
      ),
    ));
    await tester.pumpAndSettle();

    // items.first == active section 0 — guard should prevent goTo call.
    await tester.tap(find.byType(NavItem).first);
    await tester.pumpAndSettle();
    expect(goToArg, isNull);
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
