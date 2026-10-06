import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('cs'),
    Locale('en')
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get navWork;

  /// No description provided for @navEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get navEngineering;

  /// No description provided for @navExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get navExperience;

  /// No description provided for @navStack.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get navStack;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'Perspectives'**
  String get navAbout;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navContact;

  /// No description provided for @navResume.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get navResume;

  /// No description provided for @introLocation.
  ///
  /// In en, this message translates to:
  /// **'Amman → Brno · 2027'**
  String get introLocation;

  /// No description provided for @sectionEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get sectionEducation;

  /// No description provided for @sectionCertifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get sectionCertifications;

  /// No description provided for @contactHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactHeroEyebrow;

  /// No description provided for @contactReplyWindow.
  ///
  /// In en, this message translates to:
  /// **'Replies within 24 hours, in English or Arabic'**
  String get contactReplyWindow;

  /// No description provided for @contactSendEmailBtn.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get contactSendEmailBtn;

  /// No description provided for @contactCopyAddressBtn.
  ///
  /// In en, this message translates to:
  /// **'Copy address'**
  String get contactCopyAddressBtn;

  /// No description provided for @skillsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No skills in this category yet'**
  String get skillsEmptyTitle;

  /// Shown in the Skills section when the search finds nothing.
  ///
  /// In en, this message translates to:
  /// **'No skills match “{query}”'**
  String skillsNoMatch(String query);

  /// No description provided for @skillsEmptyShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all skills'**
  String get skillsEmptyShowAll;

  /// No description provided for @keyboardHintTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get keyboardHintTitle;

  /// No description provided for @keyboardHintDigits.
  ///
  /// In en, this message translates to:
  /// **'1–7   jump to section'**
  String get keyboardHintDigits;

  /// No description provided for @keyboardHintArrows.
  ///
  /// In en, this message translates to:
  /// **'Up and down arrows move between pages'**
  String get keyboardHintArrows;

  /// No description provided for @keyboardHintHome.
  ///
  /// In en, this message translates to:
  /// **'Home  first page'**
  String get keyboardHintHome;

  /// No description provided for @keyboardHintEnd.
  ///
  /// In en, this message translates to:
  /// **'End   last page'**
  String get keyboardHintEnd;

  /// No description provided for @closeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// No description provided for @showHelpShortcut.
  ///
  /// In en, this message translates to:
  /// **'Show this help'**
  String get showHelpShortcut;

  /// No description provided for @resumeOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open resume — visit {publicUrl}'**
  String resumeOpenError(Object publicUrl);

  /// No description provided for @projectOpenError.
  ///
  /// In en, this message translates to:
  /// **'Could not open {url}'**
  String projectOpenError(Object url);

  /// No description provided for @spreadAction.
  ///
  /// In en, this message translates to:
  /// **'Spread'**
  String get spreadAction;

  /// No description provided for @alignAction.
  ///
  /// In en, this message translates to:
  /// **'Align'**
  String get alignAction;

  /// No description provided for @previousAction.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousAction;

  /// No description provided for @nextAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextAction;

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied {email}'**
  String emailCopied(Object email);

  /// No description provided for @viewMyWork.
  ///
  /// In en, this message translates to:
  /// **'VIEW MY WORK'**
  String get viewMyWork;

  /// No description provided for @downloadResume.
  ///
  /// In en, this message translates to:
  /// **'Download CV'**
  String get downloadResume;

  /// Intro cover copy (the original design); downloadResume carries the site-wide wording.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOAD RESUME'**
  String get introDownloadResume;

  /// No description provided for @contactMe.
  ///
  /// In en, this message translates to:
  /// **'CONTACT ME'**
  String get contactMe;

  /// No description provided for @copyEmail.
  ///
  /// In en, this message translates to:
  /// **'COPY EMAIL'**
  String get copyEmail;

  /// No description provided for @introSeniorEngineer.
  ///
  /// In en, this message translates to:
  /// **'Senior Flutter & Android engineer'**
  String get introSeniorEngineer;

  /// Intro cover copy (the original design); introSeniorEngineer carries the site-wide wording.
  ///
  /// In en, this message translates to:
  /// **'SENIOR FLUTTER & ANDROID ENGINEER'**
  String get introRoleLine;

  /// No description provided for @introRoleHeading.
  ///
  /// In en, this message translates to:
  /// **'SENIOR FLUTTER & ANDROID ENGINEER'**
  String get introRoleHeading;

  /// No description provided for @introValueProposition.
  ///
  /// In en, this message translates to:
  /// **'I build production-grade mobile applications, from architecture and native integrations to release and long-term maintenance.'**
  String get introValueProposition;

  /// No description provided for @introSkillArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get introSkillArchitecture;

  /// No description provided for @introSkillProductDelivery.
  ///
  /// In en, this message translates to:
  /// **'Product delivery'**
  String get introSkillProductDelivery;

  /// No description provided for @introWorkEligibility.
  ///
  /// In en, this message translates to:
  /// **'RELOCATING TO BRNO · 2027   •   OPEN TO SENIOR MOBILE ROLES'**
  String get introWorkEligibility;

  /// No description provided for @introAvailableContracts.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE FOR CONTRACTS'**
  String get introAvailableContracts;

  /// No description provided for @contactEngagementScopes.
  ///
  /// In en, this message translates to:
  /// **'Ways to work together'**
  String get contactEngagementScopes;

  /// No description provided for @contactAtsVerified.
  ///
  /// In en, this message translates to:
  /// **'ATS-friendly, 2026 edition'**
  String get contactAtsVerified;

  /// No description provided for @contactPdfSize.
  ///
  /// In en, this message translates to:
  /// **'PDF, 22 KB'**
  String get contactPdfSize;

  /// No description provided for @contactCvDossierTitle.
  ///
  /// In en, this message translates to:
  /// **'Executive Curriculum Vitae & Portfolio Dossier'**
  String get contactCvDossierTitle;

  /// No description provided for @contactCvDossierDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete chronological track record, enterprise architecture case studies, and engineering competencies.'**
  String get contactCvDossierDesc;

  /// No description provided for @contactDownloadCvPdf.
  ///
  /// In en, this message translates to:
  /// **'Download CV (PDF)'**
  String get contactDownloadCvPdf;

  /// No description provided for @contactPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get contactPreview;

  /// No description provided for @footerRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'© 2026 Abdallah Alhyari'**
  String get footerRightsReserved;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhone;

  /// No description provided for @contactCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get contactCall;

  /// No description provided for @contactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get contactWhatsapp;

  /// No description provided for @contactOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get contactOpen;

  /// No description provided for @contactCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get contactCopy;

  /// No description provided for @contactLinkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get contactLinkedin;

  /// No description provided for @contactProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get contactProfile;

  /// No description provided for @contactGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get contactGithub;

  /// No description provided for @contactVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get contactVisit;

  /// No description provided for @semanticPortrait.
  ///
  /// In en, this message translates to:
  /// **'Portrait of Abdallah Alhyari'**
  String get semanticPortrait;

  /// No description provided for @semanticTitle.
  ///
  /// In en, this message translates to:
  /// **'Abdallah Alhyari, Senior Mobile Engineer'**
  String get semanticTitle;

  /// No description provided for @folioIndicator.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String folioIndicator(Object current, Object total);

  /// No description provided for @introIssueStrip.
  ///
  /// In en, this message translates to:
  /// **'LOCATION: AMMAN → BRNO · 2027   |   AVAILABILITY: OPEN TO SENIOR MOBILE ROLES   |   SPECIALIZATION: FLUTTER · ANDROID · MOBILE ARCHITECTURE'**
  String get introIssueStrip;

  /// No description provided for @introTechStack.
  ///
  /// In en, this message translates to:
  /// **'Flutter · Android · iOS · Architecture · Offline-first · NFC · Security · Real-time systems'**
  String get introTechStack;

  /// No description provided for @introBasedIn.
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get introBasedIn;

  /// No description provided for @introStatus.
  ///
  /// In en, this message translates to:
  /// **'AVAILABILITY'**
  String get introStatus;

  /// No description provided for @introOpenForRoles.
  ///
  /// In en, this message translates to:
  /// **'Open to Senior Mobile Roles'**
  String get introOpenForRoles;

  /// No description provided for @introDiscipline.
  ///
  /// In en, this message translates to:
  /// **'SPECIALIZATION'**
  String get introDiscipline;

  /// No description provided for @introMobileArch.
  ///
  /// In en, this message translates to:
  /// **'Flutter · Android · Mobile Architecture'**
  String get introMobileArch;

  /// No description provided for @introMasthead.
  ///
  /// In en, this message translates to:
  /// **'Masthead'**
  String get introMasthead;

  /// No description provided for @navSectionCover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get navSectionCover;

  /// No description provided for @navSubCover.
  ///
  /// In en, this message translates to:
  /// **'Senior Flutter & Android engineer'**
  String get navSubCover;

  /// No description provided for @navSectionExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get navSectionExperience;

  /// No description provided for @navSubExperience.
  ///
  /// In en, this message translates to:
  /// **'Five years of enterprise mobile work'**
  String get navSubExperience;

  /// No description provided for @navSectionWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get navSectionWork;

  /// No description provided for @navSubWork.
  ///
  /// In en, this message translates to:
  /// **'Case studies from production apps'**
  String get navSubWork;

  /// No description provided for @navSectionStack.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get navSectionStack;

  /// No description provided for @navSubStack.
  ///
  /// In en, this message translates to:
  /// **'Tools and disciplines'**
  String get navSubStack;

  /// No description provided for @navSectionEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get navSectionEngineering;

  /// No description provided for @navSubEngineering.
  ///
  /// In en, this message translates to:
  /// **'How the apps are built'**
  String get navSubEngineering;

  /// No description provided for @navSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'Perspectives'**
  String get navSectionAbout;

  /// No description provided for @navSubAbout.
  ///
  /// In en, this message translates to:
  /// **'How I work with teams'**
  String get navSubAbout;

  /// No description provided for @navSectionContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get navSectionContact;

  /// No description provided for @navSubContact.
  ///
  /// In en, this message translates to:
  /// **'Email, phone and profiles'**
  String get navSubContact;

  /// Screen reader announcement when selecting a role card in the engineering perspectives section
  ///
  /// In en, this message translates to:
  /// **'Selected role: {role}'**
  String selectedRoleAnnouncement(String role);

  /// Screen reader announcement when copying text to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied {value} to clipboard'**
  String copiedToClipboard(String value);

  /// No description provided for @skillsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search skills, tools, or architectures...'**
  String get skillsSearchHint;

  /// No description provided for @skillsCountAll.
  ///
  /// In en, this message translates to:
  /// **'{count} skills'**
  String skillsCountAll(int count);

  /// No description provided for @skillsCountFiltered.
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total} skills'**
  String skillsCountFiltered(int filtered, int total);

  /// No description provided for @skillsClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get skillsClearSearch;

  /// No description provided for @perspectivePrev.
  ///
  /// In en, this message translates to:
  /// **'Previous role'**
  String get perspectivePrev;

  /// No description provided for @perspectiveNext.
  ///
  /// In en, this message translates to:
  /// **'Next role'**
  String get perspectiveNext;

  /// No description provided for @perspectiveShortcutsHint.
  ///
  /// In en, this message translates to:
  /// **'Arrow keys or A and D to cycle, S to shuffle, R to align'**
  String get perspectiveShortcutsHint;

  /// No description provided for @sectionSubtitleWork.
  ///
  /// In en, this message translates to:
  /// **'In-depth looks at architecture, implementation, and measurable outcomes.'**
  String get sectionSubtitleWork;

  /// No description provided for @sectionSubtitleExperience.
  ///
  /// In en, this message translates to:
  /// **'Multi-year development of enterprise mobile systems'**
  String get sectionSubtitleExperience;

  /// No description provided for @projectsHeaderKicker.
  ///
  /// In en, this message translates to:
  /// **'Selected work'**
  String get projectsHeaderKicker;

  /// No description provided for @projectDomainAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get projectDomainAll;

  /// No description provided for @projectDomainHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare & Smart Cards'**
  String get projectDomainHealthcare;

  /// No description provided for @projectDomainEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise HIS & LMS'**
  String get projectDomainEnterprise;

  /// No description provided for @projectDomainFleet.
  ///
  /// In en, this message translates to:
  /// **'Fleet & Telematics'**
  String get projectDomainFleet;

  /// No description provided for @projectDomainCommerce.
  ///
  /// In en, this message translates to:
  /// **'M-Commerce & Streaming'**
  String get projectDomainCommerce;

  /// No description provided for @projectTechFilter.
  ///
  /// In en, this message translates to:
  /// **'Filtered by {technology}'**
  String projectTechFilter(String technology);

  /// No description provided for @readCaseStudyFor.
  ///
  /// In en, this message translates to:
  /// **'Read case study for {project}'**
  String readCaseStudyFor(String project);

  /// No description provided for @projectTaglineNatHealth.
  ///
  /// In en, this message translates to:
  /// **'Mission-critical NFC smart-card healthcare platform for mobile care, digital claims, and regulatory compliance.'**
  String get projectTaglineNatHealth;

  /// No description provided for @projectTaglineEskadenia.
  ///
  /// In en, this message translates to:
  /// **'High-performance enterprise mobile applications for hospital information systems and education platforms.'**
  String get projectTaglineEskadenia;

  /// No description provided for @projectTaglineSolutions.
  ///
  /// In en, this message translates to:
  /// **'A loyalty rewards platform and an ephemeral video and stories experience, built for consumer scale.'**
  String get projectTaglineSolutions;

  /// No description provided for @projectTaglineFais.
  ///
  /// In en, this message translates to:
  /// **'High-throughput commerce checkouts and continuous media-streaming applications.'**
  String get projectTaglineFais;

  /// No description provided for @projectOutcomeNatHealth.
  ///
  /// In en, this message translates to:
  /// **'Replaced paper claim submissions with instant contactless smart-card validation.'**
  String get projectOutcomeNatHealth;

  /// No description provided for @projectOutcomeEskadenia.
  ///
  /// In en, this message translates to:
  /// **'Sustained 60fps across complex, data-heavy hospital and university workflows.'**
  String get projectOutcomeEskadenia;

  /// No description provided for @projectOutcomeSolutions.
  ///
  /// In en, this message translates to:
  /// **'Shipped both applications on time with 4.7+ star store ratings.'**
  String get projectOutcomeSolutions;

  /// No description provided for @projectOutcomeFais.
  ///
  /// In en, this message translates to:
  /// **'Improved checkout completion and reduced abandoned transactions.'**
  String get projectOutcomeFais;

  /// No description provided for @skillMasteryLead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get skillMasteryLead;

  /// No description provided for @skillMasteryCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get skillMasteryCore;

  /// No description provided for @skillMasterySolid.
  ///
  /// In en, this message translates to:
  /// **'Solid'**
  String get skillMasterySolid;

  /// No description provided for @skillMasteryGrowing.
  ///
  /// In en, this message translates to:
  /// **'Growing'**
  String get skillMasteryGrowing;

  /// No description provided for @skillCardSemantics.
  ///
  /// In en, this message translates to:
  /// **'{skill}, {level} proficiency. Activate to flip and view details.'**
  String skillCardSemantics(String skill, String level);

  /// No description provided for @experienceHeaderKicker.
  ///
  /// In en, this message translates to:
  /// **'Career'**
  String get experienceHeaderKicker;

  /// No description provided for @engineeringHeaderKicker.
  ///
  /// In en, this message translates to:
  /// **'Systems architecture'**
  String get engineeringHeaderKicker;

  /// No description provided for @hatsHeaderKickerMobile.
  ///
  /// In en, this message translates to:
  /// **'Six roles'**
  String get hatsHeaderKickerMobile;

  /// No description provided for @hatsHeaderKickerDesktop.
  ///
  /// In en, this message translates to:
  /// **'Six roles'**
  String get hatsHeaderKickerDesktop;

  /// No description provided for @hatsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Product-minded engineering, clear communication, and practical leadership across teams, constraints, and high-stakes delivery.'**
  String get hatsHeaderSubtitle;

  /// No description provided for @contactHeaderKicker.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactHeaderKicker;

  /// No description provided for @contactHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell me what you\'re building.'**
  String get contactHeaderTitle;

  /// No description provided for @contactHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m looking for a senior mobile role in Brno or remote from 2027, and I take on architecture reviews and contract work in the meantime. Email gets the fastest reply.'**
  String get contactHeaderSubtitle;

  /// No description provided for @skillsHeaderKicker.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsHeaderKicker;

  /// No description provided for @skillsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsHeaderTitle;

  /// No description provided for @skillsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Flutter, Android, platform architecture, security, and delivery systems built for resilient product teams and high-trust experiences.'**
  String get skillsHeaderSubtitle;

  /// No description provided for @sectionSubtitleEngineering.
  ///
  /// In en, this message translates to:
  /// **'Production-tested architectures behind the mobile suites'**
  String get sectionSubtitleEngineering;

  /// Hint on flippable skill / role cards for touch viewports.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip'**
  String get flipHintTap;

  /// Hint on flippable skill / role cards for desktop (pointer) viewports.
  ///
  /// In en, this message translates to:
  /// **'Click to flip'**
  String get flipHintClick;

  /// Desktop footer link to the next section.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get folioNext;

  /// No description provided for @folioBackToStart.
  ///
  /// In en, this message translates to:
  /// **'Back to start'**
  String get folioBackToStart;

  /// Toast for a returning visitor, offering to jump back to the section they last viewed.
  ///
  /// In en, this message translates to:
  /// **'Welcome back — continue at {section}?'**
  String welcomeBack(String section);

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// Hero link that opens the recruiter summary sheet.
  ///
  /// In en, this message translates to:
  /// **'30-second profile'**
  String get quickProfile;

  /// No description provided for @quickProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Hiring summary'**
  String get quickProfileTitle;

  /// No description provided for @quickProfileRole.
  ///
  /// In en, this message translates to:
  /// **'ROLE'**
  String get quickProfileRole;

  /// No description provided for @quickProfileExperience.
  ///
  /// In en, this message translates to:
  /// **'EXPERIENCE'**
  String get quickProfileExperience;

  /// Years of professional experience.
  ///
  /// In en, this message translates to:
  /// **'{years}+ years in mobile engineering'**
  String quickProfileYears(int years);

  /// No description provided for @quickProfileStack.
  ///
  /// In en, this message translates to:
  /// **'CORE STACK'**
  String get quickProfileStack;

  /// No description provided for @quickProfileRecent.
  ///
  /// In en, this message translates to:
  /// **'RECENT ROLES'**
  String get quickProfileRecent;

  /// No description provided for @quickProfileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get quickProfileEmail;

  /// No description provided for @quickProfileCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy summary'**
  String get quickProfileCopy;

  /// No description provided for @quickProfileCopied.
  ///
  /// In en, this message translates to:
  /// **'Profile summary copied'**
  String get quickProfileCopied;

  /// No description provided for @studyCaseStudy.
  ///
  /// In en, this message translates to:
  /// **'Case study'**
  String get studyCaseStudy;

  /// No description provided for @studyProblem.
  ///
  /// In en, this message translates to:
  /// **'The problem'**
  String get studyProblem;

  /// No description provided for @studyRole.
  ///
  /// In en, this message translates to:
  /// **'My role'**
  String get studyRole;

  /// No description provided for @studyArchitecture.
  ///
  /// In en, this message translates to:
  /// **'System architecture'**
  String get studyArchitecture;

  /// No description provided for @studyOutcomes.
  ///
  /// In en, this message translates to:
  /// **'Outcomes'**
  String get studyOutcomes;

  /// No description provided for @studyLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get studyLessons;

  /// No description provided for @studyMore.
  ///
  /// In en, this message translates to:
  /// **'More case studies'**
  String get studyMore;

  /// No description provided for @studyDockProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get studyDockProblem;

  /// No description provided for @studyDockProblemShort.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get studyDockProblemShort;

  /// No description provided for @studyDockRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get studyDockRole;

  /// No description provided for @studyDockArch.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get studyDockArch;

  /// No description provided for @studyDockOutcomes.
  ///
  /// In en, this message translates to:
  /// **'Outcomes'**
  String get studyDockOutcomes;

  /// No description provided for @studyDockOutcomesShort.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get studyDockOutcomesShort;

  /// No description provided for @studyDockLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get studyDockLessons;

  /// No description provided for @studyBackToPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Back to portfolio'**
  String get studyBackToPortfolio;

  /// No description provided for @studyReadPercent.
  ///
  /// In en, this message translates to:
  /// **'{pct}% read'**
  String studyReadPercent(int pct);

  /// No description provided for @studyTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get studyTop;

  /// No description provided for @studyBackToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get studyBackToTop;

  /// No description provided for @studyJumpTo.
  ///
  /// In en, this message translates to:
  /// **'Jump to {chapter}'**
  String studyJumpTo(String chapter);

  /// No description provided for @studyChapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter {chapter}'**
  String studyChapter(String chapter);

  /// No description provided for @studyOfficialWebsite.
  ///
  /// In en, this message translates to:
  /// **'Company website'**
  String get studyOfficialWebsite;

  /// No description provided for @studyVisitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit {company} official website'**
  String studyVisitWebsite(String company);

  /// No description provided for @studyCompanyLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'Company LinkedIn'**
  String get studyCompanyLinkedIn;

  /// No description provided for @studyViewOnLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'View {company} on LinkedIn'**
  String studyViewOnLinkedIn(String company);

  /// No description provided for @studyShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get studyShare;

  /// No description provided for @studyShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Copy direct link to this case study'**
  String get studyShareTooltip;

  /// No description provided for @studyShareSemantics.
  ///
  /// In en, this message translates to:
  /// **'Share direct link to {title} case study'**
  String studyShareSemantics(String title);

  /// No description provided for @studyShareButton.
  ///
  /// In en, this message translates to:
  /// **'Share case study link'**
  String get studyShareButton;

  /// No description provided for @studyLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Case study link copied: {url}'**
  String studyLinkCopied(String url);

  /// No description provided for @studyGlanceKicker.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get studyGlanceKicker;

  /// No description provided for @studyGlance.
  ///
  /// In en, this message translates to:
  /// **'At a glance'**
  String get studyGlance;

  /// No description provided for @studyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get studyChallenge;

  /// No description provided for @studyBuilt.
  ///
  /// In en, this message translates to:
  /// **'What I built'**
  String get studyBuilt;

  /// No description provided for @studyResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get studyResult;

  /// No description provided for @studySeeOutcomes.
  ///
  /// In en, this message translates to:
  /// **'See all outcomes'**
  String get studySeeOutcomes;

  /// Shown above the English technical chapters in other locales; empty in English.
  ///
  /// In en, this message translates to:
  /// **''**
  String get studyEnglishNote;

  /// No description provided for @studyOutcomeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Key outcome metric: {headline}. {body}'**
  String studyOutcomeSemantics(String headline, String body);

  /// No description provided for @studyPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get studyPresent;

  /// No description provided for @studyRoleMobileDev.
  ///
  /// In en, this message translates to:
  /// **'Mobile developer'**
  String get studyRoleMobileDev;

  /// No description provided for @studyRoleFlutterDev.
  ///
  /// In en, this message translates to:
  /// **'Flutter developer'**
  String get studyRoleFlutterDev;

  /// No description provided for @studyNatIntro.
  ///
  /// In en, this message translates to:
  /// **'Mission-critical NFC smart-card healthcare platform serving Jordan\'s largest health-insurance TPA. Ring App, E-Health Gate, and Compliance System — shipped as three coordinated clients on a shared architecture.'**
  String get studyNatIntro;

  /// No description provided for @studyNatChallenge.
  ///
  /// In en, this message translates to:
  /// **'Paper claims slowed reimbursement and exposed Jordan\'s largest health-insurance TPA to fraud, and many clinics had unreliable connectivity.'**
  String get studyNatChallenge;

  /// No description provided for @studyNatBuilt.
  ///
  /// In en, this message translates to:
  /// **'A three-app NFC smart-card suite: a native Kotlin APDU bridge, an offline-first WorkManager sync pipeline, and hardware-bound JWT tokens.'**
  String get studyNatBuilt;

  /// No description provided for @studyNatResult.
  ///
  /// In en, this message translates to:
  /// **'Card verification in under a second, claims that survive connectivity drops, zero security breaches, and three clients shipped on one architecture.'**
  String get studyNatResult;

  /// No description provided for @studyNatOutcome1.
  ///
  /// In en, this message translates to:
  /// **'contactless card verification, flagship to budget handsets'**
  String get studyNatOutcome1;

  /// No description provided for @studyNatOutcome2.
  ///
  /// In en, this message translates to:
  /// **'reliable offline batch sync during connectivity drops'**
  String get studyNatOutcome2;

  /// No description provided for @studyNatOutcome3.
  ///
  /// In en, this message translates to:
  /// **'security breaches under hardware-bound token lifecycle'**
  String get studyNatOutcome3;

  /// No description provided for @studyNatOutcome4.
  ///
  /// In en, this message translates to:
  /// **'coordinated clients shipped on the shared architecture'**
  String get studyNatOutcome4;

  /// No description provided for @studyEskIntro.
  ///
  /// In en, this message translates to:
  /// **'High-performance enterprise mobile architecture powering Hospital Information Systems (HIS) and Education platforms across the MENA region. Rebuilt legacy monolithic codebases into decoupled, testable feature packages with zero operational downtime.'**
  String get studyEskIntro;

  /// No description provided for @studyEskChallenge.
  ///
  /// In en, this message translates to:
  /// **'Legacy monolithic hospital and university apps stuttered on dense records and crashed on low-spec ward tablets during long shifts.'**
  String get studyEskChallenge;

  /// No description provided for @studyEskBuilt.
  ///
  /// In en, this message translates to:
  /// **'An incremental MVVM refactor into decoupled feature packages with cached repositories and typed contracts, profiled with DevTools, with zero downtime.'**
  String get studyEskBuilt;

  /// No description provided for @studyEskResult.
  ///
  /// In en, this message translates to:
  /// **'60 FPS on dense data tables, 35% fewer crashes, 1,000+ records rendered smoothly, and four enterprise platforms deployed.'**
  String get studyEskResult;

  /// No description provided for @studyEskOutcome1.
  ///
  /// In en, this message translates to:
  /// **'sustained frame rate on dense hospital data tables and medical charts'**
  String get studyEskOutcome1;

  /// No description provided for @studyEskOutcome2.
  ///
  /// In en, this message translates to:
  /// **'reduction in client-side crash rate across multi-hour clinical shifts'**
  String get studyEskOutcome2;

  /// No description provided for @studyEskOutcome3.
  ///
  /// In en, this message translates to:
  /// **'patient and student records rendered with zero viewport latency'**
  String get studyEskOutcome3;

  /// No description provided for @studyEskOutcome4.
  ///
  /// In en, this message translates to:
  /// **'enterprise platforms deployed (HIS, Clinic, University, School)'**
  String get studyEskOutcome4;

  /// No description provided for @studySolIntro.
  ///
  /// In en, this message translates to:
  /// **'High-throughput consumer iOS and Android applications: a real-time loyalty redemption engine and a Snapchat-style ephemeral video/story camera platform. Built with hardware-accelerated video pipelines and an internal reusable design system.'**
  String get studySolIntro;

  /// No description provided for @studySolChallenge.
  ///
  /// In en, this message translates to:
  /// **'Two consumer apps (loyalty rewards and ephemeral video stories) on compressed deadlines, with camera pipelines that leaked and distorted across Android OEMs.'**
  String get studySolChallenge;

  /// No description provided for @studySolBuilt.
  ///
  /// In en, this message translates to:
  /// **'A hardware-accelerated camera and video engine, background isolates that compress media before S3 upload, and a shared design-token library for both apps.'**
  String get studySolBuilt;

  /// No description provided for @studySolResult.
  ///
  /// In en, this message translates to:
  /// **'Both apps launched on schedule with a 4.7+ store rating, 40% faster feature turnaround, and zero dropped frames in the story carousel.'**
  String get studySolResult;

  /// No description provided for @studySolOutcome1.
  ///
  /// In en, this message translates to:
  /// **'average star rating across iOS App Store and Google Play'**
  String get studySolOutcome1;

  /// No description provided for @studySolOutcome2.
  ///
  /// In en, this message translates to:
  /// **'reduction in subsequent feature turnaround time via shared component library'**
  String get studySolOutcome2;

  /// No description provided for @studySolOutcome3.
  ///
  /// In en, this message translates to:
  /// **'dropped frames during horizontal story carousel gesture navigation'**
  String get studySolOutcome3;

  /// No description provided for @studySolOutcome4.
  ///
  /// In en, this message translates to:
  /// **'production consumer applications launched simultaneously on schedule'**
  String get studySolOutcome4;

  /// No description provided for @studyFaisIntro.
  ///
  /// In en, this message translates to:
  /// **'High-throughput commercial m-commerce checkout funnels and continuous media-streaming fitness applications. Engineered with atomic checkout transactions, defensive network interceptors, and resilient audio/video streaming.'**
  String get studyFaisIntro;

  /// No description provided for @studyFaisChallenge.
  ///
  /// In en, this message translates to:
  /// **'Checkout drops on flaky networks caused duplicate charges and abandoned carts, and OEM battery savers killed streaming playback.'**
  String get studyFaisChallenge;

  /// No description provided for @studyFaisBuilt.
  ///
  /// In en, this message translates to:
  /// **'Idempotent checkout with client-side state reconciliation, defensive network interceptors, and a foreground-service streaming buffer manager.'**
  String get studyFaisBuilt;

  /// No description provided for @studyFaisResult.
  ///
  /// In en, this message translates to:
  /// **'99.8% checkout completion with zero duplicate charges, 45% fewer support escalations, and cart reconciliation under 200ms.'**
  String get studyFaisResult;

  /// No description provided for @studyFaisOutcome1.
  ///
  /// In en, this message translates to:
  /// **'successful checkout transaction completion rate with zero duplicate charges'**
  String get studyFaisOutcome1;

  /// No description provided for @studyFaisOutcome2.
  ///
  /// In en, this message translates to:
  /// **'reduction in customer support escalation tickets for failed checkout orders'**
  String get studyFaisOutcome2;

  /// No description provided for @studyFaisOutcome3.
  ///
  /// In en, this message translates to:
  /// **'instantaneous cart calculation and state reconciliation latency'**
  String get studyFaisOutcome3;

  /// No description provided for @studyFaisOutcome4.
  ///
  /// In en, this message translates to:
  /// **'daily active sessions supported across commercial commerce funnels'**
  String get studyFaisOutcome4;

  /// No description provided for @skillCatAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get skillCatAll;

  /// No description provided for @skillCatDomain.
  ///
  /// In en, this message translates to:
  /// **'Domain Expertise'**
  String get skillCatDomain;

  /// No description provided for @skillCatMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Systems'**
  String get skillCatMobile;

  /// No description provided for @skillCatSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & Protocols'**
  String get skillCatSecurity;

  /// No description provided for @skillCatArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture & State'**
  String get skillCatArchitecture;

  /// No description provided for @skillCatCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud & Infrastructure'**
  String get skillCatCloud;

  /// No description provided for @skillCatLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages & Comm'**
  String get skillCatLanguages;

  /// No description provided for @hatThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get hatThinking;

  /// No description provided for @hatCommunicating.
  ///
  /// In en, this message translates to:
  /// **'Communicating'**
  String get hatCommunicating;

  /// No description provided for @hatSorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get hatSorting;

  /// No description provided for @hatBuilding.
  ///
  /// In en, this message translates to:
  /// **'Building'**
  String get hatBuilding;

  /// No description provided for @hatFixing.
  ///
  /// In en, this message translates to:
  /// **'Fixing'**
  String get hatFixing;

  /// No description provided for @hatCompassion.
  ///
  /// In en, this message translates to:
  /// **'Compassion'**
  String get hatCompassion;

  /// No description provided for @archTopicClean.
  ///
  /// In en, this message translates to:
  /// **'Clean Mobile Architecture'**
  String get archTopicClean;

  /// No description provided for @archTopicOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline-First Synchronization'**
  String get archTopicOffline;

  /// No description provided for @archTopicNfc.
  ///
  /// In en, this message translates to:
  /// **'ISO-7816 Smart-Card & NFC Pipeline'**
  String get archTopicNfc;

  /// No description provided for @archTopicKeystore.
  ///
  /// In en, this message translates to:
  /// **'Hardware-Backed Keystore & JWT Lifecycle'**
  String get archTopicKeystore;

  /// No description provided for @archTopicState.
  ///
  /// In en, this message translates to:
  /// **'Reactive State Management (BLoC)'**
  String get archTopicState;

  /// No description provided for @uiComposeInquiry.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get uiComposeInquiry;

  /// No description provided for @uiPresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Start from a template'**
  String get uiPresetsTitle;

  /// No description provided for @uiActiveHours.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get uiActiveHours;

  /// No description provided for @uiStandbyAsync.
  ///
  /// In en, this message translates to:
  /// **'Replies within a day'**
  String get uiStandbyAsync;

  /// No description provided for @uiRelocating.
  ///
  /// In en, this message translates to:
  /// **'Moving to Brno, 2027'**
  String get uiRelocating;

  /// No description provided for @uiInquireTrack.
  ///
  /// In en, this message translates to:
  /// **'Ask about this'**
  String get uiInquireTrack;

  /// No description provided for @uiComposerTitle.
  ///
  /// In en, this message translates to:
  /// **'Write a message'**
  String get uiComposerTitle;

  /// No description provided for @uiSelectTrack.
  ///
  /// In en, this message translates to:
  /// **'What is this about?'**
  String get uiSelectTrack;

  /// No description provided for @uiCopyDraft.
  ///
  /// In en, this message translates to:
  /// **'Copy draft'**
  String get uiCopyDraft;

  /// No description provided for @uiSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get uiSending;

  /// No description provided for @uiSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get uiSendMessage;

  /// No description provided for @uiOpenEmailClient.
  ///
  /// In en, this message translates to:
  /// **'Open in email app'**
  String get uiOpenEmailClient;

  /// No description provided for @uiReadCaseStudy.
  ///
  /// In en, this message translates to:
  /// **'Read case study'**
  String get uiReadCaseStudy;

  /// No description provided for @uiNoCaseStudies.
  ///
  /// In en, this message translates to:
  /// **'No case studies match these filters'**
  String get uiNoCaseStudies;

  /// No description provided for @uiResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get uiResetFilters;

  /// No description provided for @uiScrollToExplore.
  ///
  /// In en, this message translates to:
  /// **'Scroll to explore'**
  String get uiScrollToExplore;

  /// No description provided for @uiPortfolioSections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get uiPortfolioSections;

  /// No description provided for @uiDownloadResumePdf.
  ///
  /// In en, this message translates to:
  /// **'Download CV (PDF)'**
  String get uiDownloadResumePdf;

  /// No description provided for @uiDragCardsHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the cards, click one to flip it, or shuffle'**
  String get uiDragCardsHint;

  /// No description provided for @uiTapSwipeHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a card to flip it, swipe to change role'**
  String get uiTapSwipeHint;

  /// No description provided for @uiTapToReturn.
  ///
  /// In en, this message translates to:
  /// **'Tap to return'**
  String get uiTapToReturn;

  /// No description provided for @uiArchFlowchart.
  ///
  /// In en, this message translates to:
  /// **'Flowchart'**
  String get uiArchFlowchart;

  /// No description provided for @uiArchRationale.
  ///
  /// In en, this message translates to:
  /// **'Why this choice'**
  String get uiArchRationale;

  /// No description provided for @uiKeySafeguards.
  ///
  /// In en, this message translates to:
  /// **'Safeguards'**
  String get uiKeySafeguards;

  /// No description provided for @uiLatencyBudget.
  ///
  /// In en, this message translates to:
  /// **'Latency budget per layer'**
  String get uiLatencyBudget;

  /// No description provided for @uiActiveTrace.
  ///
  /// In en, this message translates to:
  /// **'Tracing'**
  String get uiActiveTrace;

  /// No description provided for @uiLatestDispatch.
  ///
  /// In en, this message translates to:
  /// **'Current role'**
  String get uiLatestDispatch;

  /// No description provided for @badgeSkills.
  ///
  /// In en, this message translates to:
  /// **'{count} disciplines'**
  String badgeSkills(int count);

  /// No description provided for @badgeCaseStudies.
  ///
  /// In en, this message translates to:
  /// **'{count} case studies'**
  String badgeCaseStudies(int count);

  /// No description provided for @badgeArchitectures.
  ///
  /// In en, this message translates to:
  /// **'{count} architectures'**
  String badgeArchitectures(int count);

  /// No description provided for @badgeRoles.
  ///
  /// In en, this message translates to:
  /// **'{count} roles'**
  String badgeRoles(int count);

  /// No description provided for @coverName.
  ///
  /// In en, this message translates to:
  /// **'Abdallah Alhyari'**
  String get coverName;

  /// No description provided for @coverStatement.
  ///
  /// In en, this message translates to:
  /// **'Mobile apps that work offline, read smart cards and keep patient data safe.'**
  String get coverStatement;

  /// No description provided for @coverLead.
  ///
  /// In en, this message translates to:
  /// **'I\'m a senior Flutter and Android engineer with five years on enterprise healthcare, education and commerce apps. Based in Amman, moving to Brno in 2027.'**
  String get coverLead;

  /// No description provided for @coverEmailPrefix.
  ///
  /// In en, this message translates to:
  /// **'Or email'**
  String get coverEmailPrefix;

  /// No description provided for @cardHintTap.
  ///
  /// In en, this message translates to:
  /// **'Tap the card to read its chip'**
  String get cardHintTap;

  /// No description provided for @cardHintClick.
  ///
  /// In en, this message translates to:
  /// **'Click the card to read its chip'**
  String get cardHintClick;

  /// No description provided for @cardHintTurnBackTap.
  ///
  /// In en, this message translates to:
  /// **'Tap the card again to turn it over'**
  String get cardHintTurnBackTap;

  /// No description provided for @cardHintTurnBackClick.
  ///
  /// In en, this message translates to:
  /// **'Click the card again to turn it over'**
  String get cardHintTurnBackClick;

  /// No description provided for @cardSurname.
  ///
  /// In en, this message translates to:
  /// **'Alhyari'**
  String get cardSurname;

  /// No description provided for @cardGivenName.
  ///
  /// In en, this message translates to:
  /// **'Abdallah'**
  String get cardGivenName;

  /// No description provided for @cardFieldSurname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get cardFieldSurname;

  /// No description provided for @cardFieldGiven.
  ///
  /// In en, this message translates to:
  /// **'Given name'**
  String get cardFieldGiven;

  /// No description provided for @cardFieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get cardFieldRole;

  /// No description provided for @cardFieldBase.
  ///
  /// In en, this message translates to:
  /// **'Based in'**
  String get cardFieldBase;

  /// No description provided for @cardRole.
  ///
  /// In en, this message translates to:
  /// **'Senior mobile engineer'**
  String get cardRole;

  /// No description provided for @cardBase.
  ///
  /// In en, this message translates to:
  /// **'Amman, Brno from 2027'**
  String get cardBase;

  /// No description provided for @cardBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Read from the chip'**
  String get cardBackTitle;

  /// No description provided for @cardOutcome1.
  ///
  /// In en, this message translates to:
  /// **'Paper claims replaced by contactless smart-card checks'**
  String get cardOutcome1;

  /// No description provided for @cardOutcome2.
  ///
  /// In en, this message translates to:
  /// **'Sub-second NFC reads across a wide range of Android phones'**
  String get cardOutcome2;

  /// No description provided for @cardOutcome3.
  ///
  /// In en, this message translates to:
  /// **'35% fewer crashes and a steady 60 fps in data-heavy hospital apps'**
  String get cardOutcome3;

  /// No description provided for @cardSemantics.
  ///
  /// In en, this message translates to:
  /// **'Credential card for Abdallah Alhyari. Activate to read the chip and turn the card over.'**
  String get cardSemantics;

  /// No description provided for @coverHintDrag.
  ///
  /// In en, this message translates to:
  /// **'Drag the card onto the reader, or click it.'**
  String get coverHintDrag;

  /// No description provided for @coverHintTap.
  ///
  /// In en, this message translates to:
  /// **'Tap the card to read it.'**
  String get coverHintTap;

  /// No description provided for @coverGranted.
  ///
  /// In en, this message translates to:
  /// **'Access granted'**
  String get coverGranted;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
