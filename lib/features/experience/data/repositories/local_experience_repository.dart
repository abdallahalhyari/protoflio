import 'package:profile/features/experience/domain/entities/experience.dart';
import 'package:profile/features/experience/domain/repositories/experience_repository.dart';
import 'package:profile/shared/util/bundled_json.dart';
import 'package:profile/shared/util/career_facts.dart';

class LocalExperienceRepository implements ExperienceRepository {
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _certifications = [];

  /// The three files load in parallel (they used to load one after
  /// another, three round trips before the first frame).
  Future<void> load() async {
    final [exp, edu, certs] = await Future.wait([
      loadBundledJsonList('assets/data/experience.json'),
      loadBundledJsonList('assets/data/education.json'),
      loadBundledJsonList('assets/data/certifications.json'),
    ]);
    _experiences = List.unmodifiable(
        exp.map((e) => Experience.fromJson(e as Map<String, dynamic>)));
    _education = List.unmodifiable(
        edu.map((e) => Education.fromJson(e as Map<String, dynamic>)));
    _certifications = List.unmodifiable(certs.cast<String>());
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
