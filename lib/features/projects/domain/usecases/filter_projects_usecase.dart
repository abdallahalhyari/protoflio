import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/projects/domain/entities/project.dart';

class FilterProjectsParams {
  final List<Project> allProjects;
  final String domain;
  final String? tech;

  const FilterProjectsParams({
    required this.allProjects,
    required this.domain,
    this.tech,
  });
}

class FilterProjectsUseCase
    implements UseCase<List<Project>, FilterProjectsParams> {
  const FilterProjectsUseCase();

  @override
  List<Project> call(FilterProjectsParams params) {
    return params.allProjects.where((p) {
      final domainMatch = params.domain == 'ALL' || p.domain == params.domain;
      final techMatch = params.tech == null || p.stack.contains(params.tech);
      return domainMatch && techMatch;
    }).toList();
  }

  Map<String, int> computeDomainCounts(List<Project> projects) {
    final counts = <String, int>{'ALL': projects.length};
    for (final p in projects) {
      counts[p.domain] = (counts[p.domain] ?? 0) + 1;
    }
    return Map.unmodifiable(counts);
  }
}
