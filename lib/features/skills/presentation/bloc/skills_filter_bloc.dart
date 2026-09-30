import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_event.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_state.dart';

class SkillsFilterBloc extends Bloc<SkillsFilterEvent, SkillsFilterState> {
  SkillsFilterBloc({required SkillRepository repository})
      : super(_createInitialState(repository.getSkills())) {
    on<SkillCategorySelected>(_onCategorySelected);
    on<SkillSearchQueryChanged>(_onSearchQueryChanged);
    on<SkillsFilterReset>(_onFilterReset);
  }

  static SkillsFilterState _createInitialState(List<Skill> allSkills) {
    return SkillsFilterState(
      allSkills: allSkills,
      filteredSkills: allSkills,
      categoryCounts: _computeCategoryCounts(allSkills),
    );
  }

  static Map<String, int> _computeCategoryCounts(List<Skill> skills) {
    final counts = <String, int>{'ALL': skills.length};
    for (final skill in skills) {
      counts[skill.category] = (counts[skill.category] ?? 0) + 1;
    }
    return counts;
  }

  void _onCategorySelected(
    SkillCategorySelected event,
    Emitter<SkillsFilterState> emit,
  ) {
    final filtered = _filter(
      state.allSkills,
      event.category,
      state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredSkills: filtered,
    ));
  }

  void _onSearchQueryChanged(
    SkillSearchQueryChanged event,
    Emitter<SkillsFilterState> emit,
  ) {
    final filtered = _filter(
      state.allSkills,
      state.selectedCategory,
      event.query,
    );
    emit(state.copyWith(
      searchQuery: event.query,
      filteredSkills: filtered,
    ));
  }

  void _onFilterReset(
    SkillsFilterReset event,
    Emitter<SkillsFilterState> emit,
  ) {
    emit(state.copyWith(
      selectedCategory: 'ALL',
      searchQuery: '',
      filteredSkills: state.allSkills,
    ));
  }

  static List<Skill> _filter(
    List<Skill> skills,
    String category,
    String query,
  ) {
    var result = category == 'ALL'
        ? skills
        : skills.where((s) => s.category == category).toList();

    // Every word must match somewhere on the skill, so recruiter-style
    // multi-word queries ("flutter bloc", "android security") narrow the
    // list instead of returning nothing because no one field contains
    // the whole phrase.
    final words = query
        .toLowerCase()
        .split(RegExp(r'[\s,]+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isNotEmpty) {
      result = result.where((s) {
        final haystack = [
          s.name,
          s.category,
          s.description,
          s.provenIn,
          ...s.tags,
        ].join(' ').toLowerCase();
        return words.every(haystack.contains);
      }).toList();
    }

    return result;
  }
}
