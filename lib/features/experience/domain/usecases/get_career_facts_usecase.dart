import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';

class GetCareerFactsUseCase implements UseCase<int, NoParams> {
  final ExperienceRepository repository;

  const GetCareerFactsUseCase(this.repository);

  @override
  int call(NoParams params) {
    return repository.getYearsOfExperience();
  }
}
