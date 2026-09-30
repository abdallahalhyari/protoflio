import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/engineering/data/architecture_data.dart';
import 'package:profile/features/engineering/data/architecture_labels.dart';
import 'package:profile/features/hats/data/hat_labels.dart';
import 'package:profile/features/hats/data/hats_data.dart';
import 'package:profile/features/skills/data/skill_category_labels.dart';
import 'package:profile/features/skills/data/skills_data.dart';
import 'package:profile/l10n/app_localizations.dart';

void main() {
  // Labels fall back to the English key when unmapped, which silently
  // leaves English chips in the Arabic and Czech sites. Every category,
  // role and topic in the data must have a translation.
  for (final code in ['ar', 'cs']) {
    final l10n = lookupAppLocalizations(Locale(code));

    test('$code: every skill category is translated', () {
      final categories = {'ALL', ...kSkills.map((s) => s.category)};
      for (final c in categories) {
        expect(skillCategoryLabel(l10n, c), isNot(c), reason: c);
      }
    });

    test('$code: every perspective role is translated', () {
      for (final h in kHats) {
        expect(hatTitleLabel(l10n, h.title), isNot(h.title), reason: h.title);
      }
    });

    test('$code: every architecture topic is translated', () {
      for (final t in kArchitectureTopics) {
        expect(architectureTopicLabel(l10n, t.title), isNot(t.title),
            reason: t.title);
      }
    });
  }
}
