import 'package:profile/features/projects/domain/entities/project.dart';

abstract class ProjectRepository {
  /// Returns all projects available in the portfolio.
  List<Project> getProjects();

  /// Returns a specific project by its index, or null if out of bounds.
  Project? getProjectByIndex(int index);

  /// Returns the total number of projects.
  int getProjectCount();
}
