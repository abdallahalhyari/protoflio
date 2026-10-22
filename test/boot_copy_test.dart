import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The HTML boot screen is a still of the cover, so its words must be the
/// cover's words: a changed sentence in the app that the boot screen still
/// shows the old way would swap mid-fade.
void main() {
  final html = File('web/index.html').readAsStringSync();
  Map<String, dynamic> arb(String code) =>
      jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync())
          as Map<String, dynamic>;

  // Boot screen slot → the app string it repeats.
  const slots = {
    'summary': 'introSummary',
    'availability': 'introAvailability',
    'work': 'viewMyWork',
    'email': 'introEmailMe',
    'cv': 'introDownloadResume',
  };

  test('English boot screen repeats the cover strings', () {
    final en = arb('en');
    for (final MapEntry(key: slot, value: key) in slots.entries) {
      expect(
        html,
        contains('data-boot="$slot">${en[key]}<'),
        reason: '$slot should read "${en[key]}"',
      );
    }
  });

  for (final code in ['cs', 'ar']) {
    test('$code boot copy repeats the cover strings', () {
      final strings = arb(code);
      final block = RegExp('\\n\\s*$code: \\{([\\s\\S]*?)\\n\\s*\\}')
          .firstMatch(html)
          ?.group(1);
      expect(block, isNotNull, reason: 'no $code block in the boot copy');
      for (final MapEntry(key: slot, value: key) in slots.entries) {
        expect(
          block,
          contains("$slot: '${strings[key]}'"),
          reason: '$code $slot should read "${strings[key]}"',
        );
      }
    });
  }
}
