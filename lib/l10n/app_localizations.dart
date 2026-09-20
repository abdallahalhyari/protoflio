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
  /// **'Stack'**
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
  /// **'Resume'**
  String get navResume;

  /// No description provided for @navSkills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get navSkills;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @introLocation.
  ///
  /// In en, this message translates to:
  /// **'Amman, Jordan → Brno, Czech Republic (2027)'**
  String get introLocation;

  /// No description provided for @sectionEducation.
  ///
  /// In en, this message translates to:
  /// **'EDUCATION'**
  String get sectionEducation;

  /// No description provided for @sectionCertifications.
  ///
  /// In en, this message translates to:
  /// **'CERTIFICATIONS'**
  String get sectionCertifications;

  /// No description provided for @contactHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'DIRECT EMAIL · FASTEST REPLY'**
  String get contactHeroEyebrow;

  /// No description provided for @contactReplyWindow.
  ///
  /// In en, this message translates to:
  /// **'Replies within 24 hours · English / Arabic'**
  String get contactReplyWindow;

  /// No description provided for @contactSendEmailBtn.
  ///
  /// In en, this message translates to:
  /// **'SEND EMAIL'**
  String get contactSendEmailBtn;

  /// No description provided for @contactCopyAddressBtn.
  ///
  /// In en, this message translates to:
  /// **'COPY ADDRESS'**
  String get contactCopyAddressBtn;

  /// No description provided for @skillsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No skills in this category yet'**
  String get skillsEmptyTitle;

  /// No description provided for @skillsEmptyShowAll.
  ///
  /// In en, this message translates to:
  /// **'SHOW ALL'**
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
  /// **'↑ ↓   prev / next page'**
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
  /// **'SPREAD'**
  String get spreadAction;

  /// No description provided for @alignAction.
  ///
  /// In en, this message translates to:
  /// **'ALIGN'**
  String get alignAction;

  /// No description provided for @previousAction.
  ///
  /// In en, this message translates to:
  /// **'PREV'**
  String get previousAction;

  /// No description provided for @nextAction.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get nextAction;

  /// No description provided for @emailCopied.
  ///
  /// In en, this message translates to:
  /// **'Email copied · {email}'**
  String emailCopied(Object email);

  /// No description provided for @viewMyWork.
  ///
  /// In en, this message translates to:
  /// **'VIEW MY WORK'**
  String get viewMyWork;

  /// No description provided for @downloadResume.
  ///
  /// In en, this message translates to:
  /// **'DOWNLOAD RESUME'**
  String get downloadResume;

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
  /// **'SENIOR MOBILE ENGINEER'**
  String get introSeniorEngineer;

  /// No description provided for @introSystemArchitect.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM ARCHITECT'**
  String get introSystemArchitect;

  /// No description provided for @introEuEligibility.
  ///
  /// In en, this message translates to:
  /// **'EU WORK ELIGIBILITY'**
  String get introEuEligibility;

  /// No description provided for @introAvailableContracts.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE FOR CONTRACTS'**
  String get introAvailableContracts;

  /// No description provided for @introMeticulouslyEngineered.
  ///
  /// In en, this message translates to:
  /// **'A meticulously engineered portfolio.'**
  String get introMeticulouslyEngineered;

  /// No description provided for @contactEngagementScopes.
  ///
  /// In en, this message translates to:
  /// **'// ENGAGEMENT SCOPES & COLLABORATION MODES'**
  String get contactEngagementScopes;

  /// No description provided for @contactAtsVerified.
  ///
  /// In en, this message translates to:
  /// **'ATS-VERIFIED · 2026 EDITION'**
  String get contactAtsVerified;

  /// No description provided for @contactPdfSize.
  ///
  /// In en, this message translates to:
  /// **'PDF · 240 KB'**
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
  /// **'DOWNLOAD CV · PDF'**
  String get contactDownloadCvPdf;

  /// No description provided for @contactPreview.
  ///
  /// In en, this message translates to:
  /// **'PREVIEW'**
  String get contactPreview;

  /// No description provided for @footerRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'© 2026 · ALL RIGHTS RESERVED'**
  String get footerRightsReserved;

  /// No description provided for @contactInitiateEncrypted.
  ///
  /// In en, this message translates to:
  /// **'INITIATE ENCRYPTED THREAD'**
  String get contactInitiateEncrypted;

  /// No description provided for @contactStartConversation.
  ///
  /// In en, this message translates to:
  /// **'START A CONVERSATION'**
  String get contactStartConversation;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get contactPhone;

  /// No description provided for @contactCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get contactCall;

  /// No description provided for @contactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP'**
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
  /// **'LINKEDIN'**
  String get contactLinkedin;

  /// No description provided for @contactProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get contactProfile;

  /// No description provided for @contactGithub.
  ///
  /// In en, this message translates to:
  /// **'GITHUB'**
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
  /// **'FOLIO {current} / {total}'**
  String folioIndicator(Object current, Object total);

  /// No description provided for @blocSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'BLoC / CLEAN ARCHITECTURE'**
  String get blocSectionTitle;

  /// No description provided for @blocSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Predictable state mutation via unidirectional data flow'**
  String get blocSectionSubtitle;

  /// No description provided for @blocStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Dispatch Event'**
  String get blocStep1Title;

  /// No description provided for @blocStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'UI triggers an event. No business logic in widgets.'**
  String get blocStep1Desc;

  /// No description provided for @blocStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Map to State'**
  String get blocStep2Title;

  /// No description provided for @blocStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'BLoC processes event, yields new immutable state.'**
  String get blocStep2Desc;

  /// No description provided for @blocStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Render Output'**
  String get blocStep3Title;

  /// No description provided for @blocStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'UI efficiently rebuilds based on strict state diffs.'**
  String get blocStep3Desc;

  /// No description provided for @introIssueStrip.
  ///
  /// In en, this message translates to:
  /// **'ISSUE 01 · PORTFOLIO EDITION · MMXXVI'**
  String get introIssueStrip;

  /// No description provided for @introBuildsComplex.
  ///
  /// In en, this message translates to:
  /// **'BUILDS COMPLEX, RELIABLE, SCALABLE MOBILE SYSTEMS'**
  String get introBuildsComplex;

  /// No description provided for @introTechStack.
  ///
  /// In en, this message translates to:
  /// **'Flutter · Android · iOS · Architecture · Offline-first · NFC · Security · Real-time systems'**
  String get introTechStack;

  /// No description provided for @introBasedIn.
  ///
  /// In en, this message translates to:
  /// **'BASED IN'**
  String get introBasedIn;

  /// No description provided for @introStatus.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get introStatus;

  /// No description provided for @introOpenForRoles.
  ///
  /// In en, this message translates to:
  /// **'OPEN FOR SENIOR ROLES'**
  String get introOpenForRoles;

  /// No description provided for @introDiscipline.
  ///
  /// In en, this message translates to:
  /// **'DISCIPLINE'**
  String get introDiscipline;

  /// No description provided for @introMobileArch.
  ///
  /// In en, this message translates to:
  /// **'MOBILE ARCHITECTURE'**
  String get introMobileArch;

  /// No description provided for @introMasthead.
  ///
  /// In en, this message translates to:
  /// **'// MASTHEAD'**
  String get introMasthead;

  /// No description provided for @navSectionCover.
  ///
  /// In en, this message translates to:
  /// **'COVER & PROFILE'**
  String get navSectionCover;

  /// No description provided for @navSubCover.
  ///
  /// In en, this message translates to:
  /// **'Senior Flutter & Android Architect'**
  String get navSubCover;

  /// No description provided for @navSectionExperience.
  ///
  /// In en, this message translates to:
  /// **'CAREER & EXPERIENCE'**
  String get navSectionExperience;

  /// No description provided for @navSubExperience.
  ///
  /// In en, this message translates to:
  /// **'4+ Years Enterprise Engineering & Impact'**
  String get navSubExperience;

  /// No description provided for @navSectionWork.
  ///
  /// In en, this message translates to:
  /// **'FEATURED WORK'**
  String get navSectionWork;

  /// No description provided for @navSubWork.
  ///
  /// In en, this message translates to:
  /// **'Production Systems & Case Studies'**
  String get navSubWork;

  /// No description provided for @navSectionStack.
  ///
  /// In en, this message translates to:
  /// **'SKILLS & STACK'**
  String get navSectionStack;

  /// No description provided for @navSubStack.
  ///
  /// In en, this message translates to:
  /// **'Technical Proficiency Matrix'**
  String get navSubStack;

  /// No description provided for @navSectionEngineering.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM ARCHITECTURES'**
  String get navSectionEngineering;

  /// No description provided for @navSubEngineering.
  ///
  /// In en, this message translates to:
  /// **'Enterprise Blueprints & Offline-First'**
  String get navSubEngineering;

  /// No description provided for @navSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'LEADERSHIP PERSPECTIVES'**
  String get navSectionAbout;

  /// No description provided for @navSubAbout.
  ///
  /// In en, this message translates to:
  /// **'Architectural Perspectives & Hats'**
  String get navSubAbout;

  /// No description provided for @navSectionContact.
  ///
  /// In en, this message translates to:
  /// **'CONTACT & INQUIRIES'**
  String get navSectionContact;

  /// No description provided for @navSubContact.
  ///
  /// In en, this message translates to:
  /// **'Direct Channels & Availability'**
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
  /// **'Search 24 skills, tools, or architectures...'**
  String get skillsSearchHint;

  /// No description provided for @skillsCountAll.
  ///
  /// In en, this message translates to:
  /// **'{count} SKILLS'**
  String skillsCountAll(int count);

  /// No description provided for @skillsCountFiltered.
  ///
  /// In en, this message translates to:
  /// **'{filtered} OF {total} SKILLS'**
  String skillsCountFiltered(int filtered, int total);

  /// No description provided for @skillsClearSearch.
  ///
  /// In en, this message translates to:
  /// **'CLEAR SEARCH'**
  String get skillsClearSearch;

  /// No description provided for @perspectivePrev.
  ///
  /// In en, this message translates to:
  /// **'PREV ROLE'**
  String get perspectivePrev;

  /// No description provided for @perspectiveNext.
  ///
  /// In en, this message translates to:
  /// **'NEXT ROLE'**
  String get perspectiveNext;

  /// No description provided for @perspectiveShortcutsHint.
  ///
  /// In en, this message translates to:
  /// **'← / → or A / D to cycle · S shuffle · R align'**
  String get perspectiveShortcutsHint;
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
