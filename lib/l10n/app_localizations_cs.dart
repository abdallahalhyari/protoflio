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
  String get navWork => 'Práce';

  @override
  String get navEngineering => 'Inženýrství';

  @override
  String get navExperience => 'Zkušenosti';

  @override
  String get navStack => 'Dovednosti';

  @override
  String get navAbout => 'O mně';

  @override
  String get navContact => 'Kontakt';

  @override
  String get navResume => 'Životopis';

  @override
  String get introLocation => 'Ammán, Jordánsko; Brno od února 2027';

  @override
  String get sectionEducation => 'Vzdělání';

  @override
  String get sectionCertifications => 'Certifikace';

  @override
  String get contactHeroEyebrow => 'E-mail';

  @override
  String get contactReplyWindow => 'Odpověď do 24 hodin, anglicky nebo arabsky';

  @override
  String get contactSendEmailBtn => 'Odeslat e-mail';

  @override
  String get contactCopyAddressBtn => 'Kopírovat adresu';

  @override
  String get skillsEmptyTitle =>
      'V této kategorii zatím nejsou žádné dovednosti';

  @override
  String skillsNoMatch(String query) {
    return 'Hledání „$query“ nenašlo žádnou dovednost';
  }

  @override
  String get skillsNoMatchHint =>
      'Hledejte podle nástroje nebo tématu, například Kotlin nebo offline synchronizace.';

  @override
  String get skillsEmptyShowAll => 'Zobrazit vše';

  @override
  String get keyboardHintTitle => 'Klávesové zkratky';

  @override
  String get keyboardHintDigits => '1–7   přejít na sekci';

  @override
  String get keyboardHintArrows => 'Předchozí nebo další stránka';

  @override
  String get keyboardHintHome => 'První stránka';

  @override
  String get keyboardHintEnd => 'Poslední stránka';

  @override
  String get closeTooltip => 'Zavřít';

  @override
  String get shortcutJumpPrimary =>
      'Přejít na Práci / Zkušenosti / Inženýrství';

  @override
  String get shortcutJumpSecondary => 'Přejít na Dovednosti / O mně / Kontakt';

  @override
  String get shortcutToggleTheme => 'Přepnout režim motivu';

  @override
  String get shortcutToggleAudio => 'Ztlumit / zapnout zvuk';

  @override
  String get shortcutViewCv => 'Zobrazit životopis';

  @override
  String get showHelpShortcut => 'Zobrazit tuto nápovědu';

  @override
  String get changeLanguage => 'Změnit jazyk';

  @override
  String changeLanguageCurrent(String code) {
    return 'Změnit jazyk. Aktuální: $code';
  }

  @override
  String get switchToLightMode => 'Přepnout na světlý režim';

  @override
  String get switchToDarkMode => 'Přepnout na tmavý režim';

  @override
  String get muteSoundEffects => 'Ztlumit zvukové efekty';

  @override
  String get enableSoundEffects => 'Zapnout zvukové efekty';

  @override
  String get soundEffectsOnTooltip =>
      'Zvukové efekty: zapnuté (kliknutím ztlumíte)';

  @override
  String get soundEffectsMutedTooltip =>
      'Zvukové efekty: ztlumené (kliknutím zapnete)';

  @override
  String get openNavigationMenu => 'Otevřít navigační nabídku';

  @override
  String get menuLabel => 'NABÍDKA';

  @override
  String get sectionNavigationLabel => 'Navigace mezi sekcemi';

  @override
  String get downloadResumePdf => 'Stáhnout životopis (PDF)';

  @override
  String get previousSection => 'Předchozí sekce';

  @override
  String get nextSection => 'Další sekce';

  @override
  String get scrollToTop => 'Přejít nahoru';

  @override
  String resumeOpenError(Object publicUrl) {
    return 'Nepodařilo se otevřít životopis — navštivte $publicUrl';
  }

  @override
  String projectOpenError(Object url) {
    return 'Nepodařilo se otevřít $url';
  }

  @override
  String emailCopied(Object email) {
    return 'Zkopírováno: $email';
  }

  @override
  String get viewMyWork => 'Zobrazit práci';

  @override
  String get downloadResume => 'Stáhnout životopis';

  @override
  String get introDownloadResume => 'Stáhnout CV';

  @override
  String get introSeniorEngineer => 'Senior mobilní vývojář';

  @override
  String get introSummary =>
      'Senior mobilní vývojář. Stavím aplikace ve Flutteru a nativním Androidu, které fungují i offline, pracují s hardwarem zařízení a chrání data uživatelů.';

  @override
  String get introAvailability =>
      'Nyní k dispozici pro práci na dálku a zakázky. On-site v Brně od února 2027.';

  @override
  String get introEmailMe => 'Napište mi';

  @override
  String get introRoleLine => 'Senior mobilní vývojář';

  @override
  String get introWorkEligibility => 'Stěhování do Brna v únoru 2027';

  @override
  String get introAvailableContracts => 'K dispozici pro kontrakty';

  @override
  String get contactPdfSize => 'PDF, 22 KB';

  @override
  String get footerRightsReserved => '© 2026 Abdallah Alhyari';

  @override
  String get contactPhone => 'Telefon';

  @override
  String get contactCall => 'Volat';

  @override
  String get contactDownload => 'Stáhnout';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get cardFactAvailableValue => 'Práce na dálku a zakázky, hned';

  @override
  String get cardFactBasedValue => 'Ammán, Jordánsko; Brno od února 2027';

  @override
  String get cardFactStudyValue =>
      'M.Sc. Open Informatics, Mendelova univerzita, od února 2027';

  @override
  String get cardFactPermitValue =>
      'V Česku při studiu na plný úvazek není potřeba';

  @override
  String get contactHiringValue => 'Role, praxe a technologie na jedné straně';

  @override
  String get contactView => 'Zobrazit';

  @override
  String get contactVcard => 'Vizitka';

  @override
  String get contactVcardValue => 'Naskenujte a uložte si kontakt';

  @override
  String get contactShowQr => 'Zobrazit QR';

  @override
  String get contactViewProfile => 'Zobrazit';

  @override
  String contactMessageWhatsapp(String number) {
    return 'Napsat na WhatsApp $number';
  }

  @override
  String contactCallNumber(String number) {
    return 'Volat $number';
  }

  @override
  String get contactLinkedin => 'LinkedIn';

  @override
  String get contactGithub => 'GitHub';

  @override
  String get semanticPortrait => 'Portrét Abdallaha Alhyariho';

  @override
  String get semanticTitle => 'Abdallah Alhyari, Senior mobilní vývojář';

  @override
  String get introTechStack =>
      'Flutter, Android, iOS, architektura, offline-first, NFC, bezpečnost, real-time systémy';

  @override
  String get introBasedIn => 'Lokace';

  @override
  String get introStatus => 'Dostupnost';

  @override
  String get introOpenForRoles => 'Otevřen pro seniorní role';

  @override
  String get navSectionCover => 'Úvod';

  @override
  String get navSubCover => 'Senior Flutter & Android vývojář';

  @override
  String get navSectionExperience => 'Zkušenosti';

  @override
  String get navSubExperience => 'Pět let podnikového mobilního vývoje';

  @override
  String get navSectionWork => 'Práce';

  @override
  String get navSubWork => 'Případové studie z produkčních aplikací';

  @override
  String get navSectionStack => 'Dovednosti';

  @override
  String get navSubStack => 'Nástroje a disciplíny';

  @override
  String get navSectionEngineering => 'Inženýrství';

  @override
  String get navSubEngineering => 'Jak jsou aplikace postavené';

  @override
  String get navSectionAbout => 'O mně';

  @override
  String get navSubAbout => 'Zázemí a dostupnost';

  @override
  String get navSectionContact => 'Kontakt';

  @override
  String get navSubContact => 'E-mail, telefon a profily';

  @override
  String copiedToClipboard(String value) {
    return 'Zkopírováno $value do schránky';
  }

  @override
  String get skillsSearchHint =>
      'Hledat dovednosti, nástroje nebo architektury...';

  @override
  String skillsCountAll(int count) {
    return '$count dovedností';
  }

  @override
  String skillsCountFiltered(int filtered, int total) {
    return '$filtered z $total dovedností';
  }

  @override
  String get skillsClearSearch => 'Vymazat hledání';

  @override
  String get sectionSubtitleWork =>
      'Čtyři zaměstnavatelé, čtyři systémy. Každý případ ukazuje problém, jak byl postaven a co se změnilo.';

  @override
  String get sectionSubtitleExperience =>
      'Čtyři role od roku 2021, od dodávání funkcí po vlastnictví nativní a bezpečnostní vrstvy.';

  @override
  String get projectDossierDecision => 'Klíčové rozhodnutí';

  @override
  String readCaseStudyFor(String project) {
    return 'Přečíst případovou studii: $project';
  }

  @override
  String get projectTaglineNatHealth =>
      'Kritická zdravotnická platforma s NFC kartami pro digitální péči, pojistné nároky a dodržování předpisů.';

  @override
  String get projectTaglineEskadenia =>
      'Výkonné podnikové mobilní aplikace pro nemocniční informační systémy a vzdělávací platformy.';

  @override
  String get projectTaglineSolutions =>
      'Platforma věrnostních odměn a aplikace pro dočasná videa a příběhy navržené pro široké využití.';

  @override
  String get projectTaglineFais =>
      'Výkonné mobilní nákupní procesy a aplikace pro nepřetržité streamování médií.';

  @override
  String get projectOutcomeNatHealth =>
      'Papírové žádosti o pojistné nároky nahradilo okamžité bezkontaktní ověření čipovou kartou.';

  @override
  String get projectOutcomeEskadenia =>
      'Udržení 60 snímků za sekundu ve složitých datově náročných nemocničních a univerzitních procesech.';

  @override
  String get projectOutcomeFais =>
      'Vyšší dokončenost nákupů a méně nedokončených transakcí.';

  @override
  String get contactHeaderTitle => 'Máte těžký mobilní problém?';

  @override
  String get contactHeaderSubtitle =>
      'Pošlete mi ho. Přijímám revize mobilní architektury a zakázky a od února 2027 hledám seniorní mobilní roli v Brně. Nejrychleji odpovídám na e-mail.';

  @override
  String get skillsHeaderTitle => 'Dovednosti';

  @override
  String get skillsHeaderSubtitle =>
      'S čím pracuji a kde jsem to použil. Vyhledejte nástroj nebo filtrujte podle oblasti.';

  @override
  String get sectionSubtitleEngineering =>
      'Architektury za mými mobilními sadami: vrstvy, offline synchronizace, NFC a zabezpečení tokenů.';

  @override
  String get folioNext => 'Dále';

  @override
  String get folioBackToStart => 'Zpět na začátek';

  @override
  String welcomeBack(String section) {
    return 'Vítejte zpět — pokračovat v sekci $section?';
  }

  @override
  String get continueAction => 'Pokračovat';

  @override
  String get quickProfileTitle => 'Shrnutí pro nábor';

  @override
  String get quickProfileRole => 'Pozice';

  @override
  String get quickProfileExperience => 'Praxe';

  @override
  String quickProfileYears(int years) {
    return '$years+ let v mobilním vývoji';
  }

  @override
  String get quickProfileStack => 'Hlavní technologie';

  @override
  String get quickProfileRecent => 'Poslední pozice';

  @override
  String get quickProfileEmail => 'E-mail';

  @override
  String get quickProfileCopy => 'Kopírovat shrnutí';

  @override
  String get quickProfileCopied => 'Shrnutí profilu zkopírováno';

  @override
  String get quickProfileVcard => 'QR vizitka';

  @override
  String get vcardDialogTitle => 'Kontaktní karta pro náboráře';

  @override
  String get vcardScanHint => 'Naskenujte fotoaparátem telefonu';

  @override
  String get vcardCopyText => 'Kopírovat kontaktní kartu';

  @override
  String get vcardCopied => 'Kontaktní karta zkopírována do schránky';

  @override
  String get done => 'Hotovo';

  @override
  String studyCaseStudy(String company) {
    return 'Případová studie $company';
  }

  @override
  String get studyProblem => 'Problém';

  @override
  String get studyRole => 'Moje role';

  @override
  String get studyArchitecture => 'Architektura systému';

  @override
  String get studyOutcomes => 'Výsledky';

  @override
  String get studyLessons => 'Ponaučení';

  @override
  String get studyMore => 'Další případové studie';

  @override
  String get studyDockProblem => 'Problém';

  @override
  String get studyDockProblemShort => 'Probl.';

  @override
  String get studyDockRole => 'Role';

  @override
  String get studyDockArch => 'Návrh';

  @override
  String get studyDockOutcomes => 'Výsledky';

  @override
  String get studyDockOutcomesShort => 'Výsl.';

  @override
  String get studyDockLessons => 'Ponaučení';

  @override
  String get studyBackToPortfolio => 'Zpět na portfolio';

  @override
  String get studyTop => 'Nahoru';

  @override
  String get studyBackToTop => 'Zpět nahoru';

  @override
  String studyJumpTo(String chapter) {
    return 'Přejít na $chapter';
  }

  @override
  String studyChapter(String chapter) {
    return 'Kapitola $chapter';
  }

  @override
  String get studyOfficialWebsite => 'Oficiální web';

  @override
  String studyVisitWebsite(String company) {
    return 'Navštívit oficiální web $company';
  }

  @override
  String get studyCompanyLinkedIn => 'LinkedIn firmy';

  @override
  String studyViewOnLinkedIn(String company) {
    return 'Zobrazit $company na LinkedIn';
  }

  @override
  String get studyShareButton => 'Sdílet odkaz na studii';

  @override
  String studyLinkCopied(String url) {
    return 'Odkaz na studii zkopírován: $url';
  }

  @override
  String get studyGlance => 'V kostce';

  @override
  String get studyChallenge => 'Výzva';

  @override
  String get studyBuilt => 'Co jsem vytvořil';

  @override
  String get studyResult => 'Výsledek';

  @override
  String get studySeeOutcomes => 'Zobrazit všechny výsledky';

  @override
  String get studyEnglishNote =>
      'Podrobný technický rozbor níže je v angličtině.';

  @override
  String studyOutcomeSemantics(String headline, String body) {
    return 'Klíčový výsledek: $headline. $body';
  }

  @override
  String get studyPresent => 'Současnost';

  @override
  String get studyRoleMobileDev => 'Mobilní vývojář';

  @override
  String get studyRoleFlutterDev => 'Flutter vývojář';

  @override
  String get studyNatIntro =>
      'Kritická zdravotnická platforma s NFC čipovými kartami pro největšího správce zdravotního pojištění (TPA) v Jordánsku. Ring App, E-Health Gate a Compliance System — tři koordinovaní klienti na společné architektuře.';

  @override
  String get studyNatChallenge =>
      'Papírové nároky zpomalovaly proplácení a vystavovaly největšího jordánského správce zdravotního pojištění podvodům; mnoho klinik navíc mělo nespolehlivé připojení.';

  @override
  String get studyNatBuilt =>
      'Sadu tří aplikací s NFC čipovými kartami: nativní most APDU v Kotlinu, offline-first synchronizaci přes WorkManager a JWT tokeny vázané na hardware.';

  @override
  String get studyNatResult =>
      'Ověření karty za méně než sekundu, nároky, které přežijí výpadky připojení, nula bezpečnostních incidentů a tři klienti na jedné architektuře.';

  @override
  String get studyNatOutcome1 =>
      'bezkontaktní ověření karty, od vlajkových po levné telefony';

  @override
  String get studyNatOutcome2 =>
      'spolehlivá offline dávková synchronizace při výpadcích připojení';

  @override
  String get studyNatOutcome3 =>
      'bezpečnostních incidentů díky tokenům vázaným na hardware';

  @override
  String get studyNatOutcome4 =>
      'koordinovaní klienti na společné architektuře';

  @override
  String get studyEskIntro =>
      'Výkonná podniková mobilní architektura pro nemocniční informační systémy (HIS) a vzdělávací platformy v regionu MENA. Přestavba monolitického kódu na oddělené, testovatelné balíčky funkcí bez jakéhokoli výpadku provozu.';

  @override
  String get studyEskChallenge =>
      'Starší monolitické nemocniční a univerzitní aplikace se na rozsáhlých záznamech zadrhávaly a na slabých tabletech na odděleních během dlouhých směn padaly.';

  @override
  String get studyEskBuilt =>
      'Postupný refaktoring na MVVM s oddělenými balíčky funkcí, cachovanými repozitáři a typovými kontrakty, profilovaný v DevTools, bez výpadku.';

  @override
  String get studyEskResult =>
      '60 FPS na rozsáhlých tabulkách, o 35 % méně pádů a čtyři nasazené podnikové platformy.';

  @override
  String get studyEskOutcome1 =>
      'stabilní snímková frekvence na rozsáhlých nemocničních tabulkách a grafech';

  @override
  String get studyEskOutcome2 =>
      'snížení míry pádů aplikace během mnohahodinových klinických směn';

  @override
  String get studyEskOutcome4 =>
      'nasazené podnikové platformy (HIS, klinika, univerzita, škola)';

  @override
  String get studySolIntro =>
      'Výkonné spotřebitelské aplikace pro iOS a Android: věrnostní systém s uplatňováním odměn v reálném čase a platforma pro pomíjivá videa a příběhy ve stylu Snapchatu. Postavené na hardwarově akcelerovaném zpracování videa a interním znovupoužitelném design systému.';

  @override
  String get studySolChallenge =>
      'Dvě spotřebitelské aplikace (věrnostní odměny a pomíjivé video příběhy) v napjatých termínech, s kamerovým zpracováním, které na různých zařízeních Android unikalo paměť a deformovalo obraz.';

  @override
  String get studySolBuilt =>
      'Hardwarově akcelerovaný kamerový a video engine, izoláty na pozadí komprimující média před nahráním do S3 a sdílenou knihovnu design tokenů pro obě aplikace.';

  @override
  String get studySolResult =>
      'Obě aplikace vyšly včas s hodnocením 4,7+ v obchodech, o 40 % rychlejším dodáváním funkcí a bez ztracených snímků v karuselu příběhů.';

  @override
  String get studySolOutcome1 => 'průměrné hodnocení v App Store a Google Play';

  @override
  String get studySolOutcome2 =>
      'rychlejší dodávání dalších funkcí díky sdílené knihovně komponent';

  @override
  String get studySolOutcome3 =>
      'ztracených snímků při posouvání karuselu příběhů';

  @override
  String get studySolOutcome4 =>
      'produkční spotřebitelské aplikace spuštěné současně a včas';

  @override
  String get studyFaisIntro =>
      'Nákupní proces pro m-commerce a fitness aplikace se streamováním médií, postavené na platebních požadavcích bezpečných pro opakování, obranném zpracování sítě a přehrávání, které přežije přerušení.';

  @override
  String get studyFaisChallenge =>
      'Výpadky při placení na nestabilních sítích způsobovaly dvojí platby a opuštěné košíky a úsporné režimy výrobců telefonů ukončovaly přehrávání streamů.';

  @override
  String get studyFaisBuilt =>
      'Idempotentní placení se sladěním stavu na klientu, defenzivní síťové interceptory a správce vyrovnávací paměti streamu běžící jako služba na popředí.';

  @override
  String get studyFaisResult =>
      'Vyšší míra dokončených objednávek, méně požadavků na podporu kvůli neúspěšným objednávkám a problémy v provozu opravené podle produkčních dat.';

  @override
  String get studyFaisOutcome1 =>
      'Vyšší míra dokončených objednávek a méně opuštěných košíků.';

  @override
  String get studyFaisOutcome2 =>
      'Méně požadavků na podporu kvůli neúspěšným objednávkám.';

  @override
  String get studyFaisOutcome3 =>
      'Problémy v provozu dohledané a opravené podle produkčních dat.';

  @override
  String get skillCatAll => 'Vše';

  @override
  String get skillCatDomain => 'Oborová expertíza';

  @override
  String get skillCatMobile => 'Mobilní systémy';

  @override
  String get skillCatSecurity => 'Bezpečnost a protokoly';

  @override
  String get skillCatArchitecture => 'Architektura a stav';

  @override
  String get skillCatCloud => 'Cloud a infrastruktura';

  @override
  String get skillCatLanguages => 'Jazyky a komunikace';

  @override
  String get archTopicClean => 'Čistá mobilní architektura';

  @override
  String get archTopicOffline => 'Synchronizace offline-first';

  @override
  String get archTopicNfc => 'Zpracování čipových karet ISO-7816 a NFC';

  @override
  String get archTopicKeystore =>
      'Hardwarové úložiště klíčů a životní cyklus JWT';

  @override
  String get archTopicState => 'Reaktivní správa stavu (BLoC)';

  @override
  String get uiReadCaseStudy => 'Číst případovou studii';

  @override
  String get projectNameNatHealth => 'Mobilní sada NatHealth';

  @override
  String get projectNameEskadenia =>
      'Podnikové systémy pro e-learning a zdravotnictví';

  @override
  String get projectNameSolutions =>
      'Věrnostní program a aplikace s dočasnými příběhy';

  @override
  String get projectNameFais => 'Klienti pro m-commerce a streamování médií';

  @override
  String get uiPortfolioSections => 'Sekce portfolia';

  @override
  String get uiDownloadResumePdf => 'Stáhnout životopis (PDF)';

  @override
  String get uiRetry => 'Zkusit znovu';

  @override
  String get uiWebsite => 'Web';

  @override
  String expRoleAtCompany(String role, String company, String period) {
    return '$role ve firmě $company, $period';
  }

  @override
  String get uiArchRationale => 'Proč tato volba';

  @override
  String get uiKeySafeguards => 'Pojistky';

  @override
  String get cardSurname => 'Alhyari';

  @override
  String get cardGivenName => 'Abdallah';

  @override
  String get cardFieldSurname => 'Příjmení';

  @override
  String get cardFieldGiven => 'Jméno';

  @override
  String get cardFieldRole => 'Role';

  @override
  String get cardRole => 'Senior mobilní vývojář';

  @override
  String get cardBase => 'Ammán; Brno od února 2027';

  @override
  String get coverWorkedAtLabel => 'Pracoval v';

  @override
  String get coverWorkedAtValue => 'NatHealth, ESKADENIA, Solutions Now, FAIS';

  @override
  String get projectFigureValueNatHealth => '400 000+';

  @override
  String get projectFigureLabelNatHealth =>
      'pojištěnců v Jordánsku, Palestině a Iráku. Papírové nároky nahradily NFC karty.';

  @override
  String get projectFigureValueEskadenia => '35 %';

  @override
  String get projectFigureLabelEskadenia =>
      'méně pádů a stabilních 60 FPS v hustých nemocničních tabulkách.';

  @override
  String get projectFigureValueSolutions => '4,7+';

  @override
  String get projectFigureLabelSolutions =>
      'hvězdičky v obchodě. Obě aplikace vydány včas.';

  @override
  String get heroFactAvailableLabel => 'Dostupnost';

  @override
  String get heroFactPermitLabel => 'Pracovní povolení';

  @override
  String get heroFactBasedLabel => 'Působiště';

  @override
  String get heroFactLanguagesLabel => 'Jazyky';

  @override
  String get heroFactLanguagesValue =>
      'angličtina (profesionální), arabština (rodilý mluvčí)';

  @override
  String get heroFactStudyLabel => 'Studium';

  @override
  String get aboutTitle => 'O mně';

  @override
  String get aboutHeaderSubtitle =>
      'Kdo jsem, kam směřuji a jak mě zastihnout.';

  @override
  String get aboutExperienceLabel => 'Praxe';

  @override
  String aboutExperienceValue(int years) {
    return '$years+ let v mobilním vývoji';
  }

  @override
  String get projectLblProblem => 'Problém';

  @override
  String get projectLblSystem => 'Systém';

  @override
  String get projectLblRole => 'Moje role';

  @override
  String get projectProblemNatHealth =>
      'Papírové nároky, riziko podvodů a nespolehlivé připojení klinik zpomalovaly zpracování pojistných nároků.';

  @override
  String get projectSystemNatHealth =>
      'Kotlin NFC most ke čipovým kartám, JWT s vazbou na zařízení a offline-first fronta WorkManager.';

  @override
  String get projectRoleNatHealth =>
      'Vedl jsem architekturu aplikace, nativní NFC integraci a zabezpečení.';

  @override
  String get projectProblemEskadenia =>
      'Starší nemocniční a univerzitní aplikace zahazovaly snímky, měly propletený stav a zabíraly příliš paměti.';

  @override
  String get projectSystemEskadenia =>
      'Oddělené funkční balíčky MVVM, typované vrstvy REST a cachované repozitáře.';

  @override
  String get projectRoleEskadenia =>
      'Vedl jsem architektonický refaktoring, profilování a vyčleňování balíčků.';

  @override
  String get projectProblemSolutions =>
      'Dvě spotřebitelské aplikace s vysokým provozem, věrnostní systém a živé příběhy, bylo třeba dodat v těsných termínech.';

  @override
  String get projectSystemSolutions =>
      'Sdílená knihovna komponent ve Flutteru, hardwarově urychlené pipeline kamery a videa, dynamické modely REST.';

  @override
  String get projectRoleSolutions =>
      'Stanovil jsem standardy mobilního designu a vytvořil pipeline kamery a integraci backendu.';

  @override
  String get projectProblemFais =>
      'Vícekrokový nákup a nepřetržité streamování médií musely běžet bez úniků paměti a souběhů stavů.';

  @override
  String get projectSystemFais =>
      'Integrace nákupních API od začátku do konce s klíči idempotence a diagnostika živých problémů z telemetrie.';

  @override
  String get projectRoleFais =>
      'Koordinoval jsem integraci backendu a frontendu a řešil produkční problémy.';

  @override
  String engTiers(int count) {
    return 'Vrstev: $count';
  }

  @override
  String get aboutStoryShort =>
      'V mobilním vývoji jsem začal v roce 2021. Od té doby se moje práce stále posouvá níž v zásobníku, od obrazovek k nativní, bezpečnostní a synchronizační vrstvě pod nimi. Nevadí mi převzít složitý starší systém a nechat ho modulární a testovatelný.';

  @override
  String projectCopyCaseStudyLink(String project) {
    return 'Zkopírovat odkaz na případovou studii $project';
  }

  @override
  String get brandBackToTop => 'Abdallah Alhyari, zpět nahoru';

  @override
  String get archCostLabel => 'Co to stojí';

  @override
  String get archUsedAtLabel => 'Použito v';
}
