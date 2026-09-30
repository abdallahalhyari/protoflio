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
  String get navWork => 'Selected Work';

  @override
  String get navEngineering => 'Engineering';

  @override
  String get navExperience => 'Experience';

  @override
  String get navStack => 'Skills & Stack';

  @override
  String get navAbout => 'Perspectives';

  @override
  String get navContact => 'Contact';

  @override
  String get navResume => 'Resume';

  @override
  String get introLocation => 'Amman, Jordan › Brno, Czech Republic (2027)';

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
  String skillsNoMatch(String query) {
    return 'No skills match “$query”';
  }

  @override
  String get skillsEmptyShowAll => 'SHOW ALL';

  @override
  String get keyboardHintTitle => 'Keyboard shortcuts';

  @override
  String get keyboardHintDigits => '1–7   jump to section';

  @override
  String get keyboardHintArrows => 'Up / Down arrows · prev / next page';

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
  String get introWorkEligibility => 'CZ WORK ELIGIBLE · STUDENT';

  @override
  String get introAvailableContracts => 'AVAILABLE FOR CONTRACTS';

  @override
  String get contactEngagementScopes =>
      '// ENGAGEMENT SCOPES & COLLABORATION MODES';

  @override
  String get contactAtsVerified => 'ATS-VERIFIED · 2026 EDITION';

  @override
  String get contactPdfSize => 'PDF · 22 KB';

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
  String get navSubCover => 'Senior Flutter & Android Engineer';

  @override
  String get navSectionExperience => 'EXPERIENCE';

  @override
  String get navSubExperience => '5+ Years Enterprise Engineering & Impact';

  @override
  String get navSectionWork => 'SELECTED WORK';

  @override
  String get navSubWork => 'Production Systems & Case Studies';

  @override
  String get navSectionStack => 'SKILLS & STACK';

  @override
  String get navSubStack => 'Technical Proficiency Matrix';

  @override
  String get navSectionEngineering => 'ENGINEERING';

  @override
  String get navSubEngineering => 'Enterprise Blueprints & Offline-First';

  @override
  String get navSectionAbout => 'PERSPECTIVES';

  @override
  String get navSubAbout => 'Architectural Perspectives & Hats';

  @override
  String get navSectionContact => 'CONTACT';

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
      'Arrow keys or A / D to cycle · S shuffle · R align';

  @override
  String get sectionSubtitleWork =>
      'In-depth looks at architecture, implementation, and measurable outcomes.';

  @override
  String get sectionSubtitleExperience =>
      'Multi-year development of enterprise mobile systems';

  @override
  String get sectionSubtitleSkills =>
      'Disciplines and stack the work is built on · Flip any card for details';

  @override
  String get sectionSubtitleEngineering =>
      'Production-tested architectures behind the mobile suites';

  @override
  String get sectionSubtitleAbout =>
      'Six roles a senior engineer switches between';

  @override
  String get flipHintTap => 'TAP TO FLIP';

  @override
  String get flipHintClick => 'CLICK TO FLIP';

  @override
  String get folioNext => 'NEXT';

  @override
  String get folioBackToStart => 'BACK TO START';

  @override
  String welcomeBack(String section) {
    return 'Welcome back — continue at $section?';
  }

  @override
  String get continueAction => 'CONTINUE';

  @override
  String get quickProfile => '30-SEC PROFILE';

  @override
  String get quickProfileTitle => 'Hiring summary';

  @override
  String get quickProfileRole => 'ROLE';

  @override
  String get quickProfileExperience => 'EXPERIENCE';

  @override
  String quickProfileYears(int years) {
    return '$years+ years in mobile engineering';
  }

  @override
  String get quickProfileStack => 'CORE STACK';

  @override
  String get quickProfileRecent => 'RECENT ROLES';

  @override
  String get quickProfileEmail => 'Email';

  @override
  String get quickProfileCopy => 'Copy summary';

  @override
  String get quickProfileCopied => 'Profile summary copied';

  @override
  String get studyCaseStudy => 'CASE STUDY';

  @override
  String get studyProblem => 'THE PROBLEM';

  @override
  String get studyRole => 'MY ROLE';

  @override
  String get studyArchitecture => 'SYSTEM ARCHITECTURE';

  @override
  String get studyOutcomes => 'OUTCOMES';

  @override
  String get studyLessons => 'LESSONS';

  @override
  String get studyMore => 'MORE CASE STUDIES';

  @override
  String get studyDockProblem => 'PROBLEM';

  @override
  String get studyDockProblemShort => 'PROB';

  @override
  String get studyDockRole => 'ROLE';

  @override
  String get studyDockArch => 'ARCH';

  @override
  String get studyDockOutcomes => 'OUTCOMES';

  @override
  String get studyDockOutcomesShort => 'RESULTS';

  @override
  String get studyDockLessons => 'LESSONS';

  @override
  String get studyBackToPortfolio => 'Back to portfolio';

  @override
  String studyReadPercent(int pct) {
    return '$pct% READ';
  }

  @override
  String get studyTop => 'TOP';

  @override
  String get studyBackToTop => 'Back to top';

  @override
  String studyJumpTo(String chapter) {
    return 'Jump to $chapter';
  }

  @override
  String studyChapter(String chapter) {
    return 'Chapter $chapter';
  }

  @override
  String get studyOfficialWebsite => 'OFFICIAL WEBSITE';

  @override
  String studyVisitWebsite(String company) {
    return 'Visit $company official website';
  }

  @override
  String get studyCompanyLinkedIn => 'COMPANY LINKEDIN';

  @override
  String studyViewOnLinkedIn(String company) {
    return 'View $company on LinkedIn';
  }

  @override
  String get studyShare => 'SHARE STUDY';

  @override
  String get studyShareTooltip => 'Copy direct link to this case study';

  @override
  String studyShareSemantics(String title) {
    return 'Share direct link to $title case study';
  }

  @override
  String get studyShareButton => 'Share case study link';

  @override
  String studyLinkCopied(String url) {
    return 'Case study link copied: $url';
  }

  @override
  String get studyGlanceKicker => 'AT A GLANCE · 30-SECOND READ';

  @override
  String get studyGlance => 'At a glance';

  @override
  String get studyChallenge => 'CHALLENGE';

  @override
  String get studyBuilt => 'WHAT I BUILT';

  @override
  String get studyResult => 'RESULT';

  @override
  String get studySeeOutcomes => 'See all outcomes';

  @override
  String get studyEnglishNote => '';

  @override
  String studyOutcomeSemantics(String headline, String body) {
    return 'Key outcome metric: $headline. $body';
  }

  @override
  String get studyPresent => 'PRESENT';

  @override
  String get studyRoleMobileDev => 'MOBILE DEVELOPER';

  @override
  String get studyRoleFlutterDev => 'FLUTTER DEVELOPER';

  @override
  String get studyNatIntro =>
      'Mission-critical NFC smart-card healthcare platform serving Jordan\'s largest health-insurance TPA. Ring App, E-Health Gate, and Compliance System — shipped as three coordinated clients on a shared architecture.';

  @override
  String get studyNatChallenge =>
      'Paper claims slowed reimbursement and exposed Jordan\'s largest health-insurance TPA to fraud, and many clinics had unreliable connectivity.';

  @override
  String get studyNatBuilt =>
      'A three-app NFC smart-card suite: a native Kotlin APDU bridge, an offline-first WorkManager sync pipeline, and hardware-bound JWT tokens.';

  @override
  String get studyNatResult =>
      'Card verification in under a second, claims that survive connectivity drops, zero security breaches, and three clients shipped on one architecture.';

  @override
  String get studyNatOutcome1 =>
      'contactless card verification, flagship to budget handsets';

  @override
  String get studyNatOutcome2 =>
      'reliable offline batch sync during connectivity drops';

  @override
  String get studyNatOutcome3 =>
      'security breaches under hardware-bound token lifecycle';

  @override
  String get studyNatOutcome4 =>
      'coordinated clients shipped on the shared architecture';

  @override
  String get studyEskIntro =>
      'High-performance enterprise mobile architecture powering Hospital Information Systems (HIS) and Education platforms across the MENA region. Rebuilt legacy monolithic codebases into decoupled, testable feature packages with zero operational downtime.';

  @override
  String get studyEskChallenge =>
      'Legacy monolithic hospital and university apps stuttered on dense records and crashed on low-spec ward tablets during long shifts.';

  @override
  String get studyEskBuilt =>
      'An incremental MVVM refactor into decoupled feature packages with cached repositories and typed contracts, profiled with DevTools, with zero downtime.';

  @override
  String get studyEskResult =>
      '60 FPS on dense data tables, 35% fewer crashes, 1,000+ records rendered smoothly, and four enterprise platforms deployed.';

  @override
  String get studyEskOutcome1 =>
      'sustained frame rate on dense hospital data tables and medical charts';

  @override
  String get studyEskOutcome2 =>
      'reduction in client-side crash rate across multi-hour clinical shifts';

  @override
  String get studyEskOutcome3 =>
      'patient and student records rendered with zero viewport latency';

  @override
  String get studyEskOutcome4 =>
      'enterprise platforms deployed (HIS, Clinic, University, School)';

  @override
  String get studySolIntro =>
      'High-throughput consumer iOS and Android applications: a real-time loyalty redemption engine and a Snapchat-style ephemeral video/story camera platform. Built with hardware-accelerated video pipelines and an internal reusable design system.';

  @override
  String get studySolChallenge =>
      'Two consumer apps (loyalty rewards and ephemeral video stories) on compressed deadlines, with camera pipelines that leaked and distorted across Android OEMs.';

  @override
  String get studySolBuilt =>
      'A hardware-accelerated camera and video engine, background isolates that compress media before S3 upload, and a shared design-token library for both apps.';

  @override
  String get studySolResult =>
      'Both apps launched on schedule with a 4.7+ store rating, 40% faster feature turnaround, and zero dropped frames in the story carousel.';

  @override
  String get studySolOutcome1 =>
      'average star rating across iOS App Store and Google Play';

  @override
  String get studySolOutcome2 =>
      'reduction in subsequent feature turnaround time via shared component library';

  @override
  String get studySolOutcome3 =>
      'dropped frames during horizontal story carousel gesture navigation';

  @override
  String get studySolOutcome4 =>
      'production consumer applications launched simultaneously on schedule';

  @override
  String get studyFaisIntro =>
      'High-throughput commercial m-commerce checkout funnels and continuous media-streaming fitness applications. Engineered with atomic checkout transactions, defensive network interceptors, and resilient audio/video streaming.';

  @override
  String get studyFaisChallenge =>
      'Checkout drops on flaky networks caused duplicate charges and abandoned carts, and OEM battery savers killed streaming playback.';

  @override
  String get studyFaisBuilt =>
      'Idempotent checkout with client-side state reconciliation, defensive network interceptors, and a foreground-service streaming buffer manager.';

  @override
  String get studyFaisResult =>
      '99.8% checkout completion with zero duplicate charges, 45% fewer support escalations, and cart reconciliation under 200ms.';

  @override
  String get studyFaisOutcome1 =>
      'successful checkout transaction completion rate with zero duplicate charges';

  @override
  String get studyFaisOutcome2 =>
      'reduction in customer support escalation tickets for failed checkout orders';

  @override
  String get studyFaisOutcome3 =>
      'instantaneous cart calculation and state reconciliation latency';

  @override
  String get studyFaisOutcome4 =>
      'daily active sessions supported across commercial commerce funnels';

  @override
  String get skillCatAll => 'All';

  @override
  String get skillCatDomain => 'Domain Expertise';

  @override
  String get skillCatMobile => 'Mobile Systems';

  @override
  String get skillCatSecurity => 'Security & Protocols';

  @override
  String get skillCatArchitecture => 'Architecture & State';

  @override
  String get skillCatCloud => 'Cloud & Infrastructure';

  @override
  String get skillCatLanguages => 'Languages & Comm';

  @override
  String get hatThinking => 'Thinking';

  @override
  String get hatCommunicating => 'Communicating';

  @override
  String get hatSorting => 'Sorting';

  @override
  String get hatBuilding => 'Building';

  @override
  String get hatFixing => 'Fixing';

  @override
  String get hatCompassion => 'Compassion';

  @override
  String get archTopicClean => 'Clean Mobile Architecture';

  @override
  String get archTopicOffline => 'Offline-First Synchronization';

  @override
  String get archTopicNfc => 'ISO-7816 Smart-Card & NFC Pipeline';

  @override
  String get archTopicKeystore => 'Hardware-Backed Keystore & JWT Lifecycle';

  @override
  String get archTopicState => 'Reactive State Management (BLoC)';
}
