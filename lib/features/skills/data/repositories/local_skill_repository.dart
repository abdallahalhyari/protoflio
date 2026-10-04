import 'package:profile/shared/utils/bundled_json.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';

class LocalSkillRepository implements SkillRepository {
  List<Skill> _skills = [];

  Future<void> load() async {
    final list = await loadBundledJsonList('assets/data/skills.json');
    _skills = List.unmodifiable(
        list.map((e) => Skill.fromJson(e as Map<String, dynamic>)));
  }

  @override
  List<Skill> getSkills() => _skills;

  @override
  int getSkillCount() => _skills.length;
}
