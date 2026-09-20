import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/skills_data.dart';
import '../model/skill.dart';
import 'skills_filter_event.dart';
import 'skills_filter_state.dart';

class SkillsFilterBloc extends Bloc<SkillsFilterEvent, SkillsFilterState> {
  SkillsFilterBloc({List<Skill>? skills})
      : super(_createInitialState(skills ?? kSkills)) {
    on<SkillCategorySelected>(_onCategorySelected);
    on<SkillSearchQueryChanged>(_onSearchQueryChanged);
    on<SkillsFilterReset>(_onFilterReset);
  }

  static SkillsFilterState _createInitialState(List<Skill> allSkills) {
    return SkillsFilterState(
      allSkills: allSkills,
      selectedCategory: 'ALL',
      searchQuery: '',
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

    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      result = result.where((s) {
        final nameMatch = s.name.toLowerCase().contains(q);
        final catMatch = s.category.toLowerCase().contains(q);
        final descMatch = s.description.toLowerCase().contains(q);
        final provenMatch = s.provenIn.toLowerCase().contains(q);
        final tagsMatch = s.tags.any((t) => t.toLowerCase().contains(q));
        return nameMatch || catMatch || descMatch || provenMatch || tagsMatch;
      }).toList();
    }

    return result;
  }
}
