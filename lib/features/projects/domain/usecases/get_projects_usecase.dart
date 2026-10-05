import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/projects/domain/entities/project.dart';
import 'package:profile/features/projects/domain/repositories/project_repository.dart';

class GetProjectsUseCase implements UseCase<List<Project>, NoParams> {
  final ProjectRepository repository;

  const GetProjectsUseCase(this.repository);

  @override
  List<Project> call(NoParams params) {
    return repository.getProjects();
  }
}
