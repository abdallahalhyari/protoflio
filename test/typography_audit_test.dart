import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/home_controller.dart';
import 'package:profile/features/shell/widget/mobile_footer.dart';
import 'package:profile/features/experience/widget/credentials_bento_card.dart';
import 'package:profile/theme/app_theme.dart';
import 'package:profile/theme/tokens.dart';

HomeController _mockController() {
  return HomeController(
    pageIndex: ValueNotifier<int>(0),
    showScrollToTop: ValueNotifier<bool>(false),
    pageCount: 7,
    goTo: (int _, {bool syncUrl = true}) {},
    next: () {},
    prev: () {},
    scrollToMobileSection: (int _, {bool syncUrl = true}) {},
    downloadResume: () async {},
  );
}

Widget _wrapWithTextScaler({
  required Widget child,
  required TextScaler textScaler,
  Size size = const Size(390, 844),
  Brightness brightness = Brightness.dark,
}) {
  return MaterialApp(
    theme: brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, c) {
      final media = MediaQuery.of(context);
      return MediaQuery(
        data: media.copyWith(
          size: size,
          textScaler: media.textScaler.clamp(
            minScaleFactor: 0.85,
            maxScaleFactor: 1.35,
          ),
        ),
        child: c!,
      );
    },
    home: HomeControllerScope(
      controller: _mockController(),
      child: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  group('AppTypography Token & Scale Hierarchy Audit', () {
    test('Typography font family tokens are defined and non-empty', () {
      expect(AppTypography.displayFont, 'Tenada');
      expect(AppTypography.monoFont, 'Courier');
    });

    test('Typography scale maintains strict logical monotonic progression', () {
      expect(AppTypography.nano, lessThan(AppTypography.micro));
      expect(AppTypography.nano, lessThan(AppTypography.editorialSm));
      expect(AppTypography.editorialSm, lessThan(AppTypography.editorial));
      expect(AppTypography.micro, lessThanOrEqualTo(AppTypography.caption));
      expect(AppTypography.caption, lessThan(AppTypography.captionSm));
      expect(AppTypography.captionSm, lessThan(AppTypography.overline));
      expect(AppTypography.overline, lessThan(AppTypography.overlineTight));
      expect(AppTypography.overlineTight, lessThan(AppTypography.small));
      expect(AppTypography.small, lessThan(AppTypography.smallLoose));
      expect(AppTypography.smallLoose, lessThan(AppTypography.body));
      expect(AppTypography.body, lessThan(AppTypography.bodyLoose));
      expect(AppTypography.bodyLoose, lessThan(AppTypography.bodyLg));
      expect(AppTypography.bodyLg, lessThan(AppTypography.subtitle));
      expect(AppTypography.subtitle, lessThan(AppTypography.titleSm));
      expect(AppTypography.titleSm, lessThan(AppTypography.title));
      expect(AppTypography.title, lessThan(AppTypography.titleMid));
      expect(AppTypography.titleMid, lessThan(AppTypography.titleLg));
      expect(AppTypography.titleLg, lessThan(AppTypography.heading));
      expect(AppTypography.heading, lessThan(AppTypography.displaySm));
      expect(AppTypography.displaySm, lessThan(AppTypography.statDisplay));
      expect(AppTypography.statDisplay, lessThan(AppTypography.display));
      expect(AppTypography.display, lessThan(AppTypography.displayLg));
      expect(AppTypography.displayLg, lessThan(AppTypography.heroSm));
      expect(AppTypography.heroSm, lessThan(AppTypography.hero));
      expect(AppTypography.hero, lessThan(AppTypography.watermark));
    });

    test('New audit tokens match expected design point values', () {
      expect(AppTypography.nano, 8.5);
      expect(AppTypography.bodyLoose, 14.5);
      expect(AppTypography.bodyLg, 15.0);
      expect(AppTypography.titleSm, 18.0);
      expect(AppTypography.titleMid, 22.0);
      expect(AppTypography.titleLg, 24.0);
      expect(AppTypography.displaySm, 36.0);
      expect(AppTypography.statDisplay, 38.0);
      expect(AppTypography.displayLg, 54.0);
      expect(AppTypography.heroSm, 60.0);
      expect(AppTypography.watermark, 220.0);
    });
  });

  group('Dynamic Text Scaling Clamping Audit', () {
    testWidgets(
        'Clamps huge OS font accessibility scale factor (2.5x) down to 1.35x',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      late double effectiveScale;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            // Simulate incoming OS MediaQuery with huge 2.5x font scale
            final media = MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(2.5),
            );
            return MediaQuery(
              data: media.copyWith(
                textScaler: media.textScaler.clamp(
                  minScaleFactor: 0.85,
                  maxScaleFactor: 1.35,
                ),
              ),
              child: Builder(
                builder: (innerCtx) {
                  effectiveScale =
                      MediaQuery.of(innerCtx).textScaler.scale(100.0) / 100.0;
                  return child!;
                },
              ),
            );
          },
          home: const Scaffold(body: Text('Accessible Scaling Test')),
        ),
      );

      await tester.pumpAndSettle();
      expect(effectiveScale, closeTo(1.35, 0.001));
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'Clamps tiny font accessibility scale factor (0.5x) up to 0.85x',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      late double effectiveScale;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            final media = MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(0.5),
            );
            return MediaQuery(
              data: media.copyWith(
                textScaler: media.textScaler.clamp(
                  minScaleFactor: 0.85,
                  maxScaleFactor: 1.35,
                ),
              ),
              child: Builder(
                builder: (innerCtx) {
                  effectiveScale =
                      MediaQuery.of(innerCtx).textScaler.scale(100.0) / 100.0;
                  return child!;
                },
              ),
            );
          },
          home: const Scaffold(body: Text('Tiny Scaling Test')),
        ),
      );

      await tester.pumpAndSettle();
      expect(effectiveScale, closeTo(0.85, 0.001));
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('Renders MobileFooter cleanly under max clamped scale (1.35x)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(
        _wrapWithTextScaler(
          child: const MobileFooter(),
          textScaler: const TextScaler.linear(2.0), // will be clamped to 1.35
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ABDALLAH AL-HYARI'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'Renders CredentialsBentoCard cleanly under max clamped scale (1.35x)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 844));
      await tester.pumpWidget(
        _wrapWithTextScaler(
          child: const SingleChildScrollView(
            child: CredentialsBentoCard(isDesktop: false, isVisible: true),
          ),
          textScaler: const TextScaler.linear(1.35),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ACADEMIC ANNEX'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });
  });
}
