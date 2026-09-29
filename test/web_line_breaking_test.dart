import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  // Flutter web asks Intl.v8BreakIterator for line-break opportunities.
  // A polyfill built on Intl.Segmenter (which has no 'line' granularity)
  // returned word boundaries instead, so live text broke before commas and
  // after '(' — "leadership / , architectural audits". Keep it out.
  test('index.html does not replace Intl.v8BreakIterator', () {
    final html = File('web/index.html').readAsStringSync();
    expect(
      RegExp(r'Intl\.v8BreakIterator\s*=').hasMatch(html) ||
          RegExp(r"Intl\[\s*'v8BreakIterator'\s*\]\s*=").hasMatch(html),
      isFalse,
    );
  });
}
