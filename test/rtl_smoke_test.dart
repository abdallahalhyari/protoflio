import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/intro/page/intro_page.dart';

Widget _wrap(Widget child, Locale locale) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

/// Finds the resolved text direction anywhere in the widget subtree rooted
/// at [root]. Uses `Directionality.of` on the first BuildContext we can
/// grab from the located intro root.
TextDirection _dirFor(WidgetTester tester, Finder root) {
  final ctx = tester.element(root);
  return Directionality.of(ctx);
}

void main() {
  testWidgets('Arabic locale forces rtl on the intro subtree',
      (tester) async {
    // Use a moderate viewport so Intro's desktop wordmark path lays out
    // without hitting the height guard for the scroll hint.
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(
      IntroPage(onScrollDown: () {}),
      const Locale('ar'),
    ));
    for (int i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Localized Arabic label for MMXXVI issue strip (kept English) means we
    // still find the Latin wordmark. What we care about is Directionality.
    expect(_dirFor(tester, find.byType(IntroPage)), TextDirection.rtl);
    // No exceptions during layout.
    expect(tester.takeException(), isNull);
  });

  testWidgets('English locale renders ltr', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(
      IntroPage(onScrollDown: () {}),
      const Locale('en'),
    ));
    await tester.pump(const Duration(milliseconds: 200));
    expect(_dirFor(tester, find.byType(IntroPage)), TextDirection.ltr);
  });
}
