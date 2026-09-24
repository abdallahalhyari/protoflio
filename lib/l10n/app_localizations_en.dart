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

  @override
  String get introSeniorEngineer => 'SENIOR MOBILE ENGINEER';

  @override
  String get introSystemArchitect => 'SYSTEM ARCHITECT';

  @override
  String get introEuEligibility => 'EU WORK ELIGIBILITY';

  @override
  String get introAvailableContracts => 'AVAILABLE FOR CONTRACTS';

  @override
  String get introMeticulouslyEngineered =>
      'A meticulously engineered portfolio.';

  @override
  String get contactEngagementScopes =>
      '// ENGAGEMENT SCOPES & COLLABORATION MODES';

  @override
  String get contactAtsVerified => 'ATS-VERIFIED · 2026 EDITION';

  @override
  String get contactPdfSize => 'PDF · 240 KB';

  @override
  String get contactCvDossierTitle =>
      'Executive Curriculum Vitae & Portfolio Dossier';

  @override
  String get contactCvDossierDesc =>
      'Complete chronological track record, enterprise architecture case studies, and engineering competencies.';

  @override
  String get contactDownloadCvPdf => 'DOWNLOAD CV · PDF';

  @override
  String get contactPreview => 'PREVIEW';

  @override
  String get footerRightsReserved => '© 2026 · ALL RIGHTS RESERVED';

  @override
  String get contactInitiateEncrypted => 'INITIATE ENCRYPTED THREAD';

  @override
  String get contactStartConversation => 'START A CONVERSATION';

  @override
  String get contactPhone => 'PHONE';

  @override
  String get contactCall => 'Call';

  @override
  String get contactWhatsapp => 'WHATSAPP';

  @override
  String get contactOpen => 'Open';

  @override
  String get contactCopy => 'Copy';

  @override
  String get contactLinkedin => 'LINKEDIN';

  @override
  String get contactProfile => 'Profile';

  @override
  String get contactGithub => 'GITHUB';

  @override
  String get contactVisit => 'Visit';

  @override
  String get semanticPortrait => 'Portrait of Abdallah Alhyari';

  @override
  String get semanticTitle => 'Abdallah Alhyari, Senior Mobile Engineer';

  @override
  String folioIndicator(Object current, Object total) {
    return 'FOLIO $current / $total';
  }

  @override
  String get blocSectionTitle => 'BLoC / CLEAN ARCHITECTURE';

  @override
  String get blocSectionSubtitle =>
      'Predictable state mutation via unidirectional data flow';

  @override
  String get blocStep1Title => 'Dispatch Event';

  @override
  String get blocStep1Desc =>
      'UI triggers an event. No business logic in widgets.';

  @override
  String get blocStep2Title => 'Map to State';

  @override
  String get blocStep2Desc =>
      'BLoC processes event, yields new immutable state.';

  @override
  String get blocStep3Title => 'Render Output';

  @override
  String get blocStep3Desc =>
      'UI efficiently rebuilds based on strict state diffs.';

  @override
  String get introIssueStrip => 'ISSUE 01 · PORTFOLIO EDITION · MMXXVI';

  @override
  String get introBuildsComplex =>
      'BUILDS COMPLEX, RELIABLE, SCALABLE MOBILE SYSTEMS';

  @override
  String get introTechStack =>
      'Flutter · Android · iOS · Architecture · Offline-first · NFC · Security · Real-time systems';

  @override
  String get introBasedIn => 'BASED IN';

  @override
  String get introStatus => 'STATUS';

  @override
  String get introOpenForRoles => 'OPEN FOR SENIOR ROLES';

  @override
  String get introDiscipline => 'DISCIPLINE';

  @override
  String get introMobileArch => 'MOBILE ARCHITECTURE';

  @override
  String get introMasthead => '// MASTHEAD';

  @override
  String get navSectionCover => 'COVER & PROFILE';

  @override
  String get navSubCover => 'Senior Flutter & Android Architect';

  @override
  String get navSectionExperience => 'CAREER & EXPERIENCE';

  @override
  String get navSubExperience => '4+ Years Enterprise Engineering & Impact';

  @override
  String get navSectionWork => 'FEATURED WORK';

  @override
  String get navSubWork => 'Production Systems & Case Studies';

  @override
  String get navSectionStack => 'SKILLS & STACK';

  @override
  String get navSubStack => 'Technical Proficiency Matrix';

  @override
  String get navSectionEngineering => 'SYSTEM ARCHITECTURES';

  @override
  String get navSubEngineering => 'Enterprise Blueprints & Offline-First';

  @override
  String get navSectionAbout => 'LEADERSHIP PERSPECTIVES';

  @override
  String get navSubAbout => 'Architectural Perspectives & Hats';

  @override
  String get navSectionContact => 'CONTACT & INQUIRIES';

  @override
  String get navSubContact => 'Direct Channels & Availability';

  @override
  String selectedRoleAnnouncement(String role) {
    return 'Selected role: $role';
  }

  @override
  String copiedToClipboard(String value) {
    return 'Copied $value to clipboard';
  }

  @override
  String get skillsSearchHint => 'Search skills, tools, or architectures...';

  @override
  String skillsCountAll(int count) {
    return '$count SKILLS';
  }

  @override
  String skillsCountFiltered(int filtered, int total) {
    return '$filtered OF $total SKILLS';
  }

  @override
  String get skillsClearSearch => 'CLEAR SEARCH';

  @override
  String get perspectivePrev => 'PREV ROLE';

  @override
  String get perspectiveNext => 'NEXT ROLE';

  @override
  String get perspectiveShortcutsHint =>
      '← / → or A / D to cycle · S shuffle · R align';
}
