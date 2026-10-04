import 'package:profile/features/projects/data/models/project_model.dart';
import 'package:profile/shared/utils/bundled_json.dart';

abstract class ProjectLocalDataSource {
  Future<List<ProjectModel>> getBundledProjects();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  const ProjectLocalDataSourceImpl();

  @override
  Future<List<ProjectModel>> getBundledProjects() async {
    final list = await loadBundledJsonList('assets/data/projects.json');
    return List.unmodifiable(
      list.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)),
    );
  }
}
