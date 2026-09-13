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

  // Initialize Firebase asynchronously
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  } catch (_) {
    // Non-fatal if offline or analytics blocked by browser client
  }


  runApp(const PortfolioApp());
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
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleController.locale,
      builder: (context, locale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.mode,
          builder: (context, mode, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              scrollBehavior: const _SmoothScrollBehavior(),
              title: 'Abdallah Alhyari — Senior Flutter & Android Engineer',
              themeMode: mode,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
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
    );
  }
}
