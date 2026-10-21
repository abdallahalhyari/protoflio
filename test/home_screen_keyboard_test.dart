import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/shell/presentation/widgets/folio_bar.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/presentation/pages/home_screen.dart';

Widget _wrap() {
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
      BlocProvider<LocaleBloc>(create: (_) => LocaleBloc()),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    ),
  );
}

/// The current 1-based page, as the folio counter used to show it.
int? _folioIndex(WidgetTester tester) {
  final bar = find.byType(FolioBar);
  if (bar.evaluate().isEmpty) return null;
  return HomeController.of(tester.element(bar)).pageIndex.value + 1;
}

void main() {
  testWidgets('desktop arrow-down advances to page 2', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1400, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap());
    // Multiple pumps to let PageController animation + FOLIO render settle.
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(_folioIndex(tester), 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(_folioIndex(tester), 2);

    // tearDown registered above resets view state
  });

  testWidgets('desktop End key jumps to last section', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1400, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap());
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(_folioIndex(tester), 6);

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(_folioIndex(tester), 1);

    // tearDown registered above resets view state
  });

  testWidgets('desktop digit-5 key jumps to Engineering (page 5)',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1400, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(_wrap());
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.sendKeyEvent(LogicalKeyboardKey.digit5);
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(_folioIndex(tester), 5);

    // tearDown registered above resets view state
  });
}
