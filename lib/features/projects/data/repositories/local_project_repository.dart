import 'package:profile/features/projects/data/datasources/project_local_data_source.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';

class LocalProjectRepository implements ProjectRepository {
  final ProjectLocalDataSource dataSource;
  List<Project> _projects = [];

  LocalProjectRepository([ProjectLocalDataSource? dataSource])
      : dataSource = dataSource ?? const ProjectLocalDataSourceImpl();

  Future<void> load() async {
    _projects = await dataSource.getBundledProjects();
  }

  @override
  List<Project> getProjects() => _projects;

  @override
  Project? getProjectByIndex(int index) {
    if (index >= 0 && index < _projects.length) {
      return _projects[index];
    }
    return null;
  }

  @override
  int getProjectCount() => _projects.length;
}
