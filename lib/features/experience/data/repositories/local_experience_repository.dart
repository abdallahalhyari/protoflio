import 'dart:convert';
import 'package:profile/service/remote_data_service.dart';
import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/shared/util/career_facts.dart';

class LocalExperienceRepository implements ExperienceRepository {
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _certifications = [];

  Future<void> load() async {
    final expJson = await RemoteDataService.instance
        .fetchJson('assets/data/experience.json');
    final List<dynamic> expList = jsonDecode(expJson) as List<dynamic>;
    _experiences = expList
        .map((e) => Experience.fromJson(e as Map<String, dynamic>))
        .toList();

    final eduJson = await RemoteDataService.instance
        .fetchJson('assets/data/education.json');
    final List<dynamic> eduList = jsonDecode(eduJson) as List<dynamic>;
    _education = eduList
        .map((e) => Education.fromJson(e as Map<String, dynamic>))
        .toList();

    final certJson = await RemoteDataService.instance
        .fetchJson('assets/data/certifications.json');
    final List<dynamic> certList = jsonDecode(certJson) as List<dynamic>;
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
