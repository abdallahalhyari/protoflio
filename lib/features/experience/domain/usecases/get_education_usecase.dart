import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';

class GetEducationUseCase implements UseCase<List<Education>, NoParams> {
  final ExperienceRepository repository;

  const GetEducationUseCase(this.repository);

  @override
  List<Education> call(NoParams params) {
    return repository.getEducation();
  }
}
