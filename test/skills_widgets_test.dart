import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/l10n/app_localizations.dart';
import 'package:profile/module/home/widget/skills/skill_category_filters.dart';
import 'package:profile/module/home/widget/skills/skill_search_bar.dart';
import 'package:profile/module/home/widget/skills/skills_empty_state.dart';
import 'package:profile/module/home/widget/skills/skills_header.dart';
import 'package:profile/theme/app_theme.dart';

Widget _wrap(Widget child, [Size size = const Size(1200, 900)]) {
  return MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(size: size),
      child: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  group('Skills Widgets Test Suite', () {
    testWidgets('SkillsHeader renders title, disciplines text, and badge', (tester) async {
      await tester.pumpWidget(_wrap(const SkillsHeader(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(find.text('FEATURE 05 · ARCHITECTURAL MASTERY'), findsOneWidget);
      expect(find.text('12 CORE DISCIPLINES'), findsOneWidget);
    });

    testWidgets('SkillCategoryFilters renders categories and triggers selection', (tester) async {
      String selected = 'ALL';
      const categories = ['ALL', 'Mobile Systems', 'Security & Protocols'];

      await tester.pumpWidget(_wrap(
        StatefulBuilder(
          builder: (context, setState) {
            return SkillCategoryFilters(
              categories: categories,
              selectedCategory: selected,
              onSelectCategory: (cat) => setState(() => selected = cat),
              isDesktop: true,
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('MOBILE SYSTEMS'), findsOneWidget);
      await tester.tap(find.textContaining('MOBILE SYSTEMS'));
      await tester.pumpAndSettle();

      expect(selected, 'Mobile Systems');
    });

    testWidgets('SkillsEmptyState renders and triggers onShowAll', (tester) async {
      bool resetTriggered = false;
      await tester.pumpWidget(_wrap(
        SkillsEmptyState(onShowAll: () => resetTriggered = true),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_alt_off_outlined), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(resetTriggered, isTrue);
    });

    testWidgets('SkillSearchBar renders search input, count badge, and clears text', (tester) async {
      final controller = TextEditingController(text: 'flutter');
      addTearDown(controller.dispose);
      bool cleared = false;
      await tester.pumpWidget(_wrap(
        SkillSearchBar(
          controller: controller,
          onChanged: (_) {},
          onClear: () {
            controller.clear();
            cleared = true;
          },
          totalCount: 24,
          filteredCount: 5,
          isDesktop: true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('5 OF 24 SKILLS'), findsOneWidget);

      // Tap clear button
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(controller.text, '');
      expect(cleared, isTrue);
    });

    test('SkillCategoryStyle returns color and gradient for known categories', () {
      const scheme = ColorScheme.dark();
      final color = SkillCategoryStyle.getColor('Mobile Systems', scheme);
      expect(color, const Color(0xFF38BDF8));

      final gradient = SkillCategoryStyle.getGradient('Security & Protocols', scheme);
      expect(gradient.length, 2);
      expect(gradient.first, const Color(0xFFFBBF24));
    });
  });
}
