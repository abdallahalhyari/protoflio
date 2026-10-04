import 'package:profile/shared/utils/bundled_json.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';

class LocalProjectRepository implements ProjectRepository {
  List<Project> _projects = [];

  Future<void> load() async {
    final list = await loadBundledJsonList('assets/data/projects.json');
    _projects = List.unmodifiable(
        list.map((e) => Project.fromJson(e as Map<String, dynamic>)));
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
