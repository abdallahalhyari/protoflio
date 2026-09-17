import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/module/home/widget/desktop_toolbar.dart';
import 'package:profile/module/home/widget/theme_accent_picker.dart';
import 'package:profile/theme/tokens.dart';
import 'package:profile/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ThemeController.setCustomAccent(null);
    ThemeController.updateSeedFromIndex(0);
  });

  group('ThemeController Chromatic Seed and Accents', () {
    test('Default mode is dynamic with seed color', () {
      expect(ThemeController.isDynamicSectionMode, isTrue);
      expect(ThemeController.customAccent.value, isNull);
      expect(ThemeController.activeAccent, AppColors.seed);
    });

    test('updateSeedFromIndex changes active accent when in dynamic mode', () {
      ThemeController.updateSeedFromIndex(1); // Experience
      expect(ThemeController.activeAccent, AppColors.accentGreen);

      ThemeController.updateSeedFromIndex(2); // Work
      expect(ThemeController.activeAccent, AppColors.accentViolet);

      ThemeController.updateSeedFromIndex(3); // Stack
      expect(ThemeController.activeAccent, AppColors.accentAmber);

      ThemeController.updateSeedFromIndex(4); // Engineering
      expect(ThemeController.activeAccent, AppColors.accentRose);

      ThemeController.updateSeedFromIndex(5); // Perspectives
      expect(ThemeController.activeAccent, AppColors.accentCyan);

      ThemeController.updateSeedFromIndex(6); // Contact
      expect(ThemeController.activeAccent, AppColors.accentIndigoDeep);
    });

    test('updateSeedFromHash resolves signature case study brand accents', () {
      ThemeController.updateSeedFromHash('#work/nathealth');
      expect(ThemeController.activeAccent, AppColors.caseStudyNatHealthPrimary);

      ThemeController.updateSeedFromHash('work/eskadenia');
      expect(ThemeController.activeAccent, AppColors.caseStudyEskadeniaPrimary);

      ThemeController.updateSeedFromHash('work/solutions');
      expect(ThemeController.activeAccent, AppColors.caseStudySolutionsPrimary);

      ThemeController.updateSeedFromHash('#work/fais');
      expect(ThemeController.activeAccent, AppColors.caseStudyFaisPrimary);

      ThemeController.updateSeedFromHash('#work');
      expect(ThemeController.activeAccent, AppColors.accentViolet);
    });

    test('setCustomAccent locks color and prevents dynamic section override', () {
      ThemeController.setCustomAccent(AppColors.accentRose);
      expect(ThemeController.isDynamicSectionMode, isFalse);
      expect(ThemeController.customAccent.value, AppColors.accentRose);
      expect(ThemeController.activeAccent, AppColors.accentRose);

      // Section changes should be ignored while custom accent is active
      ThemeController.updateSeedFromIndex(1);
      expect(ThemeController.activeAccent, AppColors.accentRose);

      ThemeController.updateSeedFromHash('work/nathealth');
      expect(ThemeController.activeAccent, AppColors.accentRose);

      // Reverting to null re-enables dynamic mode
      ThemeController.setCustomAccent(null);
      expect(ThemeController.isDynamicSectionMode, isTrue);
      expect(ThemeController.customAccent.value, isNull);
    });
  });

  group('ThemeAccentPickerButton Widget', () {
    testWidgets('Renders on Desktop Toolbar and shows palette popup on tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: const DesktopToolbar(),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final pickerFinder = find.byType(ThemeAccentPickerButton);
      expect(pickerFinder, findsOneWidget);

      // Tap the picker button to open popup
      await tester.tap(pickerFinder);
      await tester.pumpAndSettle();

      // Header and dynamic sync item should be present
      expect(find.text('CHROMATIC ACCENT'), findsOneWidget);
      expect(find.text('Dynamic (Sync with Section)'), findsOneWidget);
      expect(find.text('Indigo'), findsOneWidget);
      expect(find.text('Emerald'), findsOneWidget);
      expect(find.text('Cyan'), findsOneWidget);
      expect(find.text('Amber'), findsOneWidget);
      expect(find.text('Rose'), findsOneWidget);
      expect(find.text('Violet'), findsOneWidget);

      // Tap 'Emerald'
      await tester.tap(find.text('Emerald'));
      await tester.pumpAndSettle();

      expect(ThemeController.customAccent.value, AppColors.caseStudyNatHealthPrimary);
      expect(ThemeController.activeAccent, AppColors.caseStudyNatHealthPrimary);
    });

    testWidgets('Mobile variant renders compact icon and opens palette menu', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: const [
                ThemeAccentPickerButton(isMobile: true),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      final pickerFinder = find.byType(ThemeAccentPickerButton);
      expect(pickerFinder, findsOneWidget);

      await tester.tap(pickerFinder);
      await tester.pumpAndSettle();

      expect(find.text('CHROMATIC ACCENT'), findsOneWidget);
      expect(find.text('Dynamic (Sync with Section)'), findsOneWidget);

      // Revert to dynamic
      await tester.tap(find.text('Dynamic (Sync with Section)'));
      await tester.pumpAndSettle();

      expect(ThemeController.isDynamicSectionMode, isTrue);
    });
  });
}
