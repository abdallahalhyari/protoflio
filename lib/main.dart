import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:profile/app/bootstrap.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/locale/locale_state.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:profile/core/bloc/theme/theme_state.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/features/hats/domain/repositories/hat_repository.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/shell/presentation/pages/home_screen.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/widgets/keyboard_focus_ring.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/core/theme/tokens.dart';

Future<void> main() async {
  // UrlSyncService owns the URL hash (`#work`, `#work/<slug>`). Flutter's
  // default hash strategy fought it: it stripped the hash on load and
  // turned hash changes into `pushNamed` calls this app has no routes for
  // (null-check crash, then a jump to Home). No-op off the web.
  setUrlStrategy(null);
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    AppBootstrapper(
      builder: (data) => PortfolioApp(
        initialTheme: data.initialTheme,
        initialLocale: data.initialLocale,
        projectRepo: data.projectRepo,
        experienceRepo: data.experienceRepo,
        hatRepo: data.hatRepo,
        skillRepo: data.skillRepo,
      ),
    ),
  );

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
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({
    super.key,
    this.initialTheme = ThemeMode.dark,
    this.initialLocale = const Locale('en'),
    required this.projectRepo,
    required this.experienceRepo,
    required this.hatRepo,
    required this.skillRepo,
  });

  final ThemeMode initialTheme;
  final Locale initialLocale;
  final ProjectRepository projectRepo;
  final ExperienceRepository experienceRepo;
  final HatRepository hatRepo;
  final SkillRepository skillRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProjectRepository>.value(
          value: projectRepo,
        ),
        RepositoryProvider<ExperienceRepository>.value(
          value: experienceRepo,
        ),
        RepositoryProvider<HatRepository>.value(
          value: hatRepo,
        ),
        RepositoryProvider<SkillRepository>.value(
          value: skillRepo,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (_) => ThemeBloc(initialMode: initialTheme),
          ),
          BlocProvider<LocaleBloc>(
            create: (_) => LocaleBloc(initialLocale: initialLocale),
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
                  themeAnimationDuration: AppMotion.heroEntry,
                  themeAnimationCurve: AppMotion.standard,
                  locale: localeState.locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: AppLocalizations.supportedLocales,
                  builder: (context, child) {
                    final media = MediaQuery.of(context);
                    return MediaQuery(
                      data: media.copyWith(
                        textScaler: AppMedia.clampTextScale(media.textScaler),
                      ),
                      // Above the Navigator, so dialogs and case-study
                      // routes get the keyboard focus ring too.
                      child: KeyboardFocusRing(child: child!),
                    );
                  },
                  home: const _AccentTheme(child: HomeScreen()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Applies the live section-accent color as a `Theme` override on top of
/// the base MaterialApp theme. Only this subtree rebuilds on seed change.
///
/// Deliberately a snap, not an `AnimatedTheme` lerp: lerping `ThemeData`
/// rebuilds every `Theme.of` dependent in every mounted page on each frame,
/// ~10x the rebuild work of a page turn (≈70k vs ≈7k element rebuilds)
/// while the slide is running. Accent surfaces that should fade (page
/// background glow, nav pill) animate their own colors implicitly.
class _AccentTheme extends StatelessWidget {
  const _AccentTheme({required this.child});

  final Widget child;

  Widget _buildThemed(BuildContext context, Color seed, Widget staticChild) {
    return Theme(
      data: AppTheme.withAccent(Theme.of(context), seed),
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
