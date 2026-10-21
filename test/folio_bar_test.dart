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
    pageCount: 6,
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
  testWidgets('FolioBar says only where you go next', (tester) async {
    final pageIndex = ValueNotifier<int>(0);
    await tester.pumpWidget(_host(pageIndex));
    await tester.pumpAndSettle();

    expect(find.text('Next: Work'), findsOneWidget);
    // The top nav says where you are; no counter or label here.
    expect(find.textContaining(' of '), findsNothing);
    expect(find.text('Home'), findsNothing);

    pageIndex.value = 2;
    await tester.pumpAndSettle();
    expect(find.text('Next: Skills'), findsOneWidget);
  });

  testWidgets('FolioBar "Next" goes to the following section', (tester) async {
    int? went;
    await tester
        .pumpWidget(_host(ValueNotifier<int>(1), onGoTo: (p) => went = p));
    await tester.pumpAndSettle();
    expect(find.text('Next: Experience'), findsOneWidget);
    await tester.tap(find.text('Next: Experience'));
    expect(went, 2);
  });

  testWidgets('FolioBar offers the way back to the start on the last page',
      (tester) async {
    int? went;
    await tester
        .pumpWidget(_host(ValueNotifier<int>(5), onGoTo: (p) => went = p));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back to start'));
    expect(went, 0);
  });
}
