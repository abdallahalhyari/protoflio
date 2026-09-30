import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';



/// web/index.html repeats the work history for crawlers and no-JS readers.
/// It drifted from the app (every date off by a month, two titles swapped)
/// while the CV said otherwise; keep the two in lockstep.
void main() {
  test('index.html work history matches the Experience section', () {
    final html = File('web/index.html').readAsStringSync();
    final jobs = testExperience.where((e) => e.company.isNotEmpty).toList();
    for (final e in jobs.where((e) => e.period.contains('/'))) {
      expect(
        html,
        contains('<strong>${e.role}</strong> at ${e.company} (${e.period})'),
        reason: '${e.company} in web/index.html',
      );
    }
  });

  // The case-study role lines and the crawler copy of them opened with the
  // old titles after the Experience section moved to the CV's.
  test('case-study roles open with the Experience title', () {
    final html = File('web/index.html').readAsStringSync();
    for (final p in testProjects) {
      final job = testExperience.firstWhere((e) => e.company == p.company);
      expect(p.role, startsWith(job.role), reason: '${p.company} role');
      if (p.company != 'NatHealth') {
        expect(
            html, contains('<strong>Role:</strong> ${job.role} (${p.company})'),
            reason: '${p.company} case study in web/index.html');
      }
    }
  });
}
