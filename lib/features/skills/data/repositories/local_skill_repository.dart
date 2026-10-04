import 'package:profile/features/skills/data/datasources/skill_local_data_source.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';

class LocalSkillRepository implements SkillRepository {
  final SkillLocalDataSource dataSource;
  List<Skill> _skills = [];

  LocalSkillRepository([SkillLocalDataSource? dataSource])
      : dataSource = dataSource ?? const SkillLocalDataSourceImpl();

  Future<void> load() async {
    _skills = await dataSource.getBundledSkills();
  }

  @override
  List<Skill> getSkills() => _skills;

  @override
  int getSkillCount() => _skills.length;
}
