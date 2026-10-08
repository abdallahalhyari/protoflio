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
  String get introLocation => 'Amman → Brno · 2027';

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
  String get skillsEmptyShowAll => 'Show all skills';

  @override
  String get keyboardHintTitle => 'Keyboard shortcuts';

  @override
  String get keyboardHintDigits => '1–7   jump to section';

  @override
  String get keyboardHintArrows => 'Up and down arrows move between pages';

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
  String get spreadAction => 'Spread';

  @override
  String get alignAction => 'Align';

  @override
  String get previousAction => 'Previous';

  @override
  String get nextAction => 'Next';

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
  String get contactMe => 'Let\'s talk';

  @override
  String get copyEmail => 'Copy email';

  @override
  String get introSeniorEngineer => 'Senior Flutter & Android engineer';

  @override
  String get introRoleLine => 'Senior Flutter & Android engineer';

  @override
  String get introValueProposition =>
      'I build production-grade mobile applications, from architecture and native integrations to release and long-term maintenance.';

  @override
  String get introSkillArchitecture => 'Architecture';

  @override
  String get introSkillProductDelivery => 'Product delivery';

  @override
  String get introWorkEligibility => 'Relocating to Brno in 2027';

  @override
  String get introAvailableContracts => 'Available for contracts';

  @override
  String get contactEngagementScopes => 'Ways to work together';

  @override
  String get contactAtsVerified => 'ATS-friendly, 2026 edition';

  @override
  String get contactPdfSize => 'PDF, 22 KB';

  @override
  String get contactCvDossierTitle =>
      'Executive Curriculum Vitae & Portfolio Dossier';

  @override
  String get contactCvDossierDesc =>
      'Complete chronological track record, enterprise architecture case studies, and engineering competencies.';

  @override
  String get contactDownloadCvPdf => 'Download CV (PDF)';

  @override
  String get contactPreview => 'Preview';

  @override
  String get footerRightsReserved => '© 2026 Abdallah Alhyari';

  @override
  String get contactPhone => 'Phone';

  @override
  String get contactCall => 'Call';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactOpen => 'Open';

  @override
  String get contactCopy => 'Copy';

  @override
  String get contactLinkedin => 'LinkedIn';

  @override
  String get contactProfile => 'Profile';

  @override
  String get contactGithub => 'GitHub';

  @override
  String get contactVisit => 'Visit';

  @override
  String get semanticPortrait => 'Portrait of Abdallah Alhyari';

  @override
  String get semanticTitle => 'Abdallah Alhyari, Senior Mobile Engineer';

  @override
  String folioIndicator(Object current, Object total) {
    return '$current of $total';
  }

  @override
  String get introTechStack =>
      'Flutter · Android · iOS · Architecture · Offline-first · NFC · Security · Real-time systems';

  @override
  String get introBasedIn => 'Location';

  @override
  String get introStatus => 'Availability';

  @override
  String get introOpenForRoles => 'Open to Senior Mobile Roles';

  @override
  String get introMasthead => 'Masthead';

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
  String get navSectionAbout => 'Perspectives';

  @override
  String get navSubAbout => 'How I work with teams';

  @override
  String get navSectionContact => 'Contact';

  @override
  String get navSubContact => 'Email, phone and profiles';

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
    return '$count skills';
  }

  @override
  String skillsCountFiltered(int filtered, int total) {
    return '$filtered of $total skills';
  }

  @override
  String get skillsClearSearch => 'Clear search';

  @override
  String get perspectivePrev => 'Previous role';

  @override
  String get perspectiveNext => 'Next role';

  @override
  String get perspectiveShortcutsHint =>
      'Arrow keys or A and D to cycle, S to shuffle, R to align';

  @override
  String get sectionSubtitleWork =>
      'Four employers, four systems. Each case shows the problem, how it was built, and what changed.';

  @override
  String get sectionSubtitleExperience =>
      'Four roles since 2021, from shipping features to owning the native and security layer.';

  @override
  String get projectsHeaderKicker => 'Selected work';

  @override
  String get projectDomainAll => 'All';

  @override
  String get projectDomainHealthcare => 'Healthcare & Smart Cards';

  @override
  String get projectDomainEnterprise => 'Enterprise HIS & LMS';

  @override
  String get projectDomainFleet => 'Fleet & Telematics';

  @override
  String get projectDomainCommerce => 'M-Commerce & Streaming';

  @override
  String projectTechFilter(String technology) {
    return 'Filtered by $technology';
  }

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
  String get projectOutcomeSolutions =>
      'Shipped both applications on time with 4.7+ star store ratings.';

  @override
  String get projectOutcomeFais =>
      'Improved checkout completion and reduced abandoned transactions.';

  @override
  String get skillMasteryLead => 'Lead';

  @override
  String get skillMasteryCore => 'Core';

  @override
  String get skillMasterySolid => 'Solid';

  @override
  String get skillMasteryGrowing => 'Growing';

  @override
  String skillCardSemantics(String skill, String level) {
    return '$skill, $level proficiency. Activate to flip and view details.';
  }

  @override
  String get experienceHeaderKicker => 'Career';

  @override
  String get engineeringHeaderKicker => 'Systems architecture';

  @override
  String get hatsHeaderKickerMobile => 'Six roles';

  @override
  String get hatsHeaderKickerDesktop => 'Six roles';

  @override
  String get hatsHeaderSubtitle =>
      'Product-minded engineering, clear communication, and practical leadership across teams, constraints, and high-stakes delivery.';

  @override
  String get contactHeaderKicker => 'Contact';

  @override
  String get contactHeaderTitle => 'Have a difficult mobile problem?';

  @override
  String get contactHeaderSubtitle =>
      'Send it over. I take on mobile architecture reviews and contract work now, and I am looking for a senior mobile role in Brno from February 2027. Email gets the fastest reply.';

  @override
  String get skillsHeaderKicker => 'Skills';

  @override
  String get skillsHeaderTitle => 'Skills';

  @override
  String get skillsHeaderSubtitle =>
      'What I work with and where I used it. Search a tool or filter by area.';

  @override
  String get sectionSubtitleEngineering =>
      'The architectures behind my mobile suites: layers, offline sync, NFC and token security.';

  @override
  String get flipHintTap => 'Tap to flip';

  @override
  String get flipHintClick => 'Click to flip';

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
  String get quickProfile => '30-second profile';

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
  String get studyCaseStudy => 'Case study';

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
  String studyReadPercent(int pct) {
    return '$pct% read';
  }

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
  String get studyShare => 'Share';

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
  String get studyGlanceKicker => 'At a glance';

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

  @override
  String get uiComposeInquiry => 'Write a message';

  @override
  String get uiPresetsTitle => 'Start from a template';

  @override
  String get uiActiveHours => 'Working hours';

  @override
  String get uiStandbyAsync => 'Replies within a day';

  @override
  String get uiRelocating => 'Moving to Brno, 2027';

  @override
  String get uiInquireTrack => 'Ask about this';

  @override
  String get uiComposerTitle => 'Write a message';

  @override
  String get uiSelectTrack => 'What is this about?';

  @override
  String get uiCopyDraft => 'Copy draft';

  @override
  String get uiSending => 'Sending…';

  @override
  String get uiSendMessage => 'Send message';

  @override
  String get uiOpenEmailClient => 'Open in email app';

  @override
  String get uiReadCaseStudy => 'Read case study';

  @override
  String get uiNoCaseStudies => 'No case studies match these filters';

  @override
  String get uiResetFilters => 'Reset filters';

  @override
  String get uiScrollToExplore => 'Scroll to explore';

  @override
  String get uiPortfolioSections => 'Sections';

  @override
  String get uiDownloadResumePdf => 'Download CV (PDF)';

  @override
  String get uiDragCardsHint =>
      'Drag the cards, click one to flip it, or shuffle';

  @override
  String get uiTapSwipeHint => 'Tap a card to flip it, swipe to change role';

  @override
  String get uiTapToReturn => 'Tap to return';

  @override
  String get uiArchFlowchart => 'Flowchart';

  @override
  String get uiArchRationale => 'Why this choice';

  @override
  String get uiKeySafeguards => 'Safeguards';

  @override
  String get uiLatencyBudget => 'Latency target per layer';

  @override
  String get uiActiveTrace => 'Tracing';

  @override
  String get uiLatestDispatch => 'Current role';

  @override
  String badgeSkills(int count) {
    return '$count disciplines';
  }

  @override
  String badgeCaseStudies(int count) {
    return '$count case studies';
  }

  @override
  String badgeArchitectures(int count) {
    return '$count architectures';
  }

  @override
  String badgeRoles(int count) {
    return '$count roles';
  }

  @override
  String get coverName => 'Abdallah Alhyari';

  @override
  String get coverStatement =>
      'Mobile apps that work offline, read smart cards and keep patient data safe.';

  @override
  String get coverLead =>
      'I\'m a senior Flutter and Android engineer with five years on enterprise healthcare, education and commerce apps. Based in Amman, moving to Brno in 2027.';

  @override
  String get coverEmailPrefix => 'Or email';

  @override
  String get cardHintTap => 'Tap the card to read its chip';

  @override
  String get cardHintClick => 'Click the card to read its chip';

  @override
  String get cardHintTurnBackTap => 'Tap the card again to turn it over';

  @override
  String get cardHintTurnBackClick => 'Click the card again to turn it over';

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
  String get cardFieldBase => 'Based in';

  @override
  String get cardRole => 'Senior mobile engineer';

  @override
  String get cardBase => 'Amman, Brno from 2027';

  @override
  String get cardBackTitle => 'Read from the chip';

  @override
  String get cardOutcome1 =>
      'Paper claims replaced by contactless smart-card checks';

  @override
  String get cardOutcome2 =>
      'Sub-second NFC reads across a wide range of Android phones';

  @override
  String get cardOutcome3 =>
      '35% fewer crashes and a steady 60 fps in data-heavy hospital apps';

  @override
  String get cardSemantics =>
      'Credential card for Abdallah Alhyari. Activate to read the chip and turn the card over.';

  @override
  String get coverHintDrag => 'Drag the card onto the reader, or click it.';

  @override
  String get coverHintTap => 'Tap the card to read it.';

  @override
  String get coverGranted => 'Access granted';

  @override
  String get introPitch =>
      'I build production Flutter and Android apps: offline-first sync, NFC smart cards, secure auth. I stay through release and after.';

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
  String get heroFactAvailableValue =>
      'Remote or part-time now. On-site in Brno from February 2027.';

  @override
  String get heroFactPermitLabel => 'Work permit';

  @override
  String get heroFactPermitValue =>
      'Not needed in Czechia while I study full-time.';

  @override
  String get heroFactBasedLabel => 'Based in';

  @override
  String get heroFactBasedValue => 'Amman, Jordan';

  @override
  String get heroFactFocusLabel => 'Focus';

  @override
  String get heroFactFocusValue =>
      'NFC smart cards, offline-first sync, secure authentication';

  @override
  String get heroFactLanguagesLabel => 'Languages';

  @override
  String get heroFactLanguagesValue =>
      'English (professional), Arabic (native)';

  @override
  String get heroFactStudyLabel => 'Studying';

  @override
  String get heroFactStudyValue =>
      'M.Sc. Open Informatics, Mendel University, from February 2027';

  @override
  String get traceCta => 'Trace a tap';

  @override
  String get traceAgain => 'Trace again';

  @override
  String get traceDone => 'Claim queued, synced and confirmed.';

  @override
  String get traceHint =>
      'Follow one NFC claim through every layer. Hover a step to read what happens there.';

  @override
  String get traceNote =>
      'Call names are illustrative. Flow simplified from my NFC claims work at NatHealth.';

  @override
  String get traceRunning => 'Tracing…';

  @override
  String get traceDetailFlutter =>
      'A tap becomes a typed Dart call. The UI never touches hardware or keys.';

  @override
  String get traceDetailChannel =>
      'Calls cross the Dart to Kotlin boundary as serialised messages. Failures come back as typed errors.';

  @override
  String get traceDetailNative =>
      'Kotlin talks to the card over ISO-DEP: select, authenticate, read. This is the part Flutter cannot do alone.';

  @override
  String get traceDetailSecurity =>
      'Tokens are signed with hardware-backed keys. With no network, the claim is queued and WorkManager retries it.';

  @override
  String get traceDetailBackend =>
      'REST over HTTPS, authenticated with a JWT. The server\'s reply closes the loop for the queued claim.';

  @override
  String get traceStepFlutter => 'Flutter UI';

  @override
  String get traceStepChannel => 'Platform channel';

  @override
  String get traceStepNative => 'Native Android';

  @override
  String get traceStepSecurity => 'Security and sync';

  @override
  String get traceStepBackend => 'Backend';

  @override
  String get introTagline =>
      'Mobile engineer building software that works beyond the screen.';

  @override
  String get introPitch2 =>
      'Production Flutter and native Android: NFC smart cards, cryptography, offline-first sync and enterprise integrations.';

  @override
  String get letsTalk => 'Let\'s talk';

  @override
  String get downloadCv => 'Download CV';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutSubtitle =>
      'How I work as an engineer, the problems I solve, and a few things you can run yourself.';

  @override
  String get aboutTabProfile => 'Profile';

  @override
  String get aboutTabPlayground => 'Playground';

  @override
  String get aboutEngineerLabel => 'Engineer';

  @override
  String get aboutEngineerValue =>
      'Flutter, Android and the systems around them';

  @override
  String get aboutExperienceLabel => 'Experience';

  @override
  String aboutExperienceValue(int years) {
    return '$years+ years in mobile';
  }

  @override
  String get aboutFocusLabel => 'Focus';

  @override
  String get aboutFocusValue =>
      'Mobile systems, native integration, security, enterprise apps';

  @override
  String get aboutHoodHint => 'Select a capability to see how I use it.';

  @override
  String get aboutWhereLabel => 'Where I used it';

  @override
  String get hoodNfcTitle => 'NFC';

  @override
  String get hoodNfcTag => 'Secure card communication and authentication.';

  @override
  String get hoodNfcDetail =>
      'A native Kotlin layer talks to smart cards over ISO 7816 APDUs. I designed the card-reader interface so several card technologies sit behind one contract.';

  @override
  String get hoodNfcWhere => 'NatHealth';

  @override
  String get hoodCryptoTitle => 'Cryptography';

  @override
  String get hoodCryptoTag => 'RSA, AES and PBKDF2, with careful key handling.';

  @override
  String get hoodCryptoDetail =>
      'Two-step JWT issuance, secure token storage and GUID-based device binding keep sensitive patient data protected.';

  @override
  String get hoodCryptoWhere => 'NatHealth';

  @override
  String get hoodBackgroundTitle => 'Background processing';

  @override
  String get hoodBackgroundTag => 'Reliable sync and message processing.';

  @override
  String get hoodBackgroundDetail =>
      'WorkManager runs background sync, status polling and token refresh, so work finishes without the user watching.';

  @override
  String get hoodBackgroundWhere => 'NatHealth';

  @override
  String get hoodOfflineTitle => 'Offline-first';

  @override
  String get hoodOfflineTag =>
      'Apps that keep working when connectivity disappears.';

  @override
  String get hoodOfflineDetail =>
      'Submissions are stored on the device and sent when the network returns, with exponential-backoff retries and standard failure handling.';

  @override
  String get hoodOfflineWhere => 'NatHealth';

  @override
  String get hoodNativeTitle => 'Native integration';

  @override
  String get hoodNativeTag => 'Flutter bridged to complex native Android.';

  @override
  String get hoodNativeDetail =>
      'Platform channels connect Dart to Kotlin and Java code for hardware access that Flutter cannot reach on its own.';

  @override
  String get hoodNativeWhere => 'NatHealth';

  @override
  String get hoodEnterpriseTitle => 'Enterprise systems';

  @override
  String get hoodEnterpriseTag =>
      'Healthcare, ERP and large business workflows.';

  @override
  String get hoodEnterpriseDetail =>
      'Modular architecture and reusable components across healthcare, e-learning and ERP clients, rebuilt without taking the apps offline.';

  @override
  String get hoodEnterpriseWhere => 'ESKADENIA Software';

  @override
  String get playKdfTitle => 'Key derivation';

  @override
  String get playKdfIntro =>
      'PBKDF2-HMAC-SHA256 running in your browser. More iterations make every password guess slower, for an attacker and for you.';

  @override
  String get playKdfPassword => 'Password';

  @override
  String get playKdfIterations => 'Iterations';

  @override
  String get playKdfRun => 'Derive key';

  @override
  String get playKdfRunning => 'Deriving…';

  @override
  String get playKdfResult => 'Derived key (256 bit)';

  @override
  String playKdfTime(int ms) {
    return 'Took $ms ms on this device.';
  }

  @override
  String get playKdfNote =>
      'The salt is fixed for this demo. Real systems use a random salt per user.';

  @override
  String get playSyncTitle => 'Offline to online';

  @override
  String get playSyncIntro =>
      'Submit claims while offline. They queue on the device and sync when you go back online, retrying with exponential backoff.';

  @override
  String get playSyncOnline => 'Online';

  @override
  String get playSyncOffline => 'Offline';

  @override
  String get playSyncFlaky => 'Flaky network';

  @override
  String get playSyncSubmit => 'Submit claim';

  @override
  String get playSyncEmpty => 'No claims yet. Submit one.';

  @override
  String get playSyncQueued => 'Queued';

  @override
  String get playSyncSending => 'Sending';

  @override
  String get playSyncSynced => 'Synced';

  @override
  String playSyncRetry(int seconds) {
    return 'Retry in ${seconds}s';
  }

  @override
  String playSyncClaim(int number) {
    return 'Claim $number';
  }

  @override
  String get playSyncNote => 'Simulation. No network is used.';

  @override
  String get navPerspectives => 'Perspectives';

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
  String get playAesTitle => 'Encrypt and decrypt';

  @override
  String get playAesIntro =>
      'AES-256-CBC with a key derived from your password by PBKDF2. Everything runs in your browser.';

  @override
  String get playAesMessage => 'Message';

  @override
  String get playAesPassword => 'Password';

  @override
  String get playAesEncrypt => 'Encrypt';

  @override
  String get playAesDecryptWith => 'Decrypt with password';

  @override
  String get playAesDecrypt => 'Decrypt';

  @override
  String get playAesIv => 'IV';

  @override
  String get playAesCipher => 'Ciphertext';

  @override
  String get playAesPlain => 'Decrypted text';

  @override
  String get playAesWrongKey =>
      'Wrong key: the padding is invalid, so decryption stops.';

  @override
  String get playAesNote =>
      'CBC hides the message but does not detect tampering. Real systems add a MAC or use an AEAD mode such as GCM.';

  @override
  String get playApduTitle => 'Smart-card exchange';

  @override
  String get playApduIntro =>
      'An ISO 7816 command APDU and the card\'s reply, byte by byte. The card here is simulated.';

  @override
  String get playApduSelect => 'Select application';

  @override
  String get playApduRead => 'Read 16 bytes';

  @override
  String get playApduUnknown => 'Select unknown application';

  @override
  String get playApduBadClass => 'Unsupported class';

  @override
  String get playApduCommand => 'Command';

  @override
  String get playApduResponse => 'Response';

  @override
  String get playApduData => 'Data';

  @override
  String get playApduStatus => 'Status';

  @override
  String get playApduNote =>
      'Simulation. The status words are real ISO 7816-4 codes.';

  @override
  String get apduSw9000 => 'Success';

  @override
  String get apduSw6A82 => 'File or application not found';

  @override
  String get apduSw6E00 => 'Class not supported';

  @override
  String get playChanTitle => 'Platform channel message';

  @override
  String get playChanIntro =>
      'A Flutter to Kotlin call is serialised into bytes before it crosses the boundary. These are the real bytes Flutter\'s standard codec produces.';

  @override
  String get playChanMethod => 'Method';

  @override
  String get playChanTimeout => 'Timeout (ms)';

  @override
  String playChanBytes(int count) {
    return '$count bytes on the wire';
  }

  @override
  String get playChanDecoded => 'Decoded on the native side';

  @override
  String get playChanNote => 'Encoded with StandardMethodCodec.';

  @override
  String get aboutTryIt => 'Try it in the Playground';

  @override
  String get traceOpenPlayground => 'Run these layers yourself';

  @override
  String get engBlueprint => 'Architecture blueprint';

  @override
  String engTiers(int count) {
    return '$count tiers';
  }

  @override
  String engSwipeHint(int current, int total) {
    return 'Swipe or tap to switch blueprints ($current of $total)';
  }

  @override
  String get engTryDemos => 'Try the NFC, crypto and sync demos';

  @override
  String get aboutStoryShort =>
      'I started in mobile in 2021. Since then my work has moved steadily down the stack, from screens to the native, security and sync layers underneath. I am comfortable inheriting a complicated legacy system and leaving it modular and testable.';

  @override
  String get engTabArchitectures => 'Architectures';

  @override
  String get engTabCapabilities => 'Capabilities';
}
