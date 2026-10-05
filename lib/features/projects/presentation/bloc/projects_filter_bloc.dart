import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';
import 'package:profile/features/projects/domain/usecases/filter_projects_usecase.dart';
import 'package:profile/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_event.dart';
import 'package:profile/features/projects/presentation/bloc/projects_filter_state.dart';

class ProjectsFilterBloc
    extends Bloc<ProjectsFilterEvent, ProjectsFilterState> {
  final FilterProjectsUseCase _filterUseCase;

  ProjectsFilterBloc({
    required ProjectRepository repository,
    FilterProjectsUseCase filterUseCase = const FilterProjectsUseCase(),
  })  : _filterUseCase = filterUseCase,
        super(_createInitialState(repository.getProjects(), filterUseCase)) {
    _registerHandlers();
  }

  ProjectsFilterBloc.withUseCases({
    required GetProjectsUseCase getProjectsUseCase,
    FilterProjectsUseCase filterUseCase = const FilterProjectsUseCase(),
  })  : _filterUseCase = filterUseCase,
        super(_createInitialState(
            getProjectsUseCase(const NoParams()), filterUseCase)) {
    _registerHandlers();
  }

  void _registerHandlers() {
    on<DomainFilterSelected>(_onDomainSelected);
    on<TechFilterToggled>(_onTechToggled);
    on<ProjectsFilterReset>(_onReset);
  }

  static ProjectsFilterState _createInitialState(
    List<Project> projects,
    FilterProjectsUseCase filterUseCase,
  ) {
    return ProjectsFilterState(
      allProjects: projects,
      filteredProjects: List.unmodifiable(projects),
      domainCounts: filterUseCase.computeDomainCounts(projects),
    );
  }

  void _onDomainSelected(
    DomainFilterSelected event,
    Emitter<ProjectsFilterState> emit,
  ) {
    if (state.selectedDomain == event.domain) return;
    final filtered = _filterUseCase(
      FilterProjectsParams(
        allProjects: state.allProjects,
        domain: event.domain,
        tech: state.selectedTech,
      ),
    );
    emit(state.copyWith(
      selectedDomain: event.domain,
      filteredProjects: filtered,
    ));
  }

  void _onTechToggled(
    TechFilterToggled event,
    Emitter<ProjectsFilterState> emit,
  ) {
    final nextTech = state.selectedTech == event.tech ? null : event.tech;
    final filtered = _filterUseCase(
      FilterProjectsParams(
        allProjects: state.allProjects,
        domain: state.selectedDomain,
        tech: nextTech,
      ),
    );
    emit(state.copyWith(
      selectedTech: () => nextTech,
      filteredProjects: filtered,
    ));
  }

  void _onReset(
    ProjectsFilterReset event,
    Emitter<ProjectsFilterState> emit,
  ) {
    emit(state.copyWith(
      selectedDomain: 'ALL',
      selectedTech: () => null,
      filteredProjects: List.unmodifiable(state.allProjects),
    ));
  }
}
