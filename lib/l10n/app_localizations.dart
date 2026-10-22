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
  /// **'About'**
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
  /// **'Amman, Jordan; Brno from February 2027'**
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

  /// No description provided for @skillsNoMatchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by tool or topic, for example Kotlin or offline sync.'**
  String get skillsNoMatchHint;

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
  /// **'Previous or next page'**
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

  /// No description provided for @shortcutJumpPrimary.
  ///
  /// In en, this message translates to:
  /// **'Jump to Work / Experience / Engineering'**
  String get shortcutJumpPrimary;

  /// No description provided for @shortcutJumpSecondary.
  ///
  /// In en, this message translates to:
  /// **'Jump to Skills / About / Contact'**
  String get shortcutJumpSecondary;

  /// No description provided for @shortcutToggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme mode'**
  String get shortcutToggleTheme;

  /// No description provided for @shortcutToggleAudio.
  ///
  /// In en, this message translates to:
  /// **'Mute / unmute audio'**
  String get shortcutToggleAudio;

  /// No description provided for @shortcutViewCv.
  ///
  /// In en, this message translates to:
  /// **'View CV'**
  String get shortcutViewCv;

  /// No description provided for @showHelpShortcut.
  ///
  /// In en, this message translates to:
  /// **'Show this help'**
  String get showHelpShortcut;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @changeLanguageCurrent.
  ///
  /// In en, this message translates to:
  /// **'Change language. Current: {code}'**
  String changeLanguageCurrent(String code);

  /// No description provided for @switchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get switchToLightMode;

  /// No description provided for @switchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get switchToDarkMode;

  /// No description provided for @muteSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Mute sound effects'**
  String get muteSoundEffects;

  /// No description provided for @enableSoundEffects.
  ///
  /// In en, this message translates to:
  /// **'Enable sound effects'**
  String get enableSoundEffects;

  /// No description provided for @soundEffectsOnTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects: ON (Click to mute)'**
  String get soundEffectsOnTooltip;

  /// No description provided for @soundEffectsMutedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects: MUTED (Click to enable)'**
  String get soundEffectsMutedTooltip;

  /// No description provided for @openNavigationMenu.
  ///
  /// In en, this message translates to:
  /// **'Open navigation menu'**
  String get openNavigationMenu;

  /// No description provided for @menuLabel.
  ///
  /// In en, this message translates to:
  /// **'MENU'**
  String get menuLabel;

  /// No description provided for @sectionNavigationLabel.
  ///
  /// In en, this message translates to:
  /// **'Section navigation'**
  String get sectionNavigationLabel;

  /// No description provided for @downloadResumePdf.
  ///
  /// In en, this message translates to:
  /// **'Download CV (PDF)'**
  String get downloadResumePdf;

  /// No description provided for @previousSection.
  ///
  /// In en, this message translates to:
  /// **'Previous section'**
  String get previousSection;

  /// No description provided for @nextSection.
  ///
  /// In en, this message translates to:
  /// **'Next section'**
  String get nextSection;

  /// No description provided for @scrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Scroll to top'**
  String get scrollToTop;

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

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied {email}'**
  String emailCopied(Object email);

  /// No description provided for @viewMyWork.
  ///
  /// In en, this message translates to:
  /// **'View my work'**
  String get viewMyWork;

  /// No description provided for @downloadResume.
  ///
  /// In en, this message translates to:
  /// **'Download CV'**
  String get downloadResume;

  /// Intro cover copy (the original design); downloadResume carries the site-wide wording.
  ///
  /// In en, this message translates to:
  /// **'Download CV'**
  String get introDownloadResume;

  /// No description provided for @introSeniorEngineer.
  ///
  /// In en, this message translates to:
  /// **'Senior mobile engineer'**
  String get introSeniorEngineer;

  /// No description provided for @introSummary.
  ///
  /// In en, this message translates to:
  /// **'Senior mobile engineer. I build Flutter and native Android apps that keep working offline, work with the device hardware and keep user data secure.'**
  String get introSummary;

  /// No description provided for @introAvailability.
  ///
  /// In en, this message translates to:
  /// **'Available now for remote and contract work. On-site in Brno from February 2027.'**
  String get introAvailability;

  /// No description provided for @introEmailMe.
  ///
  /// In en, this message translates to:
  /// **'Email me'**
  String get introEmailMe;

  /// Intro cover copy (the original design); introSeniorEngineer carries the site-wide wording.
  ///
  /// In en, this message translates to:
  /// **'Senior Flutter & Android engineer'**
  String get introRoleLine;

  /// No description provided for @introWorkEligibility.
  ///
  /// In en, this message translates to:
  /// **'Moving to Brno in February 2027'**
  String get introWorkEligibility;

  /// No description provided for @introAvailableContracts.
  ///
  /// In en, this message translates to:
  /// **'Available for contracts'**
  String get introAvailableContracts;

  /// No description provided for @contactPdfSize.
  ///
  /// In en, this message translates to:
  /// **'PDF, 22 KB'**
  String get contactPdfSize;

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

  /// No description provided for @contactDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get contactDownload;

  /// No description provided for @contactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get contactWhatsapp;

  /// No description provided for @cardFactAvailableValue.
  ///
  /// In en, this message translates to:
  /// **'Remote and contract work, now'**
  String get cardFactAvailableValue;

  /// No description provided for @cardFactBasedValue.
  ///
  /// In en, this message translates to:
  /// **'Amman, Jordan; Brno from February 2027'**
  String get cardFactBasedValue;

  /// No description provided for @cardFactStudyValue.
  ///
  /// In en, this message translates to:
  /// **'M.Sc. Open Informatics, Mendel University, from February 2027'**
  String get cardFactStudyValue;

  /// No description provided for @cardFactPermitValue.
  ///
  /// In en, this message translates to:
  /// **'Not needed in Czechia while studying full-time'**
  String get cardFactPermitValue;

  /// No description provided for @contactHiringValue.
  ///
  /// In en, this message translates to:
  /// **'Role, experience and stack on one page'**
  String get contactHiringValue;

  /// No description provided for @contactView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get contactView;

  /// No description provided for @contactVcard.
  ///
  /// In en, this message translates to:
  /// **'Contact card'**
  String get contactVcard;

  /// No description provided for @contactVcardValue.
  ///
  /// In en, this message translates to:
  /// **'Scan to save my details'**
  String get contactVcardValue;

  /// No description provided for @contactShowQr.
  ///
  /// In en, this message translates to:
  /// **'Show QR'**
  String get contactShowQr;

  /// No description provided for @contactViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get contactViewProfile;

  /// No description provided for @contactMessageWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Message {number} on WhatsApp'**
  String contactMessageWhatsapp(String number);

  /// No description provided for @contactCallNumber.
  ///
  /// In en, this message translates to:
  /// **'Call {number}'**
  String contactCallNumber(String number);

  /// No description provided for @contactLinkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get contactLinkedin;

  /// No description provided for @contactGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get contactGithub;

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

  /// No description provided for @introTechStack.
  ///
  /// In en, this message translates to:
  /// **'Flutter, Android, iOS, architecture, offline-first, NFC, security, real-time systems'**
  String get introTechStack;

  /// No description provided for @introBasedIn.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get introBasedIn;

  /// No description provided for @introStatus.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get introStatus;

  /// No description provided for @introOpenForRoles.
  ///
  /// In en, this message translates to:
  /// **'Open to senior mobile roles'**
  String get introOpenForRoles;

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
  /// **'About'**
  String get navSectionAbout;

  /// No description provided for @navSubAbout.
  ///
  /// In en, this message translates to:
  /// **'Background and availability'**
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

  /// No description provided for @sectionSubtitleWork.
  ///
  /// In en, this message translates to:
  /// **'Four employers, four systems. Each case shows the problem, how it was built, and what changed.'**
  String get sectionSubtitleWork;

  /// No description provided for @sectionSubtitleExperience.
  ///
  /// In en, this message translates to:
  /// **'Four roles since 2021, from shipping features to owning the native and security layer.'**
  String get sectionSubtitleExperience;

  /// No description provided for @projectDossierDecision.
  ///
  /// In en, this message translates to:
  /// **'Key decision'**
  String get projectDossierDecision;

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

  /// No description provided for @projectOutcomeFais.
  ///
  /// In en, this message translates to:
  /// **'Improved checkout completion and reduced abandoned transactions.'**
  String get projectOutcomeFais;

  /// No description provided for @contactHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Have a difficult mobile problem?'**
  String get contactHeaderTitle;

  /// No description provided for @contactHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send it over. I take on mobile architecture reviews and contract work now, and I am looking for a senior mobile role in Brno from February 2027. Email gets the fastest reply.'**
  String get contactHeaderSubtitle;

  /// No description provided for @skillsHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsHeaderTitle;

  /// No description provided for @skillsHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'What I work with and where I used it. Search a tool or filter by area.'**
  String get skillsHeaderSubtitle;

  /// No description provided for @sectionSubtitleEngineering.
  ///
  /// In en, this message translates to:
  /// **'The architectures behind my mobile suites: layers, offline sync, NFC and token security.'**
  String get sectionSubtitleEngineering;

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

  /// No description provided for @quickProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Hiring summary'**
  String get quickProfileTitle;

  /// No description provided for @quickProfileRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get quickProfileRole;

  /// No description provided for @quickProfileExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get quickProfileExperience;

  /// Years of professional experience.
  ///
  /// In en, this message translates to:
  /// **'{years}+ years in mobile engineering'**
  String quickProfileYears(int years);

  /// No description provided for @quickProfileStack.
  ///
  /// In en, this message translates to:
  /// **'Core stack'**
  String get quickProfileStack;

  /// No description provided for @quickProfileRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent roles'**
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

  /// No description provided for @quickProfileVcard.
  ///
  /// In en, this message translates to:
  /// **'vCard QR'**
  String get quickProfileVcard;

  /// No description provided for @vcardDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Recruiter contact card'**
  String get vcardDialogTitle;

  /// No description provided for @vcardScanHint.
  ///
  /// In en, this message translates to:
  /// **'Scan with your phone camera'**
  String get vcardScanHint;

  /// No description provided for @vcardCopyText.
  ///
  /// In en, this message translates to:
  /// **'Copy contact card'**
  String get vcardCopyText;

  /// No description provided for @vcardCopied.
  ///
  /// In en, this message translates to:
  /// **'Contact card copied to clipboard'**
  String get vcardCopied;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @studyCaseStudy.
  ///
  /// In en, this message translates to:
  /// **'{company} case study'**
  String studyCaseStudy(String company);

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
  /// **'60 FPS on dense data tables, 35% fewer crashes, and four enterprise platforms deployed.'**
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
  /// **'An m-commerce checkout and a fitness and media-streaming app, built around checkout requests that are safe to retry, defensive network handling and playback that survives interruptions.'**
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
  /// **'Higher checkout completion, fewer support tickets for failed orders, and live issues fixed from production data.'**
  String get studyFaisResult;

  /// No description provided for @studyFaisOutcome1.
  ///
  /// In en, this message translates to:
  /// **'Higher checkout completion and fewer abandoned carts.'**
  String get studyFaisOutcome1;

  /// No description provided for @studyFaisOutcome2.
  ///
  /// In en, this message translates to:
  /// **'Fewer support tickets for failed orders.'**
  String get studyFaisOutcome2;

  /// No description provided for @studyFaisOutcome3.
  ///
  /// In en, this message translates to:
  /// **'Live issues traced and fixed from production data.'**
  String get studyFaisOutcome3;

  /// No description provided for @skillCatAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get skillCatAll;

  /// No description provided for @skillCatDomain.
  ///
  /// In en, this message translates to:
  /// **'Domain expertise'**
  String get skillCatDomain;

  /// No description provided for @skillCatMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile systems'**
  String get skillCatMobile;

  /// No description provided for @skillCatSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & protocols'**
  String get skillCatSecurity;

  /// No description provided for @skillCatArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture & state'**
  String get skillCatArchitecture;

  /// No description provided for @skillCatCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud & infrastructure'**
  String get skillCatCloud;

  /// No description provided for @skillCatLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages & communication'**
  String get skillCatLanguages;

  /// No description provided for @archTopicClean.
  ///
  /// In en, this message translates to:
  /// **'Clean architecture'**
  String get archTopicClean;

  /// No description provided for @archTopicOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline-first sync'**
  String get archTopicOffline;

  /// No description provided for @archTopicNfc.
  ///
  /// In en, this message translates to:
  /// **'NFC smart cards (ISO 7816)'**
  String get archTopicNfc;

  /// No description provided for @archTopicKeystore.
  ///
  /// In en, this message translates to:
  /// **'Keystore and token lifecycle'**
  String get archTopicKeystore;

  /// No description provided for @archTopicState.
  ///
  /// In en, this message translates to:
  /// **'State management (BLoC)'**
  String get archTopicState;

  /// No description provided for @uiReadCaseStudy.
  ///
  /// In en, this message translates to:
  /// **'Read case study'**
  String get uiReadCaseStudy;

  /// No description provided for @projectNameNatHealth.
  ///
  /// In en, this message translates to:
  /// **'NatHealth Mobile Suite'**
  String get projectNameNatHealth;

  /// No description provided for @projectNameEskadenia.
  ///
  /// In en, this message translates to:
  /// **'E-Learning & Healthcare Enterprise Suite'**
  String get projectNameEskadenia;

  /// No description provided for @projectNameSolutions.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Rewards & Ephemeral Social Media Apps'**
  String get projectNameSolutions;

  /// No description provided for @projectNameFais.
  ///
  /// In en, this message translates to:
  /// **'M-Commerce & Media-Streaming Clients'**
  String get projectNameFais;

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

  /// No description provided for @uiRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get uiRetry;

  /// No description provided for @uiWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get uiWebsite;

  /// No description provided for @expRoleAtCompany.
  ///
  /// In en, this message translates to:
  /// **'{role} at {company}, {period}'**
  String expRoleAtCompany(String role, String company, String period);

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

  /// No description provided for @cardRole.
  ///
  /// In en, this message translates to:
  /// **'Senior mobile engineer'**
  String get cardRole;

  /// No description provided for @cardBase.
  ///
  /// In en, this message translates to:
  /// **'Amman; Brno from February 2027'**
  String get cardBase;

  /// No description provided for @coverWorkedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Worked at'**
  String get coverWorkedAtLabel;

  /// No description provided for @coverWorkedAtValue.
  ///
  /// In en, this message translates to:
  /// **'NatHealth, ESKADENIA, Solutions Now, FAIS'**
  String get coverWorkedAtValue;

  /// No description provided for @projectFigureValueNatHealth.
  ///
  /// In en, this message translates to:
  /// **'400,000+'**
  String get projectFigureValueNatHealth;

  /// No description provided for @projectFigureLabelNatHealth.
  ///
  /// In en, this message translates to:
  /// **'beneficiaries served across Jordan, Palestine and Iraq. Paper claims replaced by NFC cards.'**
  String get projectFigureLabelNatHealth;

  /// No description provided for @projectFigureValueEskadenia.
  ///
  /// In en, this message translates to:
  /// **'35%'**
  String get projectFigureValueEskadenia;

  /// No description provided for @projectFigureLabelEskadenia.
  ///
  /// In en, this message translates to:
  /// **'fewer crashes, with a steady 60 FPS on dense hospital data tables.'**
  String get projectFigureLabelEskadenia;

  /// No description provided for @projectFigureValueSolutions.
  ///
  /// In en, this message translates to:
  /// **'4.7+'**
  String get projectFigureValueSolutions;

  /// No description provided for @projectFigureLabelSolutions.
  ///
  /// In en, this message translates to:
  /// **'star store rating. Both apps shipped on time.'**
  String get projectFigureLabelSolutions;

  /// No description provided for @heroFactAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get heroFactAvailableLabel;

  /// No description provided for @heroFactPermitLabel.
  ///
  /// In en, this message translates to:
  /// **'Work permit'**
  String get heroFactPermitLabel;

  /// No description provided for @heroFactBasedLabel.
  ///
  /// In en, this message translates to:
  /// **'Based in'**
  String get heroFactBasedLabel;

  /// No description provided for @heroFactLanguagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get heroFactLanguagesLabel;

  /// No description provided for @heroFactLanguagesValue.
  ///
  /// In en, this message translates to:
  /// **'English (professional), Arabic (native)'**
  String get heroFactLanguagesValue;

  /// No description provided for @heroFactStudyLabel.
  ///
  /// In en, this message translates to:
  /// **'Studying'**
  String get heroFactStudyLabel;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who I am, where I\'m headed, and how to reach me.'**
  String get aboutHeaderSubtitle;

  /// No description provided for @aboutExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get aboutExperienceLabel;

  /// No description provided for @aboutExperienceValue.
  ///
  /// In en, this message translates to:
  /// **'{years}+ years in mobile'**
  String aboutExperienceValue(int years);

  /// No description provided for @aboutHoodHint.
  ///
  /// In en, this message translates to:
  /// **'Select a capability to see how I use it.'**
  String get aboutHoodHint;

  /// No description provided for @aboutWhereLabel.
  ///
  /// In en, this message translates to:
  /// **'Where I used it'**
  String get aboutWhereLabel;

  /// No description provided for @hoodNfcTitle.
  ///
  /// In en, this message translates to:
  /// **'NFC'**
  String get hoodNfcTitle;

  /// No description provided for @hoodNfcTag.
  ///
  /// In en, this message translates to:
  /// **'Secure card communication and authentication.'**
  String get hoodNfcTag;

  /// No description provided for @hoodNfcDetail.
  ///
  /// In en, this message translates to:
  /// **'A native Kotlin layer talks to smart cards over ISO 7816 APDUs. I designed the card-reader interface so several card technologies sit behind one contract.'**
  String get hoodNfcDetail;

  /// No description provided for @hoodNfcWhere.
  ///
  /// In en, this message translates to:
  /// **'NatHealth'**
  String get hoodNfcWhere;

  /// No description provided for @hoodCryptoTitle.
  ///
  /// In en, this message translates to:
  /// **'Cryptography'**
  String get hoodCryptoTitle;

  /// No description provided for @hoodCryptoTag.
  ///
  /// In en, this message translates to:
  /// **'RSA, AES and PBKDF2, with careful key handling.'**
  String get hoodCryptoTag;

  /// No description provided for @hoodCryptoDetail.
  ///
  /// In en, this message translates to:
  /// **'Two-step JWT issuance, secure token storage and GUID-based device binding keep sensitive patient data protected.'**
  String get hoodCryptoDetail;

  /// No description provided for @hoodCryptoWhere.
  ///
  /// In en, this message translates to:
  /// **'NatHealth'**
  String get hoodCryptoWhere;

  /// No description provided for @hoodBackgroundTitle.
  ///
  /// In en, this message translates to:
  /// **'Background processing'**
  String get hoodBackgroundTitle;

  /// No description provided for @hoodBackgroundTag.
  ///
  /// In en, this message translates to:
  /// **'Reliable sync and message processing.'**
  String get hoodBackgroundTag;

  /// No description provided for @hoodBackgroundDetail.
  ///
  /// In en, this message translates to:
  /// **'WorkManager runs background sync, status polling and token refresh, so work finishes without the user watching.'**
  String get hoodBackgroundDetail;

  /// No description provided for @hoodBackgroundWhere.
  ///
  /// In en, this message translates to:
  /// **'NatHealth'**
  String get hoodBackgroundWhere;

  /// No description provided for @hoodOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline-first'**
  String get hoodOfflineTitle;

  /// No description provided for @hoodOfflineTag.
  ///
  /// In en, this message translates to:
  /// **'Apps that keep working when connectivity disappears.'**
  String get hoodOfflineTag;

  /// No description provided for @hoodOfflineDetail.
  ///
  /// In en, this message translates to:
  /// **'Submissions are stored on the device and sent when the network returns, with exponential-backoff retries and standard failure handling.'**
  String get hoodOfflineDetail;

  /// No description provided for @hoodOfflineWhere.
  ///
  /// In en, this message translates to:
  /// **'NatHealth'**
  String get hoodOfflineWhere;

  /// No description provided for @hoodNativeTitle.
  ///
  /// In en, this message translates to:
  /// **'Native integration'**
  String get hoodNativeTitle;

  /// No description provided for @hoodNativeTag.
  ///
  /// In en, this message translates to:
  /// **'Flutter bridged to complex native Android.'**
  String get hoodNativeTag;

  /// No description provided for @hoodNativeDetail.
  ///
  /// In en, this message translates to:
  /// **'Platform channels connect Dart to Kotlin and Java code for hardware access that Flutter cannot reach on its own.'**
  String get hoodNativeDetail;

  /// No description provided for @hoodNativeWhere.
  ///
  /// In en, this message translates to:
  /// **'NatHealth'**
  String get hoodNativeWhere;

  /// No description provided for @hoodEnterpriseTitle.
  ///
  /// In en, this message translates to:
  /// **'Enterprise systems'**
  String get hoodEnterpriseTitle;

  /// No description provided for @hoodEnterpriseTag.
  ///
  /// In en, this message translates to:
  /// **'Healthcare, ERP and large business workflows.'**
  String get hoodEnterpriseTag;

  /// No description provided for @hoodEnterpriseDetail.
  ///
  /// In en, this message translates to:
  /// **'Modular architecture and reusable components across healthcare, e-learning and ERP clients, rebuilt without taking the apps offline.'**
  String get hoodEnterpriseDetail;

  /// No description provided for @hoodEnterpriseWhere.
  ///
  /// In en, this message translates to:
  /// **'ESKADENIA Software'**
  String get hoodEnterpriseWhere;

  /// No description provided for @projectLblProblem.
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get projectLblProblem;

  /// No description provided for @projectLblSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get projectLblSystem;

  /// No description provided for @projectLblRole.
  ///
  /// In en, this message translates to:
  /// **'My role'**
  String get projectLblRole;

  /// No description provided for @projectProblemNatHealth.
  ///
  /// In en, this message translates to:
  /// **'Paper claims, fraud risk and unreliable clinic connectivity slowed insurance claim processing.'**
  String get projectProblemNatHealth;

  /// No description provided for @projectSystemNatHealth.
  ///
  /// In en, this message translates to:
  /// **'Kotlin NFC bridge to smart cards, JWT with device binding, and an offline-first WorkManager queue.'**
  String get projectSystemNatHealth;

  /// No description provided for @projectRoleNatHealth.
  ///
  /// In en, this message translates to:
  /// **'Led mobile architecture, native NFC integration and security.'**
  String get projectRoleNatHealth;

  /// No description provided for @projectProblemEskadenia.
  ///
  /// In en, this message translates to:
  /// **'Legacy hospital and university apps dropped frames, tangled state together and used too much memory.'**
  String get projectProblemEskadenia;

  /// No description provided for @projectSystemEskadenia.
  ///
  /// In en, this message translates to:
  /// **'Decoupled MVVM feature packages, typed REST layers and cached repositories.'**
  String get projectSystemEskadenia;

  /// No description provided for @projectRoleEskadenia.
  ///
  /// In en, this message translates to:
  /// **'Led the architectural refactor, profiling and package extraction.'**
  String get projectRoleEskadenia;

  /// No description provided for @projectProblemSolutions.
  ///
  /// In en, this message translates to:
  /// **'Two high-volume consumer apps, a loyalty engine and real-time stories, had to ship on tight timelines.'**
  String get projectProblemSolutions;

  /// No description provided for @projectSystemSolutions.
  ///
  /// In en, this message translates to:
  /// **'A shared Flutter component library, hardware-accelerated camera and video pipelines, dynamic REST models.'**
  String get projectSystemSolutions;

  /// No description provided for @projectRoleSolutions.
  ///
  /// In en, this message translates to:
  /// **'Set the mobile design standards, built the camera pipelines and backend integration.'**
  String get projectRoleSolutions;

  /// No description provided for @projectProblemFais.
  ///
  /// In en, this message translates to:
  /// **'Multi-step checkout and continuous media streaming had to run without memory leaks or state races.'**
  String get projectProblemFais;

  /// No description provided for @projectSystemFais.
  ///
  /// In en, this message translates to:
  /// **'End-to-end checkout API integration with idempotency keys, and live issue diagnosis from telemetry.'**
  String get projectSystemFais;

  /// No description provided for @projectRoleFais.
  ///
  /// In en, this message translates to:
  /// **'Coordinated backend and frontend integration and resolved production issues.'**
  String get projectRoleFais;

  /// No description provided for @aboutTryIt.
  ///
  /// In en, this message translates to:
  /// **'Try it in the Playground'**
  String get aboutTryIt;

  /// No description provided for @engTiers.
  ///
  /// In en, this message translates to:
  /// **'{count} tiers'**
  String engTiers(int count);

  /// No description provided for @engInspectDiagram.
  ///
  /// In en, this message translates to:
  /// **'Zoom diagram'**
  String get engInspectDiagram;

  /// No description provided for @engTryDemos.
  ///
  /// In en, this message translates to:
  /// **'Try the NFC, crypto and sync demos'**
  String get engTryDemos;

  /// No description provided for @aboutStoryShort.
  ///
  /// In en, this message translates to:
  /// **'I started in mobile in 2021. Since then my work has moved steadily down the stack, from screens to the native, security and sync layers underneath. I am comfortable inheriting a complicated legacy system and leaving it modular and testable.'**
  String get aboutStoryShort;

  /// No description provided for @engTabArchitectures.
  ///
  /// In en, this message translates to:
  /// **'Architectures'**
  String get engTabArchitectures;

  /// No description provided for @engTabCapabilities.
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get engTabCapabilities;

  /// No description provided for @projectCopyCaseStudyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link to the {project} case study'**
  String projectCopyCaseStudyLink(String project);

  /// No description provided for @engResetZoom.
  ///
  /// In en, this message translates to:
  /// **'Reset zoom'**
  String get engResetZoom;

  /// No description provided for @brandBackToTop.
  ///
  /// In en, this message translates to:
  /// **'Abdallah Alhyari, back to top'**
  String get brandBackToTop;
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
