import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';
import 'package:profile/features/skills/domain/usecases/filter_skills_usecase.dart';
import 'package:profile/features/skills/domain/usecases/get_skills_usecase.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_event.dart';
import 'package:profile/features/skills/presentation/bloc/skills_filter_state.dart';

class SkillsFilterBloc extends Bloc<SkillsFilterEvent, SkillsFilterState> {
  final FilterSkillsUseCase _filterUseCase;

  SkillsFilterBloc({
    required SkillRepository repository,
    FilterSkillsUseCase filterUseCase = const FilterSkillsUseCase(),
  })  : _filterUseCase = filterUseCase,
        super(_createInitialState(repository.getSkills(), filterUseCase)) {
    _registerHandlers();
  }

  SkillsFilterBloc.withUseCases({
    required GetSkillsUseCase getSkillsUseCase,
    FilterSkillsUseCase filterUseCase = const FilterSkillsUseCase(),
  })  : _filterUseCase = filterUseCase,
        super(_createInitialState(
            getSkillsUseCase(const NoParams()), filterUseCase)) {
    _registerHandlers();
  }

  void _registerHandlers() {
    on<SkillCategorySelected>(_onCategorySelected);
    on<SkillSearchQueryChanged>(_onSearchQueryChanged);
    on<SkillsFilterReset>(_onFilterReset);
  }

  static SkillsFilterState _createInitialState(
    List<Skill> allSkills,
    FilterSkillsUseCase filterUseCase,
  ) {
    return SkillsFilterState(
      allSkills: allSkills,
      filteredSkills: allSkills,
      categoryCounts: filterUseCase.computeCategoryCounts(allSkills),
    );
  }

  void _onCategorySelected(
    SkillCategorySelected event,
    Emitter<SkillsFilterState> emit,
  ) {
    final filtered = _filterUseCase(
      FilterSkillsParams(
        allSkills: state.allSkills,
        category: event.category,
        query: state.searchQuery,
      ),
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
    final filtered = _filterUseCase(
      FilterSkillsParams(
        allSkills: state.allSkills,
        category: state.selectedCategory,
        query: event.query,
      ),
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
}
