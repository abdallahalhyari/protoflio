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
  String get navStack => 'Skills';

  @override
  String get navAbout => 'About';

  @override
  String get navContact => 'Contact';

  @override
  String get navResume => 'CV';

  @override
  String get introLocation => 'Amman, Jordan; Brno from February 2027';

  @override
  String get sectionEducation => 'Education';

  @override
  String get sectionCertifications => 'Certifications';

  @override
  String get contactHeroEyebrow => 'Email';

  @override
  String get contactReplyWindow =>
      'Replies within 24 hours, in English or Arabic';

  @override
  String get contactSendEmailBtn => 'Send email';

  @override
  String get contactCopyAddressBtn => 'Copy address';

  @override
  String get skillsEmptyTitle => 'No skills in this category yet';

  @override
  String skillsNoMatch(String query) {
    return 'No skills match “$query”';
  }

  @override
  String get skillsNoMatchHint =>
      'Search by tool or topic, for example Kotlin or offline sync.';

  @override
  String get skillsEmptyShowAll => 'Show all skills';

  @override
  String get keyboardHintTitle => 'Keyboard shortcuts';

  @override
  String get keyboardHintDigits => '1–7   jump to section';

  @override
  String get keyboardHintArrows => 'Previous or next page';

  @override
  String get keyboardHintHome => 'Home  first page';

  @override
  String get keyboardHintEnd => 'End   last page';

  @override
  String get closeTooltip => 'Close';

  @override
  String get shortcutJumpPrimary => 'Jump to Work / Experience / Engineering';

  @override
  String get shortcutJumpSecondary => 'Jump to Skills / About / Contact';

  @override
  String get shortcutToggleTheme => 'Toggle theme mode';

  @override
  String get shortcutToggleAudio => 'Mute / unmute audio';

  @override
  String get shortcutViewCv => 'View CV';

  @override
  String get showHelpShortcut => 'Show this help';

  @override
  String get changeLanguage => 'Change language';

  @override
  String changeLanguageCurrent(String code) {
    return 'Change language. Current: $code';
  }

  @override
  String get switchToLightMode => 'Switch to light mode';

  @override
  String get switchToDarkMode => 'Switch to dark mode';

  @override
  String get muteSoundEffects => 'Mute sound effects';

  @override
  String get enableSoundEffects => 'Enable sound effects';

  @override
  String get soundEffectsOnTooltip => 'Sound Effects: ON (Click to mute)';

  @override
  String get soundEffectsMutedTooltip =>
      'Sound Effects: MUTED (Click to enable)';

  @override
  String get openNavigationMenu => 'Open navigation menu';

  @override
  String get menuLabel => 'MENU';

  @override
  String get sectionNavigationLabel => 'Section navigation';

  @override
  String get downloadResumePdf => 'Download CV (PDF)';

  @override
  String get previousSection => 'Previous section';

  @override
  String get nextSection => 'Next section';

  @override
  String get scrollToTop => 'Scroll to top';

  @override
  String resumeOpenError(Object publicUrl) {
    return 'Could not open resume — visit $publicUrl';
  }

  @override
  String projectOpenError(Object url) {
    return 'Could not open $url';
  }

  @override
  String emailCopied(Object email) {
    return 'Copied $email';
  }

  @override
  String get viewMyWork => 'View my work';

  @override
  String get downloadResume => 'Download CV';

  @override
  String get introDownloadResume => 'Download CV';

  @override
  String get introSeniorEngineer => 'Senior mobile engineer';

  @override
  String get introSummary =>
      'Senior mobile engineer. I build Flutter and native Android apps that keep working offline, work with the device hardware and keep user data secure.';

  @override
  String get introAvailability =>
      'Available now for remote and contract work. On-site in Brno from February 2027.';

  @override
  String get introEmailMe => 'Email me';

  @override
  String get introRoleLine => 'Senior Flutter & Android engineer';

  @override
  String get introWorkEligibility => 'Moving to Brno in February 2027';

  @override
  String get introAvailableContracts => 'Available for contracts';

  @override
  String get contactPdfSize => 'PDF, 22 KB';

  @override
  String get footerRightsReserved => '© 2026 Abdallah Alhyari';

  @override
  String get contactPhone => 'Phone';

  @override
  String get contactCall => 'Call';

  @override
  String get contactDownload => 'Download';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get cardFactAvailableValue => 'Remote and contract work, now';

  @override
  String get cardFactBasedValue => 'Amman, Jordan; Brno from February 2027';

  @override
  String get cardFactStudyValue =>
      'M.Sc. Open Informatics, Mendel University, from February 2027';

  @override
  String get cardFactPermitValue =>
      'Not needed in Czechia while studying full-time';

  @override
  String get contactHiringValue => 'Role, experience and stack on one page';

  @override
  String get contactView => 'View';

  @override
  String get contactVcard => 'Contact card';

  @override
  String get contactVcardValue => 'Scan to save my details';

  @override
  String get contactShowQr => 'Show QR';

  @override
  String get contactViewProfile => 'View profile';

  @override
  String contactMessageWhatsapp(String number) {
    return 'Message $number on WhatsApp';
  }

  @override
  String contactCallNumber(String number) {
    return 'Call $number';
  }

  @override
  String get contactLinkedin => 'LinkedIn';

  @override
  String get contactGithub => 'GitHub';

  @override
  String get semanticPortrait => 'Portrait of Abdallah Alhyari';

  @override
  String get semanticTitle => 'Abdallah Alhyari, Senior Mobile Engineer';

  @override
  String get introTechStack =>
      'Flutter, Android, iOS, architecture, offline-first, NFC, security, real-time systems';

  @override
  String get introBasedIn => 'Location';

  @override
  String get introStatus => 'Availability';

  @override
  String get introOpenForRoles => 'Open to senior mobile roles';

  @override
  String get navSectionCover => 'Cover';

  @override
  String get navSubCover => 'Senior Flutter & Android engineer';

  @override
  String get navSectionExperience => 'Experience';

  @override
  String get navSubExperience => 'Five years of enterprise mobile work';

  @override
  String get navSectionWork => 'Work';

  @override
  String get navSubWork => 'Case studies from production apps';

  @override
  String get navSectionStack => 'Skills';

  @override
  String get navSubStack => 'Tools and disciplines';

  @override
  String get navSectionEngineering => 'Engineering';

  @override
  String get navSubEngineering => 'How the apps are built';

  @override
  String get navSectionAbout => 'About';

  @override
  String get navSubAbout => 'Background and availability';

  @override
  String get navSectionContact => 'Contact';

  @override
  String get navSubContact => 'Email, phone and profiles';

  @override
  String copiedToClipboard(String value) {
    return 'Copied $value to clipboard';
  }

  @override
  String get skillsSearchHint => 'Search skills, tools, or architectures...';

  @override
  String skillsCountAll(int count) {
    return '$count skills';
  }

  @override
  String skillsCountFiltered(int filtered, int total) {
    return '$filtered of $total skills';
  }

  @override
  String get skillsClearSearch => 'Clear search';

  @override
  String get sectionSubtitleWork =>
      'Four employers, four systems. Each case shows the problem, how it was built, and what changed.';

  @override
  String get sectionSubtitleExperience =>
      'Four roles since 2021, from shipping features to owning the native and security layer.';

  @override
  String get projectDossierDecision => 'Key decision';

  @override
  String readCaseStudyFor(String project) {
    return 'Read case study for $project';
  }

  @override
  String get projectTaglineNatHealth =>
      'Mission-critical NFC smart-card healthcare platform for mobile care, digital claims, and regulatory compliance.';

  @override
  String get projectTaglineEskadenia =>
      'High-performance enterprise mobile applications for hospital information systems and education platforms.';

  @override
  String get projectTaglineSolutions =>
      'A loyalty rewards platform and an ephemeral video and stories experience, built for consumer scale.';

  @override
  String get projectTaglineFais =>
      'High-throughput commerce checkouts and continuous media-streaming applications.';

  @override
  String get projectOutcomeNatHealth =>
      'Replaced paper claim submissions with instant contactless smart-card validation.';

  @override
  String get projectOutcomeEskadenia =>
      'Sustained 60fps across complex, data-heavy hospital and university workflows.';

  @override
  String get projectOutcomeFais =>
      'Improved checkout completion and reduced abandoned transactions.';

  @override
  String get contactHeaderTitle => 'Have a difficult mobile problem?';

  @override
  String get contactHeaderSubtitle =>
      'Send it over. I take on mobile architecture reviews and contract work now, and I am looking for a senior mobile role in Brno from February 2027. Email gets the fastest reply.';

  @override
  String get skillsHeaderTitle => 'Skills';

  @override
  String get skillsHeaderSubtitle =>
      'What I work with and where I used it. Search a tool or filter by area.';

  @override
  String get sectionSubtitleEngineering =>
      'The architectures behind my mobile suites: layers, offline sync, NFC and token security.';

  @override
  String get folioNext => 'Next';

  @override
  String get folioBackToStart => 'Back to start';

  @override
  String welcomeBack(String section) {
    return 'Welcome back — continue at $section?';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get quickProfileTitle => 'Hiring summary';

  @override
  String get quickProfileRole => 'Role';

  @override
  String get quickProfileExperience => 'Experience';

  @override
  String quickProfileYears(int years) {
    return '$years+ years in mobile engineering';
  }

  @override
  String get quickProfileStack => 'Core stack';

  @override
  String get quickProfileRecent => 'Recent roles';

  @override
  String get quickProfileEmail => 'Email';

  @override
  String get quickProfileCopy => 'Copy summary';

  @override
  String get quickProfileCopied => 'Profile summary copied';

  @override
  String get quickProfileVcard => 'vCard QR';

  @override
  String get vcardDialogTitle => 'Recruiter contact card';

  @override
  String get vcardScanHint => 'Scan with your phone camera';

  @override
  String get vcardCopyText => 'Copy contact card';

  @override
  String get vcardCopied => 'Contact card copied to clipboard';

  @override
  String get done => 'Done';

  @override
  String studyCaseStudy(String company) {
    return '$company case study';
  }

  @override
  String get studyProblem => 'The problem';

  @override
  String get studyRole => 'My role';

  @override
  String get studyArchitecture => 'System architecture';

  @override
  String get studyOutcomes => 'Outcomes';

  @override
  String get studyLessons => 'Lessons';

  @override
  String get studyMore => 'More case studies';

  @override
  String get studyDockProblem => 'Problem';

  @override
  String get studyDockProblemShort => 'Problem';

  @override
  String get studyDockRole => 'Role';

  @override
  String get studyDockArch => 'Design';

  @override
  String get studyDockOutcomes => 'Outcomes';

  @override
  String get studyDockOutcomesShort => 'Results';

  @override
  String get studyDockLessons => 'Lessons';

  @override
  String get studyBackToPortfolio => 'Back to portfolio';

  @override
  String get studyTop => 'Top';

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
  String get studyOfficialWebsite => 'Company website';

  @override
  String studyVisitWebsite(String company) {
    return 'Visit $company official website';
  }

  @override
  String get studyCompanyLinkedIn => 'Company LinkedIn';

  @override
  String studyViewOnLinkedIn(String company) {
    return 'View $company on LinkedIn';
  }

  @override
  String get studyShareButton => 'Share case study link';

  @override
  String studyLinkCopied(String url) {
    return 'Case study link copied: $url';
  }

  @override
  String get studyGlance => 'At a glance';

  @override
  String get studyChallenge => 'Challenge';

  @override
  String get studyBuilt => 'What I built';

  @override
  String get studyResult => 'Result';

  @override
  String get studySeeOutcomes => 'See all outcomes';

  @override
  String get studyEnglishNote => '';

  @override
  String studyOutcomeSemantics(String headline, String body) {
    return 'Key outcome metric: $headline. $body';
  }

  @override
  String get studyPresent => 'Present';

  @override
  String get studyRoleMobileDev => 'Mobile developer';

  @override
  String get studyRoleFlutterDev => 'Flutter developer';

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
      '60 FPS on dense data tables, 35% fewer crashes, and four enterprise platforms deployed.';

  @override
  String get studyEskOutcome1 =>
      'sustained frame rate on dense hospital data tables and medical charts';

  @override
  String get studyEskOutcome2 =>
      'reduction in client-side crash rate across multi-hour clinical shifts';

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
      'An m-commerce checkout and a fitness and media-streaming app, built around checkout requests that are safe to retry, defensive network handling and playback that survives interruptions.';

  @override
  String get studyFaisChallenge =>
      'Checkout drops on flaky networks caused duplicate charges and abandoned carts, and OEM battery savers killed streaming playback.';

  @override
  String get studyFaisBuilt =>
      'Idempotent checkout with client-side state reconciliation, defensive network interceptors, and a foreground-service streaming buffer manager.';

  @override
  String get studyFaisResult =>
      'Higher checkout completion, fewer support tickets for failed orders, and live issues fixed from production data.';

  @override
  String get studyFaisOutcome1 =>
      'Higher checkout completion and fewer abandoned carts.';

  @override
  String get studyFaisOutcome2 => 'Fewer support tickets for failed orders.';

  @override
  String get studyFaisOutcome3 =>
      'Live issues traced and fixed from production data.';

  @override
  String get skillCatAll => 'All';

  @override
  String get skillCatDomain => 'Domain expertise';

  @override
  String get skillCatMobile => 'Mobile systems';

  @override
  String get skillCatSecurity => 'Security & protocols';

  @override
  String get skillCatArchitecture => 'Architecture & state';

  @override
  String get skillCatCloud => 'Cloud & infrastructure';

  @override
  String get skillCatLanguages => 'Languages & communication';

  @override
  String get archTopicClean => 'Clean architecture';

  @override
  String get archTopicOffline => 'Offline-first sync';

  @override
  String get archTopicNfc => 'NFC smart cards (ISO 7816)';

  @override
  String get archTopicKeystore => 'Keystore and token lifecycle';

  @override
  String get archTopicState => 'State management (BLoC)';

  @override
  String get uiReadCaseStudy => 'Read case study';

  @override
  String get projectNameNatHealth => 'NatHealth Mobile Suite';

  @override
  String get projectNameEskadenia => 'E-Learning & Healthcare Enterprise Suite';

  @override
  String get projectNameSolutions =>
      'Loyalty Rewards & Ephemeral Social Media Apps';

  @override
  String get projectNameFais => 'M-Commerce & Media-Streaming Clients';

  @override
  String get uiPortfolioSections => 'Sections';

  @override
  String get uiDownloadResumePdf => 'Download CV (PDF)';

  @override
  String get uiRetry => 'Retry';

  @override
  String get uiWebsite => 'Website';

  @override
  String expRoleAtCompany(String role, String company, String period) {
    return '$role at $company, $period';
  }

  @override
  String get uiArchRationale => 'Why this choice';

  @override
  String get uiKeySafeguards => 'Safeguards';

  @override
  String get cardSurname => 'Alhyari';

  @override
  String get cardGivenName => 'Abdallah';

  @override
  String get cardFieldSurname => 'Surname';

  @override
  String get cardFieldGiven => 'Given name';

  @override
  String get cardFieldRole => 'Role';

  @override
  String get cardRole => 'Senior mobile engineer';

  @override
  String get cardBase => 'Amman; Brno from February 2027';

  @override
  String get coverWorkedAtLabel => 'Worked at';

  @override
  String get coverWorkedAtValue => 'NatHealth, ESKADENIA, Solutions Now, FAIS';

  @override
  String get projectFigureValueNatHealth => '400,000+';

  @override
  String get projectFigureLabelNatHealth =>
      'beneficiaries served across Jordan, Palestine and Iraq. Paper claims replaced by NFC cards.';

  @override
  String get projectFigureValueEskadenia => '35%';

  @override
  String get projectFigureLabelEskadenia =>
      'fewer crashes, with a steady 60 FPS on dense hospital data tables.';

  @override
  String get projectFigureValueSolutions => '4.7+';

  @override
  String get projectFigureLabelSolutions =>
      'star store rating. Both apps shipped on time.';

  @override
  String get heroFactAvailableLabel => 'Available';

  @override
  String get heroFactPermitLabel => 'Work permit';

  @override
  String get heroFactBasedLabel => 'Based in';

  @override
  String get heroFactLanguagesLabel => 'Languages';

  @override
  String get heroFactLanguagesValue =>
      'English (professional), Arabic (native)';

  @override
  String get heroFactStudyLabel => 'Studying';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutHeaderSubtitle =>
      'Who I am, where I\'m headed, and how to reach me.';

  @override
  String get aboutExperienceLabel => 'Experience';

  @override
  String aboutExperienceValue(int years) {
    return '$years+ years in mobile';
  }

  @override
  String get projectLblProblem => 'Problem';

  @override
  String get projectLblSystem => 'System';

  @override
  String get projectLblRole => 'My role';

  @override
  String get projectProblemNatHealth =>
      'Paper claims, fraud risk and unreliable clinic connectivity slowed insurance claim processing.';

  @override
  String get projectSystemNatHealth =>
      'Kotlin NFC bridge to smart cards, JWT with device binding, and an offline-first WorkManager queue.';

  @override
  String get projectRoleNatHealth =>
      'Led mobile architecture, native NFC integration and security.';

  @override
  String get projectProblemEskadenia =>
      'Legacy hospital and university apps dropped frames, tangled state together and used too much memory.';

  @override
  String get projectSystemEskadenia =>
      'Decoupled MVVM feature packages, typed REST layers and cached repositories.';

  @override
  String get projectRoleEskadenia =>
      'Led the architectural refactor, profiling and package extraction.';

  @override
  String get projectProblemSolutions =>
      'Two high-volume consumer apps, a loyalty engine and real-time stories, had to ship on tight timelines.';

  @override
  String get projectSystemSolutions =>
      'A shared Flutter component library, hardware-accelerated camera and video pipelines, dynamic REST models.';

  @override
  String get projectRoleSolutions =>
      'Set the mobile design standards, built the camera pipelines and backend integration.';

  @override
  String get projectProblemFais =>
      'Multi-step checkout and continuous media streaming had to run without memory leaks or state races.';

  @override
  String get projectSystemFais =>
      'End-to-end checkout API integration with idempotency keys, and live issue diagnosis from telemetry.';

  @override
  String get projectRoleFais =>
      'Coordinated backend and frontend integration and resolved production issues.';

  @override
  String engTiers(int count) {
    return '$count tiers';
  }

  @override
  String get aboutStoryShort =>
      'I started in mobile in 2021. Since then my work has moved steadily down the stack, from screens to the native, security and sync layers underneath. I am comfortable inheriting a complicated legacy system and leaving it modular and testable.';

  @override
  String projectCopyCaseStudyLink(String project) {
    return 'Copy link to the $project case study';
  }

  @override
  String get brandBackToTop => 'Abdallah Alhyari, back to top';

  @override
  String get archCostLabel => 'What it costs';

  @override
  String get archUsedAtLabel => 'Used at';
}
