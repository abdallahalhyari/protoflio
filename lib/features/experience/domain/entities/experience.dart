class Experience {
  final String role;
  final String company;
  final String period;
  final List<String> highlights;
  final String? websiteUrl;
  final String? linkedinUrl;

  const Experience({
    required this.role,
    required this.company,
    required this.period,
    required this.highlights,
    this.websiteUrl,
    this.linkedinUrl,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      role: json['role'] as String,
      company: json['company'] as String,
      period: json['period'] as String,
      highlights: (json['highlights'] as List).map((e) => e as String).toList(),
      websiteUrl: json['websiteUrl'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'company': company,
      'period': period,
      'highlights': highlights,
      if (websiteUrl != null) 'websiteUrl': websiteUrl,
      if (linkedinUrl != null) 'linkedinUrl': linkedinUrl,
    };
  }
}

class Education {
  final String degree;
  final String institution;
  final String period;
  final String? note;

  const Education({
    required this.degree,
    required this.institution,
    required this.period,
    this.note,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
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
