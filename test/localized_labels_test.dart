import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/features/engineering/data/architecture_data.dart';
import 'package:profile/features/engineering/data/architecture_labels.dart';
import 'package:profile/features/hats/data/hat_labels.dart';

import 'package:profile/features/skills/data/datasources/skill_category_labels.dart';

import 'package:profile/l10n/app_localizations.dart';

void main() {
  for (final code in ['ar', 'cs']) {
    final localized = lookupAppLocalizations(Locale(code));
    final english = lookupAppLocalizations(const Locale('en'));

    test('$code: refreshed page copy is fully localized', () {
      final localizedCopy = [
        localized.introRoleHeading,
        localized.introValueProposition,
        localized.introSkillArchitecture,
        localized.introSkillProductDelivery,
        localized.projectsHeaderKicker,
        localized.experienceHeaderKicker,
        localized.engineeringHeaderKicker,
        localized.hatsHeaderKickerMobile,
        localized.hatsHeaderKickerDesktop,
        localized.hatsHeaderSubtitle,
        localized.contactHeaderKicker,
        localized.contactHeaderTitle,
        localized.contactHeaderSubtitle,
      ];
      final englishCopy = [
        english.introRoleHeading,
        english.introValueProposition,
        english.introSkillArchitecture,
        english.introSkillProductDelivery,
        english.projectsHeaderKicker,
        english.experienceHeaderKicker,
        english.engineeringHeaderKicker,
        english.hatsHeaderKickerMobile,
        english.hatsHeaderKickerDesktop,
        english.hatsHeaderSubtitle,
        english.contactHeaderKicker,
        english.contactHeaderTitle,
        english.contactHeaderSubtitle,
      ];

      for (var index = 0; index < localizedCopy.length; index++) {
        expect(localizedCopy[index], isNotEmpty);
        expect(localizedCopy[index], isNot(englishCopy[index]));
      }
    });
  }

  // Labels fall back to the English key when unmapped, which silently
  // leaves English chips in the Arabic and Czech sites. Every category,
  // role and topic in the data must have a translation.
  for (final code in ['ar', 'cs']) {
    final l10n = lookupAppLocalizations(Locale(code));

    test('$code: every skill category is translated', () {
      final categories = {'ALL', ...testSkills.map((s) => s.category)};
      for (final c in categories) {
        expect(skillCategoryLabel(l10n, c), isNot(c), reason: c);
      }
    });

    test('$code: every perspective role is translated', () {
      for (final h in testHats) {
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
