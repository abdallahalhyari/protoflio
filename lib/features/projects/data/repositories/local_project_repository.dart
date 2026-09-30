import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';

class LocalProjectRepository implements ProjectRepository {
  List<Project> _projects = [];

  Future<void> load() async {
    final jsonStr = await rootBundle.loadString('assets/data/projects.json');
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    _projects = jsonList.map((e) => Project.fromJson(e)).toList();
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
