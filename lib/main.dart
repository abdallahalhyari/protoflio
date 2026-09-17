import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:profile/module/home/home_screen.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens.dart';
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
    // MaterialApp is rebuilt only for locale + mode changes — those
    // require a full theme reconstruction. The per-section accent
    // (seed) color is applied lower in the tree via `_AccentTheme` so
    // page navigation doesn't tear down + re-inherit the whole
    // widget subtree. AnimatedTheme inside `_AccentTheme` lerps the
    // primary color smoothly instead of snapping on every section.
    final shellListenable = Listenable.merge([
      LocaleController.locale,
      ThemeController.mode,
    ]);
    return ListenableBuilder(
      listenable: shellListenable,
      builder: (context, _) {
        final locale = LocaleController.locale.value;
        final mode = ThemeController.mode.value;
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
          builder: (context, child) =>
              _AccentTheme(child: child ?? const SizedBox.shrink()),
          home: const HomeScreen(),
        );
      },
    );
  }
}

/// Applies the live section-accent color as an `AnimatedTheme` override
/// on top of the base MaterialApp theme. Only this subtree rebuilds on
/// seed change, and the color transition is lerped over 260ms — no
/// visible refresh flash on section navigation.
///
/// The override propagates the seed to the full family of accent slots
/// (primary + secondary + tertiary + surfaceTint) so gradient-driven
/// widgets that read `secondary` also shift with the section.
/// Reduced-motion users get an instant snap instead of the lerp.
class _AccentTheme extends StatelessWidget {
  const _AccentTheme({required this.child});

  final Widget child;

  static Color _shift(Color c, double delta) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withHue((hsl.hue + delta) % 360)
        .withSaturation(hsl.saturation.clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return ValueListenableBuilder<Color>(
      valueListenable: ThemeController.seedColor,
      builder: (context, seed, staticChild) {
        final base = Theme.of(context);
        final onPrimary = base.brightness == Brightness.dark
            ? Colors.white
            : base.colorScheme.onPrimary;
        // Derive an analogous pair via hue shift so the secondary/tertiary
        // slots read as "family of the current section", not "leftover from
        // the base theme". Widgets that pull `secondary` for gradient
        // stops now animate in sync with `primary`.
        final scheme = base.colorScheme.copyWith(
          primary: seed,
          onPrimary: onPrimary,
          secondary: _shift(seed, 24),
          onSecondary: onPrimary,
          tertiary: _shift(seed, -24),
          onTertiary: onPrimary,
          surfaceTint: seed,
        );
        return AnimatedTheme(
          data: base.copyWith(colorScheme: scheme),
          duration: reduceMotion ? Duration.zero : AppMotion.heroEntry,
          curve: AppMotion.standard,
          child: staticChild!,
        );
      },
      child: child,
    );
  }
}
