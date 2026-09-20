import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/mobile_pager.dart';
import 'package:profile/theme/app_theme.dart';

class _Recorder {
  final List<int> jumps = [];
}

HomeController _stub({
  required ValueNotifier<int> pageIndex,
  required _Recorder recorder,
}) {
  return HomeController(
    pageIndex: pageIndex,
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int _, {bool syncUrl = true}) {},
    next: () {},
    prev: () {},
    scrollToMobileSection: (int i, {bool syncUrl = true}) =>
        recorder.jumps.add(i),
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
    final r = _Recorder();
    final pageIndex = ValueNotifier<int>(2);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex, recorder: r)));
    await tester.pumpAndSettle();
    expect(find.text('03 / 07'), findsOneWidget);
  });

  testWidgets('MobilePager next-tap invokes scrollToMobileSection(page + 1)',
      (tester) async {
    final r = _Recorder();
    final pageIndex = ValueNotifier<int>(2);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex, recorder: r)));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Next section'));
    await tester.pump();
    expect(r.jumps, [3]);
  });

  testWidgets('MobilePager prev is disabled on the first section',
      (tester) async {
    final r = _Recorder();
    final pageIndex = ValueNotifier<int>(0);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex, recorder: r)));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Previous section'));
    await tester.pump();
    // Disabled — onTap is null, controller receives no jump.
    expect(r.jumps, isEmpty);
  });

  testWidgets('MobilePager next is disabled on the last section',
      (tester) async {
    final r = _Recorder();
    final pageIndex = ValueNotifier<int>(6);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex, recorder: r)));
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('Next section'));
    await tester.pump();
    expect(r.jumps, isEmpty);
  });
}
