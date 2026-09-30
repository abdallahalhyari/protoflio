import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/features/case_study/case_study_nathealth.dart';

import 'package:profile/features/hats/widget/hat_playing_card.dart';
import 'package:profile/features/shell/widget/shortcut_help_dialog.dart';
import 'package:profile/features/skills/presentation/widgets/skill_search_bar.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/main.dart';
import 'package:profile/theme/app_theme.dart';

/// Runs [body] at [size] and [textScale] and returns every framework error
/// reported on the way (overflows, invalid constraints, NaN transforms).
Future<List<String>> _errorsDuring(
  WidgetTester tester,
  Size size,
  double textScale,
  Future<void> Function() body,
) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  final errors = <String>{};
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final location =
        RegExp(r'lib/[\w/]+\.dart:\d+').firstMatch(details.toString());
    errors.add('${details.exceptionAsString().split('\n').first} '
        '@ ${location?.group(0) ?? '?'}');
  };
  try {
    await body();
  } finally {
    FlutterError.onError = previous;
  }
  return errors.toList();
}

Future<void> _settle(WidgetTester tester, [int frames = 6]) async {
  for (int i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}

Future<void> _tourApp(WidgetTester tester, Size size) async {
  await _settle(tester);
  if (size.width >= 900) {
    for (final key in [
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
    ]) {
      await tester.sendKeyEvent(key);
      await _settle(tester, 10);
    }
  } else {
    for (int i = 0; i < 70; i++) {
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }
}

Widget _host(Widget home, Locale locale) => MaterialApp(
      theme: AppTheme.dark(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

void main() {
  // Widget-level checks first: they run before any whole-app test loads
  // the real fonts, so they measure with the (wide) default test font and
  // don't depend on test order.
  testWidgets('skills search bar keeps its field with long counts',
      (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final errors =
        await _errorsDuring(tester, const Size(360, 740), 1.5, () async {
      await tester.pumpWidget(_host(
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 310,
              child: SkillSearchBar(
                controller: controller,
                onChanged: (_) {},
                onClear: () {},
                totalCount: 34,
                filteredCount: 34,
                isDesktop: false,
              ),
            ),
          ),
        ),
        const Locale('cs'),
      ));
      await tester.pump();
    });
    expect(errors, isEmpty);
  });

  testWidgets('hat card flip hint fits in Czech', (tester) async {
    final errors =
        await _errorsDuring(tester, const Size(1280, 800), 1.0, () async {
      await tester.pumpWidget(_host(
        Scaffold(
          body: Stack(
            children: [
              HatPlayingCard(
                hat: testHats.first,
                index: 0,
                position: const Offset(100, 100),
              ),
            ],
          ),
        ),
        const Locale('cs'),
      ));
      await _settle(tester, 4);
    });
    expect(errors, isEmpty);
  });

  testWidgets('shortcut help dialog scrolls in a short window', (tester) async {
    final errors =
        await _errorsDuring(tester, const Size(320, 568), 2.0, () async {
      await tester.pumpWidget(_host(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showShortcutHelpDialog(context),
                child: const Text('help'),
              ),
            ),
          ),
        ),
        const Locale('cs'),
      ));
      await tester.tap(find.text('help'));
      await _settle(tester, 4);
    });
    expect(errors, isEmpty);
  });

  // Hot restart and minimised tabs hand the app an empty view for a frame.
  // That used to build a NaN parallax transform (0 / 0) and, on the way
  // back, a layer-offset assertion.
  testWidgets('survives live resizes across breakpoints, down to 0 wide',
      (tester) async {
    final errors =
        await _errorsDuring(tester, const Size(1440, 900), 1.0, () async {
      await tester.pumpWidget(PortfolioApp(
          projectRepo: TestProjectRepository(),
          experienceRepo: TestExperienceRepository(),
          hatRepo: TestHatRepository(),
          skillRepo: TestSkillRepository(),
        ));
      await _settle(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
      await _settle(tester, 8);
      for (final size in const [
        Size(390, 844),
        Size(1440, 900),
        Size(820, 1180),
        Size(0, 900),
        Size.zero,
        Size(1, 1),
        Size(1024, 700),
        Size(360, 740),
      ]) {
        tester.view.physicalSize = size;
        await _settle(tester, 8);
      }
    });
    expect(errors, isEmpty);
  });

  // Edge viewports and the longest translations, beyond the 4 standard
  // sizes in text_scale_layout_test.
  const cases = <String, (Size, Locale, double)>{
    'Czech phone 360 @ 1.5x text': (Size(360, 740), Locale('cs'), 1.5),
    'Arabic phone 320 @ 2x text': (Size(320, 640), Locale('ar'), 2.0),
    'foldable 280 @ 1.5x text': (Size(280, 653), Locale('en'), 1.5),
    'landscape phone 740x360': (Size(740, 360), Locale('en'), 1.0),
    'short laptop 1280x600, Czech': (Size(1280, 600), Locale('cs'), 1.0),
  };
  for (final entry in cases.entries) {
    testWidgets('whole app lays out cleanly — ${entry.key}', (tester) async {
      final (size, locale, scale) = entry.value;
      final errors = await _errorsDuring(tester, size, scale, () async {
        await tester.pumpWidget(PortfolioApp(
          initialLocale: locale,
          projectRepo: TestProjectRepository(),
          experienceRepo: TestExperienceRepository(),
          hatRepo: TestHatRepository(),
          skillRepo: TestSkillRepository(),
        ));
        await _tourApp(tester, size);
      });
      expect(errors, isEmpty);
    });
  }

  testWidgets('case study reader: small phone, 2x text, empty-view resize',
      (tester) async {
    const size = Size(320, 640);
    final errors = await _errorsDuring(tester, size, 2.0, () async {
      await tester
          .pumpWidget(_host(const NatHealthCaseStudy(), const Locale('cs')));
      await _settle(tester, 5);
      for (int i = 0; i < 40; i++) {
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
        await tester.pump(const Duration(milliseconds: 80));
      }
      tester.view.physicalSize = const Size(0, 600);
      await tester.pump(const Duration(milliseconds: 100));
      tester.view.physicalSize = size;
      await _settle(tester, 2);
    });
    expect(errors, isEmpty);
  });
}
