import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:profile/features/skills/domain/entities/skill.dart';
import 'package:profile/features/skills/domain/repositories/skill_repository.dart';

class LocalSkillRepository implements SkillRepository {
  List<Skill> _skills = [];

  Future<void> load() async {
    final jsonStr = await rootBundle.loadString('assets/data/skills.json');
    final List<dynamic> jsonList = jsonDecode(jsonStr);
    _skills = jsonList.map((e) => Skill.fromJson(e)).toList();
  }

  @override
  List<Skill> getSkills() => _skills;

  @override
  int getSkillCount() => _skills.length;
}
