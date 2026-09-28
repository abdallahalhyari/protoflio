import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/experience/data/experience_data.dart';

/// web/index.html repeats the work history for crawlers and no-JS readers.
/// It drifted from the app (every date off by a month, two titles swapped)
/// while the CV said otherwise; keep the two in lockstep.
void main() {
  test('index.html work history matches the Experience section', () {
    final html = File('web/index.html').readAsStringSync();
    final jobs = kExperience.where((e) => e.company.isNotEmpty).toList();
    for (final e in jobs.where((e) => e.period.contains('/'))) {
      expect(
        html,
        contains('<strong>${e.role}</strong> at ${e.company} (${e.period})'),
        reason: '${e.company} in web/index.html',
      );
    }
  });
}
