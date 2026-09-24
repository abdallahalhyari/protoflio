import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/util/career_facts.dart';

void main() {
  group('CareerFacts.yearsOfExperience', () {
    test('counts whole years only once the start month is reached', () {
      expect(CareerFacts.yearsOfExperience(DateTime(2026, 6, 30)), 4);
      expect(CareerFacts.yearsOfExperience(DateTime(2026, 7, 1)), 5);
      expect(CareerFacts.yearsOfExperience(DateTime(2026, 9, 24)), 5);
    });
  });
}
