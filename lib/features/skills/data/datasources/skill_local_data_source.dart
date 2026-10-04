import 'package:profile/features/skills/data/models/skill_model.dart';
import 'package:profile/shared/utils/bundled_json.dart';

abstract class SkillLocalDataSource {
  Future<List<SkillModel>> getBundledSkills();
}

class SkillLocalDataSourceImpl implements SkillLocalDataSource {
  const SkillLocalDataSourceImpl();

  @override
  Future<List<SkillModel>> getBundledSkills() async {
    final list = await loadBundledJsonList('assets/data/skills.json');
    return List.unmodifiable(
      list.map((e) => SkillModel.fromJson(e as Map<String, dynamic>)),
    );
  }
}
