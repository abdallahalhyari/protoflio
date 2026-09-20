import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_screen.dart';

Widget _wrap() {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const HomeScreen(),
  );
}

/// Extracts the current 1-based page index from the FOLIO folio bar,
/// e.g. "FOLIO 03 / 07" → 3. Returns null if not visible yet.
int? _folioIndex(WidgetTester tester) {
  for (final w in tester.widgetList<Text>(find.byType(Text))) {
    final s = w.data ?? '';
    final m = RegExp(r'^FOLIO (\d+) / \d+$').firstMatch(s);
    if (m != null) return int.parse(m.group(1)!);
  }
  return null;
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
    expect(_folioIndex(tester), 7);

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(_folioIndex(tester), 1);

    // tearDown registered above resets view state
  });

  testWidgets('desktop digit-5 key jumps to Skills (page 5)', (tester) async {
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
