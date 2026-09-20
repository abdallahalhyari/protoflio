import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/mobile_app_bar.dart';

HomeController _stub({ValueNotifier<int>? pageIndex}) {
  return HomeController(
    pageIndex: pageIndex ?? ValueNotifier<int>(0),
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int _, {bool syncUrl = true}) {},
    next: () {},
    prev: () {},
    scrollToMobileSection: (int _, {bool syncUrl = true}) {},
    downloadResume: () async {},
  );
}

Widget _host(Widget child, {HomeController? controller}) {
  return MaterialApp(
    theme: ThemeData(brightness: Brightness.dark),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SafeArea(
        child: controller == null
            ? child
            : HomeControllerScope(controller: controller, child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('renders AVAILABLE fallback outside a HomeControllerScope',
      (tester) async {
    await tester.pumpWidget(_host(MobileAppBar(onMenuPressed: () {})));
    expect(find.text('ABDALLAH'), findsOneWidget);
    expect(find.text('AVAILABLE'), findsOneWidget);
    expect(find.text('MENU'), findsOneWidget);
  });

  testWidgets('renders live section badge from controller.pageIndex',
      (tester) async {
    final pageIndex = ValueNotifier<int>(4);
    await tester.pumpWidget(_host(
      MobileAppBar(onMenuPressed: () {}),
      controller: _stub(pageIndex: pageIndex),
    ));
    await tester.pumpAndSettle();
    expect(find.text('AVAILABLE'), findsNothing);
    expect(find.text('05 / 07'), findsOneWidget);
  });

  testWidgets('menu callback fires', (tester) async {
    int hits = 0;
    await tester.pumpWidget(_host(MobileAppBar(onMenuPressed: () => hits++)));
    await tester.tap(find.text('MENU'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(hits, 1);
  });
}
