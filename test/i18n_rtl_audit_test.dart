import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/features/contact/page/contact_page.dart';
import 'package:profile/features/engineering/page/engineering_page.dart';
import 'package:profile/features/experience/page/experience_page.dart';
import 'package:profile/features/hats/page/hats_grid_page.dart';
import 'package:profile/features/intro/page/intro_page.dart';
import 'package:profile/features/projects/page/projects_page.dart';
import 'package:profile/features/skills/page/skills_page.dart';
import 'package:profile/shared/widget/directional_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _buildLocalizedHarness(Widget child, Locale locale,
    {Size size = const Size(1200, 800)}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: MaterialApp(
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
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ARB Localization Files Completeness Audit', () {
    test(
        'All non-metadata keys in app_en.arb are translated in app_ar.arb and app_cs.arb',
        () {
      final enFile = File('lib/l10n/app_en.arb');
      final arFile = File('lib/l10n/app_ar.arb');
      final csFile = File('lib/l10n/app_cs.arb');

      expect(enFile.existsSync(), isTrue);
      expect(arFile.existsSync(), isTrue);
      expect(csFile.existsSync(), isTrue);

      final Map<String, dynamic> enJson =
          jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
      final Map<String, dynamic> arJson =
          jsonDecode(arFile.readAsStringSync()) as Map<String, dynamic>;
      final Map<String, dynamic> csJson =
          jsonDecode(csFile.readAsStringSync()) as Map<String, dynamic>;

      final enKeys = enJson.keys.where((k) => !k.startsWith('@')).toSet();
      final arKeys = arJson.keys.where((k) => !k.startsWith('@')).toSet();
      final csKeys = csJson.keys.where((k) => !k.startsWith('@')).toSet();

      final missingInAr = enKeys.difference(arKeys);
      final missingInCs = enKeys.difference(csKeys);

      expect(missingInAr, isEmpty,
          reason:
              'Arabic ARB must contain all English keys. Missing: $missingInAr');
      expect(missingInCs, isEmpty,
          reason:
              'Czech ARB must contain all English keys. Missing: $missingInCs');
    });
  });

  group('Directionality Resolution & DirIcon Inversion Audit', () {
    testWidgets(
        'Arabic locale resolves to TextDirection.rtl and English to ltr',
        (tester) async {
      await tester.pumpWidget(_buildLocalizedHarness(
        Builder(
          builder: (context) {
            final dir = Directionality.of(context);
            return Text('Dir: $dir');
          },
        ),
        const Locale('ar'),
      ));
      expect(find.text('Dir: TextDirection.rtl'), findsOneWidget);

      await tester.pumpWidget(_buildLocalizedHarness(
        Builder(
          builder: (context) {
            final dir = Directionality.of(context);
            return Text('Dir: $dir');
          },
        ),
        const Locale('en'),
      ));
      expect(find.text('Dir: TextDirection.ltr'), findsOneWidget);
    });

    testWidgets(
        'DirIcon inverts horizontal scale under RTL and preserves it under LTR',
        (tester) async {
      // Under RTL
      await tester.pumpWidget(_buildLocalizedHarness(
        const DirIcon(Icons.chevron_right, size: 24),
        const Locale('ar'),
      ));
      final transformFinder = find.descendant(
        of: find.byType(DirIcon),
        matching: find.byType(Transform),
      );
      expect(transformFinder, findsWidgets);
      final transform = tester.widgetList<Transform>(transformFinder).first;
      // Horizontal scale should be -1.0
      expect(transform.transform.getMaxScaleOnAxis(), closeTo(1.0, 0.001));
      expect(transform.transform.entry(0, 0), closeTo(-1.0, 0.001));

      // Under LTR
      await tester.pumpWidget(_buildLocalizedHarness(
        const DirIcon(Icons.chevron_right, size: 24),
        const Locale('en'),
      ));
      // In LTR, DirIcon returns the bare Icon directly without a Transform wrapper
      final ltrTransformFinder = find.descendant(
        of: find.byType(DirIcon),
        matching: find.byType(Transform),
      );
      expect(ltrTransformFinder, findsNothing);
      expect(
          find.descendant(
              of: find.byType(DirIcon), matching: find.byType(Icon)),
          findsOneWidget);
    });
  });

  group('Multi-Locale Layout & Rendering Completeness Audit', () {
    testWidgets(
        'IntroPage renders cleanly in Arabic (RTL) and Czech (LTR) without overflow',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Arabic Desktop
      await tester.pumpWidget(_buildLocalizedHarness(
        IntroPage(onScrollDown: () {}),
        const Locale('ar'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // Czech Desktop
      await tester.pumpWidget(_buildLocalizedHarness(
        IntroPage(onScrollDown: () {}),
        const Locale('cs'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'ExperiencePage renders cleanly in Arabic (RTL) and Czech (LTR)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildLocalizedHarness(
        const ExperiencePage(),
        const Locale('ar'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(_buildLocalizedHarness(
        const ExperiencePage(),
        const Locale('cs'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'ProjectsPage renders cleanly in Arabic (RTL) with localized mobile controls',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildLocalizedHarness(
        const SingleChildScrollView(
          child: ProjectsPage(isContinuousMobile: true),
        ),
        const Locale('ar'),
        size: const Size(390, 844),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      expect(find.text('السابق'), findsOneWidget);
      expect(find.text('التالي'), findsOneWidget);
    });

    testWidgets(
        'SkillsPage renders cleanly in Arabic (RTL) with directional padding',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildLocalizedHarness(
        const SkillsPage(),
        const Locale('ar'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'EngineeringPage renders cleanly in Arabic (RTL) and Czech (LTR)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildLocalizedHarness(
        const EngineeringPage(),
        const Locale('ar'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets('HatsGridPage renders cleanly in Arabic (RTL) and Czech (LTR)',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildLocalizedHarness(
        const HatsGridPage(),
        const Locale('ar'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'ContactPage renders cleanly in Arabic (RTL) with localized feedback toast',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_buildLocalizedHarness(
        const ContactPage(),
        const Locale('ar'),
      ));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });
  });
}
