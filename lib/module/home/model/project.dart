class Project {
  final String name;
  final String company;
  final String tagline;
  final List<String> highlights;
  final List<String> stack;
  final String? url;

  const Project({
    required this.name,
    required this.company,
    required this.tagline,
    required this.highlights,
    required this.stack,
    this.url,
  });
}
