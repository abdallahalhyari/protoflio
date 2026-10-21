import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/test_data.dart';
import 'package:profile/features/engineering/data/datasources/architecture_data.dart';
import 'package:profile/features/engineering/presentation/utils/architecture_labels.dart';

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
        localized.introSummary,
        localized.introAvailability,
        localized.traceTitle,
        localized.introSkillArchitecture,
        localized.introSkillProductDelivery,
        localized.studyProblem,
        localized.studyArchitecture,
        localized.studyBuilt,
        localized.projectDossierDecision,
        localized.studyLessons,
        localized.quickProfile,
        localized.quickProfileVcard,
        localized.vcardDialogTitle,
        localized.vcardScanHint,
        localized.vcardCopyText,
        localized.vcardCopied,
        localized.done,
        localized.changeLanguage,
        localized.changeLanguageCurrent('AR'),
        localized.switchToLightMode,
        localized.switchToDarkMode,
        localized.muteSoundEffects,
        localized.enableSoundEffects,
        localized.soundEffectsOnTooltip,
        localized.soundEffectsMutedTooltip,
        localized.openNavigationMenu,
        localized.menuLabel,
        localized.sectionNavigationLabel,
        localized.downloadResumePdf,
        localized.previousSection,
        localized.nextSection,
        localized.scrollToTop,
        localized.goToSection(localized.navHome),
        localized.pageNumber(1),
        localized.contactHeaderTitle,
        localized.contactHeaderSubtitle,
      ];
      final englishCopy = [
        english.introSeniorEngineer,
        english.introSummary,
        english.introAvailability,
        english.traceTitle,
        english.introSkillArchitecture,
        english.introSkillProductDelivery,
        english.studyProblem,
        english.studyArchitecture,
        english.studyBuilt,
        english.projectDossierDecision,
        english.studyLessons,
        english.quickProfile,
        english.quickProfileVcard,
        english.vcardDialogTitle,
        english.vcardScanHint,
        english.vcardCopyText,
        english.vcardCopied,
        english.done,
        english.changeLanguage,
        english.changeLanguageCurrent('AR'),
        english.switchToLightMode,
        english.switchToDarkMode,
        english.muteSoundEffects,
        english.enableSoundEffects,
        english.soundEffectsOnTooltip,
        english.soundEffectsMutedTooltip,
        english.openNavigationMenu,
        english.menuLabel,
        english.sectionNavigationLabel,
        english.downloadResumePdf,
        english.previousSection,
        english.nextSection,
        english.scrollToTop,
        english.goToSection(english.navHome),
        english.pageNumber(1),
        english.contactHeaderTitle,
        english.contactHeaderSubtitle,
      ];

      for (var index = 0; index < localizedCopy.length; index++) {
        expect(localizedCopy[index], isNotEmpty);
        expect(localizedCopy[index], isNot(englishCopy[index]));
      }
    });

    test('$code: project card copy, titles and badges are localized', () {
      final english = lookupAppLocalizations(const Locale('en'));
      for (final project in testProjects) {
        expect(
          localizedProjectTagline(localized, project),
          isNot(localizedProjectTagline(english, project)),
          reason: project.company,
        );
        final locOutcome = localizedProjectOutcome(localized, project);
        final engOutcome = localizedProjectOutcome(english, project);
        if (locOutcome != null && engOutcome != null) {
          expect(locOutcome, isNot(engOutcome), reason: project.company);
        }
      }

      for (final project in testProjects) {
        expect(
          localizedProjectName(localized, project),
          isNot(localizedProjectName(english, project)),
          reason: project.company,
        );
        expect(
          localizedProjectMetricBadge(localized, project),
          isNot(localizedProjectMetricBadge(english, project)),
          reason: project.company,
        );
      }
    });
  }

  for (final code in ['ar', 'cs']) {
    final l10n = lookupAppLocalizations(Locale(code));

    test('$code: every skill category is translated', () {
      final categories = {'ALL', ...testSkills.map((s) => s.category)};
      for (final c in categories) {
        expect(skillCategoryLabel(l10n, c), isNot(c), reason: c);
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
