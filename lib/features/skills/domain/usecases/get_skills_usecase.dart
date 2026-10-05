import 'package:profile/core/usecases/usecase.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';

class GetSkillsUseCase implements UseCase<List<Skill>, NoParams> {
  final SkillRepository repository;

  const GetSkillsUseCase(this.repository);

  @override
  List<Skill> call(NoParams params) {
    return repository.getSkills();
  }
}
