import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/shell/presentation/widgets/folio_bar.dart';
import 'package:profile/core/theme/app_theme.dart';

Widget _host(ValueNotifier<int> pageIndex, {void Function(int)? onGoTo}) {
  final controller = HomeController(
    pageIndex: pageIndex,
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int page, {bool syncUrl = true}) => onGoTo?.call(page),
    next: () {},
    prev: () {},
    scrollToMobileSection: (int _, {bool syncUrl = true}) {},
    downloadResume: () async {},
  );
  return MaterialApp(
    theme: AppTheme.dark(),
    themeMode: ThemeMode.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: HomeControllerScope(
      controller: controller,
      child: const Scaffold(body: Center(child: FolioBar())),
    ),
  );
}

void main() {
  testWidgets('FolioBar renders "0N / 07" counter for current page',
      (tester) async {
    await tester.pumpWidget(_host(ValueNotifier<int>(2)));
    await tester.pumpAndSettle();
    // folioIndicator locale template renders "03 / 07" for pageIndex 2.
    expect(find.textContaining('03'), findsWidgets);
    expect(find.textContaining('07'), findsWidgets);
  });

  testWidgets('FolioBar updates label when pageIndex ticks', (tester) async {
    final pageIndex = ValueNotifier<int>(0);
    await tester.pumpWidget(_host(pageIndex));
    await tester.pumpAndSettle();

    // Grab the initial folio number.
    expect(find.textContaining('01'), findsWidgets);

    pageIndex.value = 5;
    await tester.pumpAndSettle();
    expect(find.textContaining('06'), findsWidgets);
  });

  testWidgets('FolioBar "Next" goes to the following section', (tester) async {
    int? went;
    await tester
        .pumpWidget(_host(ValueNotifier<int>(2), onGoTo: (p) => went = p));
    await tester.pumpAndSettle();
    expect(find.text('Next · Experience'), findsOneWidget);
    await tester.tap(find.text('Next · Experience'));
    expect(went, 3);
  });

  testWidgets('FolioBar offers the way back to the start on the last page',
      (tester) async {
    int? went;
    await tester
        .pumpWidget(_host(ValueNotifier<int>(6), onGoTo: (p) => went = p));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to start'));
    expect(went, 0);
  });
}
