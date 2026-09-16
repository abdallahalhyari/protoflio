import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:profile/module/home/home_screen.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme_controller.dart';
import 'package:profile/locale_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profile/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.load();
  await LocaleController.load();

  runApp(const PortfolioApp());

  // Analytics: `web/index.html` sets up `window.gtag` synchronously and
  // lazy-loads `gtag.js` on first user interaction. No Dart-side init is
  // needed — Analytics.event/screen forward directly to gtag via
  // dart:js_interop.
}

/// Global scroll behavior:
/// - Enables drag scrolling from every input device (touch, mouse,
///   trackpad, stylus, pen) — Flutter's default drops mouse on desktop.
/// - Uses `BouncingScrollPhysics` universally so momentum & rubber-band
///   feel identical across desktop / web / mobile.
class _SmoothScrollBehavior extends MaterialScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      decelerationRate: ScrollDecelerationRate.fast,
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Merge locale/mode/seed into one Listenable — MaterialApp rebuilds
    // once per change instead of nesting three builders (each rebuild
    // reallocated both light + dark ThemeData).
    final merged = Listenable.merge([
      LocaleController.locale,
      ThemeController.mode,
      ThemeController.seedColor,
    ]);
    return ListenableBuilder(
      listenable: merged,
      builder: (context, _) {
        final locale = LocaleController.locale.value;
        final mode = ThemeController.mode.value;
        final seedColor = ThemeController.seedColor.value;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scrollBehavior: const _SmoothScrollBehavior(),
          title: 'Abdallah Alhyari — Senior Flutter & Android Engineer',
          themeMode: mode,
          theme: AppTheme.light(seedColor),
          darkTheme: AppTheme.dark(seedColor),
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('cs'),
          ],
          home: const HomeScreen(),
        );
      },
    );
  }
}
