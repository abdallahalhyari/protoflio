import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/widget/desktop_toolbar.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme_controller.dart';

Widget _host(ThemeMode mode) {
  return MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: mode,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const Scaffold(body: Center(child: DesktopToolbar())),
  );
}

void main() {
  testWidgets('DesktopToolbar shows dark-mode icon under dark theme',
      (tester) async {
    ThemeController.mode.value = ThemeMode.dark;
    await tester.pumpWidget(_host(ThemeMode.dark));
    await tester.pumpAndSettle();
    // Under dark theme, the toggle presents the "switch to light" affordance.
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });

  testWidgets('DesktopToolbar shows light-mode icon under light theme',
      (tester) async {
    ThemeController.mode.value = ThemeMode.light;
    await tester.pumpWidget(_host(ThemeMode.light));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
  });

  testWidgets('DesktopToolbar theme toggle flips ThemeController.mode',
      (tester) async {
    ThemeController.mode.value = ThemeMode.dark;
    await tester.pumpWidget(_host(ThemeMode.dark));
    await tester.pumpAndSettle();

    final before = ThemeController.mode.value;
    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pump();
    expect(ThemeController.mode.value, isNot(before));
  });

  testWidgets('DesktopToolbar audio icon flips with SoundService.isEnabled',
      (tester) async {
    SoundService.instance.isEnabled.value = true;
    ThemeController.mode.value = ThemeMode.dark;
    await tester.pumpWidget(_host(ThemeMode.dark));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.volume_up), findsOneWidget);
    SoundService.instance.isEnabled.value = false;
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.volume_off), findsOneWidget);
  });
}
