/// Single source of truth for career facts quoted in prose across sections,
/// so the About bio and Contact lede never drift apart again.
abstract final class CareerFacts {
  /// First professional mobile role (Future Advanced Internet Solutions).
  static final DateTime careerStart = DateTime(2021, 7);

  /// Whole years elapsed since [careerStart] — rendered as "N+ years".
  static int yearsOfExperience([DateTime? now]) {
    final today = now ?? DateTime.now();
    var years = today.year - careerStart.year;
    if (today.month < careerStart.month) years--;
    return years;
  }
}
