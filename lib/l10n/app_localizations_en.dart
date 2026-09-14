// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navWork => 'Work';

  @override
  String get navEngineering => 'Engineering';

  @override
  String get navExperience => 'Experience';

  @override
  String get navStack => 'Stack';

  @override
  String get navAbout => 'About';

  @override
  String get navContact => 'Contact';

  @override
  String get navResume => 'Resume';

  @override
  String get navSkills => 'Skills';

  @override
  String get navProjects => 'Projects';

  @override
  String get introLocation => 'Amman, Jordan → Brno, Czech Republic (2027)';

  @override
  String get sectionEducation => 'EDUCATION';

  @override
  String get sectionCertifications => 'CERTIFICATIONS';

  @override
  String get contactHeroEyebrow => 'DIRECT EMAIL · FASTEST REPLY';

  @override
  String get contactReplyWindow => 'Replies within 24 hours · English / Arabic';

  @override
  String get contactSendEmailBtn => 'SEND EMAIL';

  @override
  String get contactCopyAddressBtn => 'COPY ADDRESS';

  @override
  String get skillsEmptyTitle => 'No skills in this category yet';

  @override
  String get skillsEmptyShowAll => 'SHOW ALL';

  @override
  String get keyboardHintTitle => 'Keyboard shortcuts';

  @override
  String get keyboardHintDigits => '1–7   jump to section';

  @override
  String get keyboardHintArrows => '↑ ↓   prev / next page';

  @override
  String get keyboardHintHome => 'Home  first page';

  @override
  String get keyboardHintEnd => 'End   last page';

  @override
  String get closeTooltip => 'Close';

  @override
  String get showHelpShortcut => 'Show this help';

  @override
  String resumeOpenError(Object publicUrl) {
    return 'Could not open resume — visit $publicUrl';
  }

  @override
  String projectOpenError(Object url) {
    return 'Could not open $url';
  }

  @override
  String get spreadAction => 'SPREAD';

  @override
  String get alignAction => 'ALIGN';

  @override
  String get previousAction => 'PREV';

  @override
  String get nextAction => 'NEXT';

  @override
  String emailCopied(Object email) {
    return 'Email copied · $email';
  }

  @override
  String get viewMyWork => 'VIEW MY WORK';

  @override
  String get downloadResume => 'DOWNLOAD RESUME';

  @override
  String get contactMe => 'CONTACT ME';

  @override
  String get copyEmail => 'COPY EMAIL';
}
