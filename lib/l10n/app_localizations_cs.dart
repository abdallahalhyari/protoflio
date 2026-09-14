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
  String get introLocation => 'Ammán, Jordánsko → Brno, Česká republika (2027)';

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
  String get keyboardHintArrows => '↑ ↓   předchozí / další';

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
}
