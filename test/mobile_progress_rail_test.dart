import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/bloc/navigation/navigation_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/mobile_progress_rail.dart';
import 'package:profile/theme/app_theme.dart';

HomeController _stub({
  required ValueNotifier<int> pageIndex,
}) {
  return HomeController(
    pageIndex: pageIndex,
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int _, {bool syncUrl = true}) {},
    next: () {},
    prev: () {},
    scrollToMobileSection: (int i, {bool syncUrl = true}) {},
    downloadResume: () async {},
  );
}

Widget _host(HomeController controller) {
  return MaterialApp(
    theme: AppTheme.dark(),
    themeMode: ThemeMode.dark,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider<NavigationBloc>(
      create: (_) => NavigationBloc(
        initialPage: controller.pageIndex.value,
        pageCount: controller.pageCount,
      ),
      child: HomeControllerScope(
        controller: controller,
        child: const Scaffold(body: Center(child: MobileProgressRail())),
      ),
    ),
  );
}

void main() {
  testWidgets('MobileProgressRail renders one InkResponse per section',
      (tester) async {
    final pageIndex = ValueNotifier<int>(0);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex)));
    await tester.pumpAndSettle();
    expect(find.byType(InkResponse), findsNWidgets(7));
  });

  testWidgets('MobileProgressRail dot tap updates pageIndex in NavigationBloc',
      (tester) async {
    final pageIndex = ValueNotifier<int>(0);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex)));
    await tester.pumpAndSettle();

    // Tap the fourth dot (index 3).
    await tester.tap(find.byType(InkResponse).at(3));
    await tester.pumpAndSettle();

    final bloc =
        tester.element(find.byType(MobileProgressRail)).read<NavigationBloc>();
    expect(bloc.state.pageIndex, 3);
  });

  testWidgets('MobileProgressRail swallows tap on the active dot',
      (tester) async {
    final pageIndex = ValueNotifier<int>(2);
    await tester.pumpWidget(_host(_stub(pageIndex: pageIndex)));
    await tester.pumpAndSettle();

    final bloc =
        tester.element(find.byType(MobileProgressRail)).read<NavigationBloc>();
    expect(bloc.state.pageIndex, 2);

    // Third dot (index 2) is the active one — onTap is null, tap is a no-op.
    await tester.tap(find.byType(InkResponse).at(2), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(bloc.state.pageIndex, 2);
  });
}
