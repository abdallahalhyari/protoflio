import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_event.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_event.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/features/shell/home_screen.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/service/sound_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final themeStr = prefs.getString('themeMode');
  ThemeMode initTheme = ThemeMode.dark;
  if (themeStr == 'light') initTheme = ThemeMode.light;
  if (themeStr == 'system') initTheme = ThemeMode.system;

  final localeStr = prefs.getString('localeCode');
  final Locale initLocale =
      localeStr != null ? Locale(localeStr) : const Locale('en');

  await Future.wait([
    SoundService.instance.load(),
  ]);

  runApp(PortfolioApp(
    initialTheme: initTheme,
    initialLocale: initLocale,
  ));

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
      decelerationRate: ScrollDecelerationRate.normal,
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({
    super.key,
    this.initialTheme = ThemeMode.dark,
    this.initialLocale = const Locale('en'),
  });

  final ThemeMode initialTheme;
  final Locale initialLocale;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) =>
              ThemeBloc(initialMode: initialTheme)..add(const ThemeStarted()),
        ),
        BlocProvider<LocaleBloc>(
          create: (_) => LocaleBloc(initialLocale: initialLocale)
            ..add(const LocaleStarted()),
        ),
      ],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            buildWhen: (previous, current) => previous.mode != current.mode,
            builder: (context, themeState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                scrollBehavior: const _SmoothScrollBehavior(),
                title: 'Abdallah Alhyari — Senior Flutter & Android Engineer',
                themeMode: themeState.mode,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                locale: localeState.locale,
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
                builder: (context, child) {
                  final media = MediaQuery.of(context);
                  return MediaQuery(
                    data: media.copyWith(
                      textScaler: media.textScaler.clamp(
                        minScaleFactor: 0.85,
                        maxScaleFactor: 1.35,
                      ),
                    ),
                    child: child!,
                  );
                },
                home: const _AccentTheme(child: HomeScreen()),
              );
            },
          );
        },
      ),
    );
  }
}

/// Applies the live section-accent color as an `AnimatedTheme` override
/// on top of the base MaterialApp theme. Only this subtree rebuilds on
/// seed change, and the color transition is lerped over 260ms — no
/// visible refresh flash on section navigation.
///
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

  Widget _buildThemed(BuildContext context, Color seed, Widget staticChild) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final base = Theme.of(context);
    final onPrimary = base.brightness == Brightness.dark
        ? Colors.white
        : base.colorScheme.onPrimary;

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
      child: staticChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (prev, curr) => prev.seedColor != curr.seedColor,
      builder: (context, state) =>
          _buildThemed(context, state.seedColor, child),
    );
  }
}
