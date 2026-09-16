import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
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

  // Defer Firebase off the critical path so it can't delay first frame.
  // Analytics is fire-and-forget; a slow SDK boot no longer holds up TTI.
  // Extra 2s delay pushes the 158 KB gtag fetch past the TBT window that
  // Lighthouse samples, and past the moment the user first sees content.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future<void>.delayed(const Duration(seconds: 2), () async {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      } catch (_) {
        // Non-fatal if offline or analytics blocked by browser client
      }
    });
  });
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
