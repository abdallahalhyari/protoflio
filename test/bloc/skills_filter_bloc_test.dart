import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_data.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_bloc.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_event.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_state.dart';

void main() {
  group('SkillsFilterBloc Test Suite', () {
    test('initial state contains all testSkills and default ALL category', () {
      final bloc = SkillsFilterBloc(repository: TestSkillRepository());
      expect(bloc.state.allSkills, equals(testSkills));
      expect(bloc.state.selectedCategory, equals('ALL'));
      expect(bloc.state.searchQuery, isEmpty);
      expect(bloc.state.filteredSkills.length, equals(testSkills.length));
      expect(bloc.state.categoryCounts['ALL'], equals(testSkills.length));
      expect(bloc.state.hasActiveFilter, isFalse);
    });

    test('SkillCategorySelected narrows skills to specified category',
        () async {
      final bloc = SkillsFilterBloc(repository: TestSkillRepository());

      bloc.add(const SkillCategorySelected('Mobile Systems'));
      await expectLater(
        bloc.stream,
        emits(predicate<SkillsFilterState>((state) =>
            state.selectedCategory == 'Mobile Systems' &&
            state.hasActiveFilter &&
            state.filteredSkills.every((s) => s.category == 'Mobile Systems'))),
      );

      await bloc.close();
    });

    test('SkillSearchQueryChanged filters skills across name and tags',
        () async {
      final bloc = SkillsFilterBloc(repository: TestSkillRepository());

      bloc.add(const SkillSearchQueryChanged('NFC'));
      await expectLater(
        bloc.stream,
        emits(predicate<SkillsFilterState>((state) =>
            state.searchQuery == 'NFC' &&
            state.hasActiveFilter &&
            state.filteredSkills.any((s) => s.name.contains('NFC')))),
      );

      await bloc.close();
    });

    test('SkillsFilterReset restores all skills and clears filters', () async {
      final bloc = SkillsFilterBloc(repository: TestSkillRepository());

      bloc.add(const SkillCategorySelected('Security & Protocols'));
      await expectLater(
        bloc.stream,
        emits(predicate<SkillsFilterState>(
            (state) => state.selectedCategory == 'Security & Protocols')),
      );

      bloc.add(const SkillsFilterReset());
      await expectLater(
        bloc.stream,
        emits(predicate<SkillsFilterState>((state) =>
            state.selectedCategory == 'ALL' &&
            state.searchQuery.isEmpty &&
            state.filteredSkills.length == testSkills.length)),
      );

      await bloc.close();
    });
  });

  test('multi-word search matches words across fields, not one phrase',
      () async {
    final bloc = SkillsFilterBloc(repository: TestSkillRepository());
    bloc.add(const SkillSearchQueryChanged('flutter dart'));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.filteredSkills, isNotEmpty);
    expect(
      bloc.state.filteredSkills.any((s) => s.name.contains('Flutter')),
      isTrue,
    );

    bloc.add(const SkillSearchQueryChanged('flutter zzzz-not-a-skill'));
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.filteredSkills, isEmpty);
    await bloc.close();
  });
}
