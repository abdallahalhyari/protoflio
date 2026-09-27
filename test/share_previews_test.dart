import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/case_study/case_study_router.dart';

/// Pixel size of a PNG (IHDR) or baseline/progressive JPEG (SOFn).
(int, int) _imageSize(String path) {
  final b = File(path).readAsBytesSync();
  final data = ByteData.sublistView(b);
  if (b[0] == 0x89 && b[1] == 0x50) {
    return (data.getUint32(16), data.getUint32(20));
  }
  var i = 2;
  while (i < b.length) {
    final marker = b[i + 1];
    final length = data.getUint16(i + 2);
    final isSof = marker >= 0xC0 &&
        marker <= 0xCF &&
        marker != 0xC4 &&
        marker != 0xC8 &&
        marker != 0xCC;
    if (isSof) return (data.getUint16(i + 7), data.getUint16(i + 5));
    i += 2 + length;
  }
  throw StateError('no size in $path');
}

String? _meta(String html, String property) {
  final m = RegExp('<meta (?:property|name)="${RegExp.escape(property)}" '
          'content="([^"]*)"')
      .firstMatch(html);
  return m?.group(1);
}

/// Declared og:image dimensions match the image file actually served.
void _expectImageMatches(String html) {
  final url = _meta(html, 'og:image')!;
  final local = 'web/${url.replaceFirst('https://alhyari.web.app/', '')}';
  expect(File(local).existsSync(), isTrue, reason: '$local must exist');
  final (w, h) = _imageSize(local);
  expect('$w', _meta(html, 'og:image:width'), reason: '$local width');
  expect('$h', _meta(html, 'og:image:height'), reason: '$local height');
}

void main() {
  test('homepage preview image is the size its tags declare', () {
    _expectImageMatches(File('web/index.html').readAsStringSync());
  });

  for (final slug in CaseStudyRouter.slugToCompany.keys) {
    test('share page for $slug previews the study and opens it', () {
      final file = File('web/work/$slug/index.html');
      expect(file.existsSync(), isTrue,
          reason: 'run python3 tool/make_og_cards.py');
      final html = file.readAsStringSync();
      expect(_meta(html, 'og:url'), 'https://alhyari.web.app/work/$slug/');
      expect(_meta(html, 'og:title'), contains('Case Study'));
      expect(_meta(html, 'og:description'), isNotEmpty);
      expect(html, contains("#work/$slug')"));
      _expectImageMatches(html);
      // Per the owner: no Twitter/X tags anywhere (see seo_audit_test).
      expect(html.toLowerCase(), isNot(contains('twitter')));
    });
  }
}
