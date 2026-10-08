import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/features/engineering/data/datasources/architecture_data.dart';
import 'package:profile/features/engineering/presentation/utils/architecture_labels.dart';
import 'package:profile/features/hats/presentation/utils/hat_labels.dart';

import 'package:profile/features/skills/presentation/utils/skill_category_labels.dart';
import 'package:profile/features/projects/presentation/utils/project_copy.dart';

import 'package:profile/l10n/app_localizations.dart';

void main() {
  for (final code in ['ar', 'cs']) {
    final localized = lookupAppLocalizations(Locale(code));
    final english = lookupAppLocalizations(const Locale('en'));

    test('$code: refreshed page copy is fully localized', () {
      final localizedCopy = [
        localized.introSeniorEngineer,
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
        localized.skillMasteryLead,
        localized.skillMasteryCore,
        localized.skillMasterySolid,
        localized.skillMasteryGrowing,
        localized.skillCardSemantics('Flutter', localized.skillMasteryLead),
      ];
      final englishCopy = [
        english.introSeniorEngineer,
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
        english.skillMasteryLead,
        english.skillMasteryCore,
        english.skillMasterySolid,
        english.skillMasteryGrowing,
        english.skillCardSemantics('Flutter', english.skillMasteryLead),
      ];

      for (var index = 0; index < localizedCopy.length; index++) {
        expect(localizedCopy[index], isNotEmpty);
        expect(localizedCopy[index], isNot(englishCopy[index]));
      }
    });

    test('$code: project card summaries and domain filters are localized', () {
      final english = lookupAppLocalizations(const Locale('en'));
      for (final project in testProjects) {
        expect(
          localizedProjectTagline(localized, project),
          isNot(localizedProjectTagline(english, project)),
          reason: project.company,
        );
        expect(
          localizedProjectOutcome(localized, project),
          isNot(localizedProjectOutcome(english, project)),
          reason: project.company,
        );
      }

      const domains = [
        'ALL',
        'Healthcare & Smart Cards',
        'Enterprise HIS & LMS',
        'Fleet & Telematics',
        'M-Commerce & Streaming',
      ];
      for (final domain in domains) {
        expect(localizedProjectDomain(localized, domain), isNot(domain));
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
