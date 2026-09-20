import 'package:equatable/equatable.dart';
import 'package:profile/features/projects/model/project.dart';

class ProjectsFilterState extends Equatable {
  final List<Project> allProjects;
  final String selectedDomain;
  final String? selectedTech;
  final List<Project> filteredProjects;
  final Map<String, int> domainCounts;

  const ProjectsFilterState({
    required this.allProjects,
    this.selectedDomain = 'ALL',
    this.selectedTech,
    required this.filteredProjects,
    required this.domainCounts,
  });

  bool get hasActiveFilters => selectedDomain != 'ALL' || selectedTech != null;

  ProjectsFilterState copyWith({
    List<Project>? allProjects,
    String? selectedDomain,
    String? Function()? selectedTech,
    List<Project>? filteredProjects,
    Map<String, int>? domainCounts,
  }) {
    return ProjectsFilterState(
      allProjects: allProjects ?? this.allProjects,
      selectedDomain: selectedDomain ?? this.selectedDomain,
      selectedTech: selectedTech != null ? selectedTech() : this.selectedTech,
      filteredProjects: filteredProjects ?? this.filteredProjects,
      domainCounts: domainCounts ?? this.domainCounts,
    );
  }

  @override
  List<Object?> get props => [
        allProjects,
        selectedDomain,
        selectedTech,
        filteredProjects,
        domainCounts,
      ];
}
