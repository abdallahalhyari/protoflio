import 'package:profile/features/experience/domain/entities/experience.dart';

/// Data Transfer Object for [Education], handling JSON parsing and serialization.
class EducationModel extends Education {
  const EducationModel({
    required super.degree,
    required super.institution,
    required super.period,
    super.note,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      period: json['period'] as String,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'institution': institution,
      'period': period,
      if (note != null) 'note': note,
    };
  }
}
