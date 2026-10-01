import 'dart:convert';
import 'package:profile/service/remote_data_service.dart';
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';

class LocalSkillRepository implements SkillRepository {
  List<Skill> _skills = [];

  Future<void> load() async {
    final jsonStr =
        await RemoteDataService.instance.fetchJson('assets/data/skills.json');
    final List<dynamic> jsonList = jsonDecode(jsonStr) as List<dynamic>;
    _skills =
        jsonList.map((e) => Skill.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Skill> getSkills() => _skills;

  @override
  int getSkillCount() => _skills.length;
}
