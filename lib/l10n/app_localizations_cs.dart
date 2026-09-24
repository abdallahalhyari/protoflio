// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get navHome => 'Domů';

  @override
  String get navWork => 'Projekty';

  @override
  String get navEngineering => 'Inženýrství';

  @override
  String get navExperience => 'Zkušenosti';

  @override
  String get navStack => 'Technologie';

  @override
  String get navAbout => 'O mně';

  @override
  String get navContact => 'Kontakt';

  @override
  String get navResume => 'Životopis';

  @override
  String get navSkills => 'Dovednosti';

  @override
  String get navProjects => 'Projekty';

  @override
  String get introLocation => 'Ammán, Jordánsko › Brno, Česká republika (2027)';

  @override
  String get sectionEducation => 'VZDĚLÁNÍ';

  @override
  String get sectionCertifications => 'CERTIFIKACE';

  @override
  String get contactHeroEyebrow => 'PŘÍMÝ E-MAIL · NEJRYCHLEJŠÍ ODPOVĚĎ';

  @override
  String get contactReplyWindow => 'Odpověď do 24 hodin · anglicky / arabsky';

  @override
  String get contactSendEmailBtn => 'ODESLAT E-MAIL';

  @override
  String get contactCopyAddressBtn => 'KOPÍROVAT ADRESU';

  @override
  String get skillsEmptyTitle =>
      'V této kategorii zatím nejsou žádné dovednosti';

  @override
  String get skillsEmptyShowAll => 'ZOBRAZIT VŠE';

  @override
  String get keyboardHintTitle => 'Klávesové zkratky';

  @override
  String get keyboardHintDigits => '1–7   přejít na sekci';

  @override
  String get keyboardHintArrows => 'Šipky nahoru / dolů · předchozí / další';

  @override
  String get keyboardHintHome => 'První stránka';

  @override
  String get keyboardHintEnd => 'Poslední stránka';

  @override
  String get closeTooltip => 'Zavřít';

  @override
  String get showHelpShortcut => 'Zobrazit tuto nápovědu';

  @override
  String resumeOpenError(Object publicUrl) {
    return 'Nepodařilo se otevřít životopis — navštivte $publicUrl';
  }

  @override
  String projectOpenError(Object url) {
    return 'Nepodařilo se otevřít $url';
  }

  @override
  String get spreadAction => 'ROZLOŽIT';

  @override
  String get alignAction => 'ZAROVNAT';

  @override
  String get previousAction => 'PŘEDCHOZÍ';

  @override
  String get nextAction => 'DALŠÍ';

  @override
  String emailCopied(Object email) {
    return 'E-mail zkopírován · $email';
  }

  @override
  String get viewMyWork => 'ZOBRAZIT PRÁCI';

  @override
  String get downloadResume => 'STÁHNOUT ŽIVOTOPIS';

  @override
  String get contactMe => 'KONTAKTUJTE MĚ';

  @override
  String get copyEmail => 'KOPÍROVAT E-MAIL';

  @override
  String get introSeniorEngineer => 'SENIOR MOBILNÍ VÝVOJÁŘ';

  @override
  String get introSystemArchitect => 'SYSTÉMOVÝ ARCHITEKT';

  @override
  String get introEuEligibility => 'OPRÁVNĚNÍ K PRÁCI V EU';

  @override
  String get introAvailableContracts => 'K DISPOZICI PRO KONTRAKTY';

  @override
  String get introMeticulouslyEngineered => 'Pečlivě navržené portfolio.';

  @override
  String get contactEngagementScopes => '// ROZSAHY SPOLUPRÁCE A REŽIMY';

  @override
  String get contactAtsVerified => 'ATS OVĚŘENO · EDICE 2026';

  @override
  String get contactPdfSize => 'PDF · 22 KB';

  @override
  String get contactCvDossierTitle => 'Exekutivní životopis a portfolio';

  @override
  String get contactCvDossierDesc =>
      'Kompletní chronologický záznam, případové studie podnikové architektury a inženýrské kompetence.';

  @override
  String get contactDownloadCvPdf => 'STÁHNOUT ŽIVOTOPIS · PDF';

  @override
  String get contactPreview => 'NÁHLED';

  @override
  String get footerRightsReserved => '© 2026 · VŠECHNA PRÁVA VYHRAZENA';

  @override
  String get contactInitiateEncrypted => 'ZAHÁJIT ŠIFROVANÉ VLÁKNO';

  @override
  String get contactStartConversation => 'ZAHÁJIT KONVERZACI';

  @override
  String get contactPhone => 'TELEFON';

  @override
  String get contactCall => 'Volat';

  @override
  String get contactWhatsapp => 'WHATSAPP';

  @override
  String get contactOpen => 'Otevřít';

  @override
  String get contactCopy => 'Kopírovat';

  @override
  String get contactLinkedin => 'LINKEDIN';

  @override
  String get contactProfile => 'Profil';

  @override
  String get contactGithub => 'GITHUB';

  @override
  String get contactVisit => 'Navštívit';

  @override
  String get semanticPortrait => 'Portrét Abdallaha Alhyariho';

  @override
  String get semanticTitle => 'Abdallah Alhyari, Senior mobilní vývojář';

  @override
  String folioIndicator(Object current, Object total) {
    return 'LIST $current / $total';
  }

  @override
  String get blocSectionTitle => 'BLoC / ČISTÁ ARCHITEKTURA';

  @override
  String get blocSectionSubtitle =>
      'Předvídatelná změna stavu pomocí jednosměrného toku dat';

  @override
  String get blocStep1Title => 'Odeslat událost';

  @override
  String get blocStep1Desc =>
      'UI spustí událost. V komponentách není žádná obchodní logika.';

  @override
  String get blocStep2Title => 'Mapovat na stav';

  @override
  String get blocStep2Desc =>
      'BLoC zpracuje událost a vytvoří nový neměnný stav.';

  @override
  String get blocStep3Title => 'Vykreslit výstup';

  @override
  String get blocStep3Desc =>
      'UI se efektivně přestavuje na základě přesných rozdílů stavu.';

  @override
  String get introIssueStrip => 'VYDÁNÍ 01 · EDICE PORTFOLIO · MMXXVI';

  @override
  String get introBuildsComplex =>
      'BUDUJE KOMPLEXNÍ, SPOLEHLIVÉ, ŠKÁLOVATELNÉ MOBILNÍ SYSTÉMY';

  @override
  String get introTechStack =>
      'Flutter · Android · iOS · Architektura · Offline-first · NFC · Bezpečnost · Real-time systémy';

  @override
  String get introBasedIn => 'SÍDLO';

  @override
  String get introStatus => 'STATUS';

  @override
  String get introOpenForRoles => 'OTEVŘENÝ PRO SENIORSKÉ POZICE';

  @override
  String get introDiscipline => 'OBOR';

  @override
  String get introMobileArch => 'MOBILNÍ ARCHITEKTURA';

  @override
  String get introMasthead => '// HLAVIČKA';

  @override
  String get navSectionCover => 'ÚVOD & PROFIL';

  @override
  String get navSubCover => 'Senior Flutter & Android Architekt';

  @override
  String get navSectionExperience => 'KARIÉRA & ZKUŠENOSTI';

  @override
  String get navSubExperience => '4+ roky vývoje a dopadu na podnikové systémy';

  @override
  String get navSectionWork => 'VYBRANÉ PROJEKTY';

  @override
  String get navSubWork => 'Produkční systémy a případové studie';

  @override
  String get navSectionStack => 'DOVEDNOSTI & TECHNOLOGIE';

  @override
  String get navSubStack => 'Matice technických kompetencí';

  @override
  String get navSectionEngineering => 'SYSTÉMOVÁ ARCHITEKTURA';

  @override
  String get navSubEngineering =>
      'Podnikové modely & offline-first architektura';

  @override
  String get navSectionAbout => 'PERSPEKTIVY & ROLE';

  @override
  String get navSubAbout => 'Architektonické úhly pohledu a role';

  @override
  String get navSectionContact => 'KONTAKT & DOTAZY';

  @override
  String get navSubContact => 'Přímé komunikační kanály a dostupnost';

  @override
  String selectedRoleAnnouncement(String role) {
    return 'Vybraná role: $role';
  }

  @override
  String copiedToClipboard(String value) {
    return 'Zkopírováno $value do schránky';
  }

  @override
  String get skillsSearchHint =>
      'Hledat dovednosti, nástroje nebo architektury...';

  @override
  String skillsCountAll(int count) {
    return '$count DOVEDNOSTÍ';
  }

  @override
  String skillsCountFiltered(int filtered, int total) {
    return '$filtered Z $total DOVEDNOSTÍ';
  }

  @override
  String get skillsClearSearch => 'VYMAZAT HLEDÁNÍ';

  @override
  String get perspectivePrev => 'PŘEDCHOZÍ ROLE';

  @override
  String get perspectiveNext => 'DALŠÍ ROLE';

  @override
  String get perspectiveShortcutsHint =>
      'Šipky nebo A / D k procházení · S zamíchat · R zarovnat';

  @override
  String get sectionSubtitleWork =>
      'Podrobný pohled na architekturu, implementaci a měřitelné výsledky.';

  @override
  String get sectionSubtitleExperience =>
      'Víceletý vývoj podnikových mobilních systémů';

  @override
  String get sectionSubtitleSkills =>
      'Disciplíny a technologie, na kterých práce stojí · Klepnutím kartu otočíte';

  @override
  String get sectionSubtitleEngineering =>
      'Architektury ověřené v produkci, na kterých stojí mobilní aplikace';

  @override
  String get sectionSubtitleAbout =>
      'Šest rolí, mezi kterými senior inženýr přepíná';
}
