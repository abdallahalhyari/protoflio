import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/mobile_pager.dart';
import 'package:profile/theme/app_theme.dart';

HomeController _stub({
  required ValueNotifier<int> pageIndex,
  void Function(int index)? onScrollToMobileSection,
}) {
  return HomeController(
    pageIndex: pageIndex,
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int _, {bool syncUrl = true}) {},
    next: () {},
    prev: () {},
    scrollToMobileSection: (int i, {bool syncUrl = true}) {
      onScrollToMobileSection?.call(i);
    },
    downloadResume: () async {},
  );
}

Widget _host(HomeController controller) {
  return MaterialApp(
    theme: AppTheme.dark(),
    themeMode: ThemeMode.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: HomeControllerScope(
      controller: controller,
      child: const Scaffold(body: Center(child: MobilePager())),
    ),
  );
}

void main() {
  testWidgets('MobilePager renders "0N / 07" counter for current page',
      (tester) async {
    final pageIndex = ValueNotifier<int>(2);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex)));
    await tester.pumpAndSettle();
    expect(find.text('03 / 07'), findsOneWidget);
  });

  testWidgets('MobilePager next-tap calls scrollToMobileSection',
      (tester) async {
    final pageIndex = ValueNotifier<int>(2);
    int? scrolledTo;
    await tester.pumpWidget(_host(_stub(
      pageIndex: pageIndex,
      onScrollToMobileSection: (i) => scrolledTo = i,
    )));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Next section'));
    await tester.pumpAndSettle();

    expect(scrolledTo, 3);
  });

  testWidgets('MobilePager prev is disabled on the first section',
      (tester) async {
    final pageIndex = ValueNotifier<int>(0);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex)));
    await tester.pumpAndSettle();

    final prevButton = find.byTooltip('Previous section');
    expect(prevButton, findsOneWidget);
    expect(pageIndex.value, 0);
  });

  testWidgets('MobilePager next is disabled on the last section',
      (tester) async {
    final pageIndex = ValueNotifier<int>(6);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex)));
    await tester.pumpAndSettle();

    final nextButton = find.byTooltip('Next section');
    expect(nextButton, findsOneWidget);
    expect(pageIndex.value, 6);
  });
}
