import 'package:profile/features/skills/domain/entities/skill.dart';

abstract class SkillRepository {
  /// Returns all skills available.
  List<Skill> getSkills();

  /// Returns the total number of skills.
  int getSkillCount();
}
