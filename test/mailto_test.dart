import 'package:flutter_test/flutter_test.dart';
import 'package:profile/shared/util/mailto.dart';

void main() {
  test('mailtoUri percent-encodes spaces instead of form-encoding them', () {
    final uri = mailtoUri('a@b.com',
        subject: 'Senior Role — Inquiry & more', body: 'Hi,\nline two');
    final s = uri.toString();
    expect(s, startsWith('mailto:a@b.com?subject=Senior%20Role'));
    expect(s, isNot(contains('+')));
    expect(s, contains('%26%20more'));
    expect(s, contains('body=Hi%2C%0Aline%20two'));
  });

  test('mailtoUri omits empty parameters', () {
    expect(mailtoUri('a@b.com', body: '').toString(), 'mailto:a@b.com');
  });
}
