import 'package:profile/features/experience/data/models/education_model.dart';
import 'package:profile/features/experience/data/models/experience_model.dart';
import 'package:profile/shared/utils/bundled_json.dart';

class ExperienceBundleData {
  final List<ExperienceModel> experiences;
  final List<EducationModel> education;
  final List<String> certifications;

  const ExperienceBundleData({
    required this.experiences,
    required this.education,
    required this.certifications,
  });
}

abstract class ExperienceLocalDataSource {
  Future<ExperienceBundleData> getBundledExperienceData();
}

class ExperienceLocalDataSourceImpl implements ExperienceLocalDataSource {
  const ExperienceLocalDataSourceImpl();

  @override
  Future<ExperienceBundleData> getBundledExperienceData() async {
    final [exp, edu, certs] = await Future.wait([
      loadBundledJsonList('assets/data/experience.json'),
      loadBundledJsonList('assets/data/education.json'),
      loadBundledJsonList('assets/data/certifications.json'),
    ]);

    final experiences = List<ExperienceModel>.unmodifiable(
      exp.map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>)),
    );
    final education = List<EducationModel>.unmodifiable(
      edu.map((e) => EducationModel.fromJson(e as Map<String, dynamic>)),
    );
    final certifications = List<String>.unmodifiable(certs.cast<String>());

    return ExperienceBundleData(
      experiences: experiences,
      education: education,
      certifications: certifications,
    );
  }
}
