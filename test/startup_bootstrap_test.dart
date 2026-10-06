import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:profile/app/bootstrap.dart';
import 'package:profile/features/experience/data/repositories/local_experience_repository.dart';
import 'package:profile/features/hats/data/repositories/local_hat_repository.dart';
import 'package:profile/features/projects/data/repositories/local_project_repository.dart';
import 'package:profile/features/skills/data/repositories/local_skill_repository.dart';

/// A content repository whose load fails, like a request that is still
/// dropped after the loader's retries.
class _FailingProjectRepository extends LocalProjectRepository {
  @override
  Future<void> load() => Future.error(StateError('projects.json unreachable'));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('readInitialThemeMode', () {
    test('defaults to light for missing or invalid values', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(prefs), ThemeMode.light);

      SharedPreferences.setMockInitialValues({'themeMode': 'invalid'});
      final invalidPrefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(invalidPrefs), ThemeMode.light);
    });

    test('reads supported theme preferences', () async {
      SharedPreferences.setMockInitialValues({'themeMode': 'light'});
      final lightPrefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(lightPrefs), ThemeMode.light);

      SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
      final darkPrefs = await SharedPreferences.getInstance();
      expect(readInitialThemeMode(darkPrefs), ThemeMode.dark);
    });

    test('URL theme overrides the saved preference', () async {
      SharedPreferences.setMockInitialValues({'themeMode': 'dark'});
      final prefs = await SharedPreferences.getInstance();
      expect(
        readInitialThemeMode(prefs,
            uri: Uri.parse('https://example.com/?theme=light')),
        ThemeMode.light,
      );
    });
  });

  group('readInitialLocale', () {
    test('defaults to English for missing or unsupported values', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(prefs), const Locale('en'));

      SharedPreferences.setMockInitialValues({'localeCode': 'fr'});
      final invalidPrefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(invalidPrefs), const Locale('en'));
    });

    test('reads supported locales', () async {
      SharedPreferences.setMockInitialValues({'localeCode': 'ar'});
      final arabicPrefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(arabicPrefs), const Locale('ar'));

      SharedPreferences.setMockInitialValues({'localeCode': 'cs'});
      final czechPrefs = await SharedPreferences.getInstance();
      expect(readInitialLocale(czechPrefs), const Locale('cs'));
    });

    test('URL language overrides the saved preference', () async {
      SharedPreferences.setMockInitialValues({'localeCode': 'en'});
      final prefs = await SharedPreferences.getInstance();
      expect(
        readInitialLocale(prefs,
            uri: Uri.parse('https://example.com/?lang=ar')),
        const Locale('ar'),
      );
    });
  });

  testWidgets('AppBootstrapper renders startup loading state immediately',
      (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(MaterialApp(
      home: AppBootstrapper(builder: (_) => const SizedBox()),
    ));

    expect(find.text('Loading portfolio…'), findsOneWidget);
    expect(find.text('Abdallah Alhyari'), findsOneWidget);
  });

  // A failed content load must reach the retry screen. It used to be
  // swallowed, and the site opened with empty sections instead.
  test('loadInitialData fails when content cannot load', () async {
    await expectLater(
      loadInitialData(
        projectRepo: _FailingProjectRepository(),
        experienceRepo: LocalExperienceRepository(),
        hatRepo: LocalHatRepository(),
        skillRepo: LocalSkillRepository(),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('loadInitialData succeeds with the bundled content', () async {
    final projects = LocalProjectRepository();
    await loadInitialData(
      projectRepo: projects,
      experienceRepo: LocalExperienceRepository(),
      hatRepo: LocalHatRepository(),
      skillRepo: LocalSkillRepository(),
    );
    expect(projects.getProjects(), isNotEmpty);
  });

  testWidgets('a failed startup shows the retry screen', (tester) async {
    final startup = Completer<AppBootstrapData>();
    await tester.pumpWidget(MaterialApp(
      home: AppBootstrapper(
        builder: (_) => const SizedBox(),
        bootstrapOverride: startup.future,
      ),
    ));
    startup.completeError(StateError('projects.json unreachable'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Startup failed'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  // The minimum splash must not hold back content that is already
  // loaded: it delayed the live site's first content by ~570ms.
  testWidgets('loaded content shows without waiting for the minimum splash',
      (tester) async {
    final startup = Completer<AppBootstrapData>();
    await tester.pumpWidget(MaterialApp(
      home: AppBootstrapper(
        builder: (_) => const Text('content'),
        bootstrapOverride: startup.future,
      ),
    ));
    startup.complete(AppBootstrapData(
      initialTheme: ThemeMode.dark,
      initialLocale: const Locale('en'),
      projectRepo: LocalProjectRepository(),
      experienceRepo: LocalExperienceRepository(),
      hatRepo: LocalHatRepository(),
      skillRepo: LocalSkillRepository(),
    ));
    await tester.pump();
    expect(find.text('content'), findsOneWidget);
    // Let the pending splash timer fire so the test ends cleanly.
    await tester.pump(const Duration(seconds: 1));
  });
}
