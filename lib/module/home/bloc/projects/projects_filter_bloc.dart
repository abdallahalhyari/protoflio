import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/projects_data.dart';
import '../../model/project.dart';
import 'projects_filter_event.dart';
import 'projects_filter_state.dart';

class ProjectsFilterBloc
    extends Bloc<ProjectsFilterEvent, ProjectsFilterState> {
  ProjectsFilterBloc({List<Project>? initialProjects})
      : super(_createInitialState(initialProjects ?? kProjects)) {
    on<ProjectsFilterStarted>(_onStarted);
    on<DomainFilterSelected>(_onDomainSelected);
    on<TechFilterToggled>(_onTechToggled);
    on<ProjectsFilterReset>(_onReset);
  }

  static ProjectsFilterState _createInitialState(List<Project> projects) {
    return ProjectsFilterState(
      allProjects: projects,
      selectedDomain: 'ALL',
      selectedTech: null,
      filteredProjects: List.unmodifiable(projects),
      domainCounts: _calculateCounts(projects),
    );
  }

  static Map<String, int> _calculateCounts(List<Project> projects) {
    final counts = <String, int>{'ALL': projects.length};
    for (final p in projects) {
      counts[p.domain] = (counts[p.domain] ?? 0) + 1;
    }
    return Map.unmodifiable(counts);
  }

  static List<Project> _filter(
    List<Project> all,
    String domain,
    String? tech,
  ) {
    return all.where((p) {
      final domainMatch = domain == 'ALL' || p.domain == domain;
      final techMatch = tech == null || p.stack.contains(tech);
      return domainMatch && techMatch;
    }).toList();
  }

  void _onStarted(
    ProjectsFilterStarted event,
    Emitter<ProjectsFilterState> emit,
  ) {
    final projects = event.initialProjects ?? state.allProjects;
    emit(_createInitialState(projects));
  }

  void _onDomainSelected(
    DomainFilterSelected event,
    Emitter<ProjectsFilterState> emit,
  ) {
    if (state.selectedDomain == event.domain) return;
    final filtered = _filter(state.allProjects, event.domain, state.selectedTech);
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
    final filtered = _filter(state.allProjects, state.selectedDomain, nextTech);
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
