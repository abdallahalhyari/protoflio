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
}
