import 'dart:async';

import 'package:flutter/material.dart';
import 'package:profile/core/bloc/locale/locale_bloc.dart';
import 'package:profile/core/bloc/theme/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/features/experience/data/repositories/local_experience_repository.dart';
import 'package:profile/features/hats/data/repositories/local_hat_repository.dart';
import 'package:profile/features/projects/data/repositories/local_project_repository.dart';
import 'package:profile/features/skills/data/repositories/local_skill_repository.dart';
import 'package:profile/service/boot_handoff.dart';
import 'package:profile/service/sound_service.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens/colors.dart';

const _themePrefsKey = ThemeBloc.prefsKey;
const _localePrefsKey = LocaleBloc.prefsKey;
ThemeMode readInitialThemeMode(SharedPreferences prefs, {Uri? uri}) {
  return ThemeBloc.resolveInitial(
    uri: uri ?? Uri.base,
    stored: prefs.getString(_themePrefsKey),
  );
}

Locale readInitialLocale(SharedPreferences prefs, {Uri? uri}) {
  return LocaleBloc.resolveInitial(
    uri: uri ?? Uri.base,
    stored: prefs.getString(_localePrefsKey),
  );
}

Future<void> loadInitialData({
  required LocalProjectRepository projectRepo,
  required LocalExperienceRepository experienceRepo,
  required LocalHatRepository hatRepo,
  required LocalSkillRepository skillRepo,
}) async {
  // Sound is optional: the site works muted. Content is not: swallowing a
  // failed content load started the app with empty sections and never
  // showed the retry screen, so those errors propagate to it (after the
  // loader's own retries).
  final sound =
      SoundService.instance.load().catchError((Object error, StackTrace st) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: st,
      library: 'profile',
      context: ErrorDescription('Failed to load sound effects.'),
    ));
  });
  await Future.wait([
    sound,
    projectRepo.load(),
    experienceRepo.load(),
    hatRepo.load(),
    skillRepo.load(),
  ]);
}

class AppBootstrapData {
  const AppBootstrapData({
    required this.initialTheme,
    required this.initialLocale,
    required this.projectRepo,
    required this.experienceRepo,
    required this.hatRepo,
    required this.skillRepo,
  });

  final ThemeMode initialTheme;
  final Locale initialLocale;
  final LocalProjectRepository projectRepo;
  final LocalExperienceRepository experienceRepo;
  final LocalHatRepository hatRepo;
  final LocalSkillRepository skillRepo;
}

class AppBootstrapper extends StatefulWidget {
  const AppBootstrapper({
    super.key,
    required this.builder,
    this.bootstrapOverride,
  });

  final Widget Function(AppBootstrapData data) builder;
  final Future<AppBootstrapData>? bootstrapOverride;

  @override
  State<AppBootstrapper> createState() => _AppBootstrapperState();
}

class _AppBootstrapperState extends State<AppBootstrapper> {
  late Future<AppBootstrapData> _bootstrapFuture;
  bool _didMinimumSplashTimePass = false;
  bool _announcedReady = false;
  Timer? _minimumSplashTimer;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = widget.bootstrapOverride ?? _bootstrap();
    _scheduleMinimumSplash();
  }

  @override
  void dispose() {
    _minimumSplashTimer?.cancel();
    super.dispose();
  }

  void _scheduleMinimumSplash() {
    _minimumSplashTimer?.cancel();
    _minimumSplashTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _didMinimumSplashTimePass = true;
      });
    });
  }

  Future<void> _retry() async {
    setState(() {
      _didMinimumSplashTimePass = false;
      _bootstrapFuture = widget.bootstrapOverride ?? _bootstrap();
    });
    _scheduleMinimumSplash();
  }

  /// Lets the HTML boot screen go once a real screen (the app, or the
  /// retry screen) has painted under it. Waits one more frame past the
  /// first: on the web the frame is drawn off the main thread and can
  /// reach the screen after this frame's callbacks have run.
  void _announceReady() {
    if (_announcedReady) return;
    _announcedReady = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance
        ..scheduleFrame()
        ..addPostFrameCallback((_) => signalAppReady());
    });
  }

  Future<AppBootstrapData> _bootstrap() async {
    late final ThemeMode initTheme;
    late final Locale initLocale;

    try {
      final prefs = await SharedPreferences.getInstance();
      initTheme = readInitialThemeMode(prefs);
      initLocale = readInitialLocale(prefs);
      if (LocaleBloc.languageFromUrl(Uri.base) case final code?) {
        unawaited(LocaleBloc.persist(code));
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'profile',
          context: ErrorDescription('Failed to read startup preferences.'),
        ),
      );
      initTheme = ThemeMode.dark;
      initLocale = const Locale('en');
    }

    final projectRepo = LocalProjectRepository();
    final experienceRepo = LocalExperienceRepository();
    final hatRepo = LocalHatRepository();
    final skillRepo = LocalSkillRepository();

    await loadInitialData(
      projectRepo: projectRepo,
      experienceRepo: experienceRepo,
      hatRepo: hatRepo,
      skillRepo: skillRepo,
    );

    return AppBootstrapData(
      initialTheme: initTheme,
      initialLocale: initLocale,
      projectRepo: projectRepo,
      experienceRepo: experienceRepo,
      hatRepo: hatRepo,
      skillRepo: skillRepo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppBootstrapData>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        // Content shows as soon as it's ready: holding it for the minimum
        // splash cost ~570ms of first content on the live site. The
        // minimum only fronts the error screen, so a quick failure (or
        // a retry) doesn't flash between loading and error.
        if (snapshot.hasData) {
          _announceReady();
          return widget.builder(snapshot.data!);
        }
        if (snapshot.hasError && _didMinimumSplashTimePass) {
          _announceReady();
          return _StartupErrorScreen(onRetry: _retry);
        }
        return const _StartupLoadingScreen();
      },
    );
  }
}

class _StartupLoadingScreen extends StatefulWidget {
  const _StartupLoadingScreen();

  @override
  State<_StartupLoadingScreen> createState() => _StartupLoadingScreenState();
}

class _StartupLoadingScreenState extends State<_StartupLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.dark();
    final accent = AppColors.accentIndigo;
    final panelBorder = Colors.white.withValues(alpha: 0.12);

    return Theme(
      data: theme,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: AppColors.darkNight,
          // The HTML boot screen's gradient: this screen only shows if the
          // content is slow, and then sits right where the boot screen was.
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.16),
                radius: 1.1,
                colors: [
                  AppColors.bootGlow,
                  AppColors.darkNight,
                  AppColors.bootEdge,
                ],
                stops: [0.0, 0.52, 1.0],
              ),
            ),
            child: Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 22,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: panelBorder),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.18),
                          blurRadius: 34,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 56,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        Text(
                          'ABDALLAH ALHYARI',
                          style: theme.textTheme.titleMedium?.copyWith(
                            letterSpacing: 3,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Senior Flutter & Android Engineer',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: 220,
                          child: LinearProgressIndicator(
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(999),
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.08),
                            valueColor: AlwaysStoppedAnimation<Color>(accent),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Loading portfolio…',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.dark();
    final accent = AppColors.accentIndigo;
    final surface = AppColors.darkSurface;

    return Theme(
      data: theme,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Material(
          color: surface,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  surface,
                  Color.alphaBlend(
                    accent.withValues(alpha: 0.08),
                    AppColors.darkSurfaceElevated,
                  ),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accent.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          color: accent,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Startup failed',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Unable to start the portfolio.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: () async {
                          await onRetry();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: AppColors.onAccent(accent),
                        ),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
