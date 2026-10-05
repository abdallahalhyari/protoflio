import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/skills/presentation/pages/skills_page.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/shared/utils/grid_math.dart';
import 'package:profile/core/theme/app_theme.dart';

void main() {
  group('columnWidth', () {
    test('splits the width between columns and gaps', () {
      expect(columnWidth(212, 2, 12), 100);
      expect(columnWidth(332, 3, 16), closeTo(100, 0.001));
      expect(columnWidth(300, 1, 16), 300);
    });

    test('never goes negative', () {
      expect(columnWidth(0, 2, 12), 0);
      expect(columnWidth(5, 3, 16), 0);
      expect(columnWidth(double.infinity, 2, 12), 0);
    });
  });

  // Regression: on a hot restart the mobile skills grid was laid out at
  // width 0 for a frame and asked for (0 - 12) / 2 = -6px tiles, which is
  // a "negative minimum width" assertion.
  testWidgets('mobile skills grid survives a zero-width layout',
      (tester) async {
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;
    addTearDown(() => FlutterError.onError = previous);

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MediaQuery(
        data: MediaQueryData(size: Size(390, 844)),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 0,
                child: SkillsPage(isContinuousMobile: true),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();
    FlutterError.onError = previous;

    // Other content may overflow a zero-width box (that's only a debug
    // stripe); what must not happen is an invalid-constraints assertion.
    final fatal = errors
        .map((e) => e.exceptionAsString())
        .where((m) => !m.contains('overflowed'))
        .toList();
    expect(fatal, isEmpty);
  });
}
