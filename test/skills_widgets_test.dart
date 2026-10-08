import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/core/theme/tokens.dart';
import 'package:profile/l10n/app_localizations.dart';

import 'package:profile/features/skills/presentation/widgets/skill_category_filters.dart';
import 'package:profile/features/skills/presentation/widgets/skill_search_bar.dart';
import 'package:profile/features/skills/presentation/widgets/skills_empty_state.dart';
import 'package:profile/features/skills/presentation/widgets/skills_header.dart';
import 'package:profile/core/theme/app_theme.dart';

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
    testWidgets('empty search result names the search, not a category',
        (tester) async {
      await tester
          .pumpWidget(_wrap(SkillsEmptyState(onShowAll: () {}, query: ' 5G ')));
      expect(find.text('No skills match “5G”'), findsOneWidget);
      await tester.pumpWidget(_wrap(SkillsEmptyState(onShowAll: () {})));
      expect(find.text('No skills in this category yet'), findsOneWidget);
    });

    testWidgets('SkillsHeader renders title, disciplines text, and badge',
        (tester) async {
      await tester.pumpWidget(_wrap(const SkillsHeader(isDesktop: true)));
      await tester.pumpAndSettle();

      expect(find.text('Skills'), findsOneWidget);
      expect(find.textContaining('What I work with and where I used it'),
          findsOneWidget);
    });

    test('Skills header copy is translated in every supported locale',
        () async {
      final english = await AppLocalizations.delegate.load(const Locale('en'));
      expect(english.skillsHeaderTitle, 'Skills');

      final arabic = await AppLocalizations.delegate.load(const Locale('ar'));
      expect(arabic.skillsHeaderTitle, 'المهارات');
      expect(arabic.skillsHeaderSubtitle, contains('ابحث'));

      final czech = await AppLocalizations.delegate.load(const Locale('cs'));
      expect(czech.skillsHeaderTitle, 'Dovednosti');
      expect(czech.skillsHeaderSubtitle, contains('Vyhledejte'));
    });

    testWidgets(
        'SkillCategoryFilters renders categories and triggers selection',
        (tester) async {
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
              counts: const {
                'ALL': 7,
                'Mobile Systems': 5,
                'Security & Protocols': 2,
              },
            );
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('Mobile Systems'), findsOneWidget);
      await tester.tap(find.textContaining('Mobile Systems'));
      await tester.pumpAndSettle();

      expect(selected, 'Mobile Systems');
    });

    testWidgets('SkillsEmptyState renders and triggers onShowAll',
        (tester) async {
      bool resetTriggered = false;
      await tester.pumpWidget(_wrap(
        SkillsEmptyState(onShowAll: () => resetTriggered = true),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.filter_alt_off_rounded), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(resetTriggered, isTrue);
    });

    testWidgets(
        'SkillSearchBar renders search input, count badge, and clears text',
        (tester) async {
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
      expect(find.text('5 of 24 skills'), findsOneWidget);

      // Tap clear button
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(controller.text, '');
      expect(cleared, isTrue);
    });

    test('SkillCategoryStyle returns color and gradient for known categories',
        () {
      const scheme = ColorScheme.dark();
      final color = SkillCategoryStyle.getColor('Mobile Systems', scheme);
      expect(color, AppColors.teal);

      final gradient =
          SkillCategoryStyle.getGradient('Security & Protocols', scheme);
      expect(gradient.length, 2);
      expect(gradient.first, AppColors.gold);
    });
  });
}
