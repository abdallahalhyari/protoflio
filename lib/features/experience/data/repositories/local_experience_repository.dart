import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/shared/util/career_facts.dart';

class LocalExperienceRepository implements ExperienceRepository {
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _certifications = [];

  Future<void> load() async {
    final expJson = await rootBundle.loadString('assets/data/experience.json');
    final List<dynamic> expList = jsonDecode(expJson);
    _experiences = expList.map((e) => Experience.fromJson(e)).toList();

    final eduJson = await rootBundle.loadString('assets/data/education.json');
    final List<dynamic> eduList = jsonDecode(eduJson);
    _education = eduList.map((e) => Education.fromJson(e)).toList();

    final certJson = await rootBundle.loadString('assets/data/certifications.json');
    final List<dynamic> certList = jsonDecode(certJson);
    _certifications = certList.map((e) => e as String).toList();
  }

  @override
  List<Experience> getExperiences() => _experiences;

  @override
  List<Education> getEducation() => _education;

  @override
  List<String> getCertifications() => _certifications;

  @override
  int getYearsOfExperience() => CareerFacts.yearsOfExperience();
}
