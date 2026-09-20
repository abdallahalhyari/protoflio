import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/skills/bloc/skills_filter_bloc.dart';
import 'package:profile/features/skills/bloc/skills_filter_event.dart';
import 'package:profile/features/skills/bloc/skills_filter_state.dart';
import 'package:profile/features/skills/data/skills_data.dart';

void main() {
  group('SkillsFilterBloc Test Suite', () {
    test('initial state contains all kSkills and default ALL category', () {
      final bloc = SkillsFilterBloc();
      expect(bloc.state.allSkills, equals(kSkills));
      expect(bloc.state.selectedCategory, equals('ALL'));
      expect(bloc.state.searchQuery, isEmpty);
      expect(bloc.state.filteredSkills.length, equals(kSkills.length));
      expect(bloc.state.categoryCounts['ALL'], equals(kSkills.length));
      expect(bloc.state.hasActiveFilter, isFalse);
    });

    test('SkillCategorySelected narrows skills to specified category',
        () async {
      final bloc = SkillsFilterBloc();

      bloc.add(const SkillCategorySelected('Mobile Systems'));
      await expectLater(
        bloc.stream,
        emits(predicate<SkillsFilterState>((state) =>
            state.selectedCategory == 'Mobile Systems' &&
            state.hasActiveFilter == true &&
            state.filteredSkills.every((s) => s.category == 'Mobile Systems'))),
      );

      await bloc.close();
    });

    test('SkillSearchQueryChanged filters skills across name and tags',
        () async {
      final bloc = SkillsFilterBloc();

      bloc.add(const SkillSearchQueryChanged('NFC'));
      await expectLater(
        bloc.stream,
        emits(predicate<SkillsFilterState>((state) =>
            state.searchQuery == 'NFC' &&
            state.hasActiveFilter == true &&
            state.filteredSkills.any((s) => s.name.contains('NFC')))),
      );

      await bloc.close();
    });

    test('SkillsFilterReset restores all skills and clears filters', () async {
      final bloc = SkillsFilterBloc();

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
            state.filteredSkills.length == kSkills.length)),
      );

      await bloc.close();
    });
  });
}
