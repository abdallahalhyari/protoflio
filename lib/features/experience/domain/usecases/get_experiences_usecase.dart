import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';

class GetExperiencesUseCase implements UseCase<List<Experience>, NoParams> {
  final ExperienceRepository repository;

  const GetExperiencesUseCase(this.repository);

  @override
  List<Experience> call(NoParams params) {
    return repository.getExperiences();
  }
}
