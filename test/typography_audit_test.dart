import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/shell/presentation/controllers/home_controller.dart';
import 'package:profile/features/shell/presentation/widgets/mobile_footer.dart';
import 'package:profile/features/experience/presentation/widgets/credentials_bento_card.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/core/theme/tokens.dart';

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
          textScaler: AppMedia.clampTextScale(media.textScaler),
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
      expect(AppTypography.bodyFont, 'ReadexPro');
      expect(AppTypography.displayFont, AppTypography.bodyFont);
      expect(AppTypography.monoFont, 'ShareTechMono');
    });

    test('Seven-step scale, strictly increasing, nothing below 12px', () {
      const scale = [
        AppTypography.label,
        AppTypography.body,
        AppTypography.lead,
        AppTypography.title,
        AppTypography.heading,
        AppTypography.display,
        AppTypography.hero,
      ];
      for (var i = 1; i < scale.length; i++) {
        expect(scale[i], greaterThan(scale[i - 1]));
      }
      expect(scale.first, greaterThanOrEqualTo(12));
    });
  });

  group('Dynamic Text Scaling Clamping Audit', () {
    testWidgets(
        'Clamps huge OS font accessibility scale factor (2.5x) down to 2x',
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
                textScaler: AppMedia.clampTextScale(media.textScaler),
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
      expect(effectiveScale, closeTo(AppMedia.maxTextScale, 0.001));
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
                textScaler: AppMedia.clampTextScale(media.textScaler),
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

    testWidgets('Renders MobileFooter cleanly under max clamped scale (2x)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      await tester.pumpWidget(
        _wrapWithTextScaler(
          child: const MobileFooter(),
          textScaler: const TextScaler.linear(2.5), // clamped to 2x
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ABDALLAH ALHYARI'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
        'Renders CredentialsBentoCard cleanly under max clamped scale (2x)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 844));
      await tester.pumpWidget(
        _wrapWithTextScaler(
          child: const SingleChildScrollView(
            child: CredentialsBentoCard(isDesktop: false, isVisible: true),
          ),
          textScaler: const TextScaler.linear(2.0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('ACADEMIC ANNEX'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.binding.setSurfaceSize(null);
    });
  });
}
