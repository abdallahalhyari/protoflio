import 'dart:convert';
import 'package:profile/service/remote_data_service.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';

class LocalProjectRepository implements ProjectRepository {
  List<Project> _projects = [];

  Future<void> load() async {
    final jsonStr =
        await RemoteDataService.instance.fetchJson('assets/data/projects.json');
    final List<dynamic> jsonList = jsonDecode(jsonStr) as List<dynamic>;
    _projects = jsonList
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
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
