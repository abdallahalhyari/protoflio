import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every place that links to the personal profiles must use the same
/// canonical URL. The mobile menu once pointed at different LinkedIn and
/// GitHub handles than the rest of the site.
void main() {
  const linkedIn = 'https://www.linkedin.com/in/abdallah-alhyari-0294791a0/';
  const gitHub = 'https://github.com/abdallahalhyari';

  List<File> sources() => [
        ...Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart')),
        File('web/index.html'),
      ];

  test('personal LinkedIn links are all the canonical profile', () {
    final rx = RegExp(r'https://(www\.)?linkedin\.com/in/[A-Za-z0-9_-]+/?');
    final offenders = <String>[];
    for (final f in sources()) {
      for (final m in rx.allMatches(f.readAsStringSync())) {
        if (m.group(0) != linkedIn) offenders.add('${f.path}: ${m.group(0)}');
      }
    }
    expect(offenders, isEmpty);
  });

  test('personal GitHub links are all the canonical profile', () {
    final rx = RegExp(r'https://(www\.)?github\.com/[A-Za-z0-9_-]+');
    final offenders = <String>[];
    for (final f in sources()) {
      for (final m in rx.allMatches(f.readAsStringSync())) {
        if (m.group(0) != gitHub) offenders.add('${f.path}: ${m.group(0)}');
      }
    }
    expect(offenders, isEmpty);
  });
}
