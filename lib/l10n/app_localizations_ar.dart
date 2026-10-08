// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navWork => 'الأعمال';

  @override
  String get navEngineering => 'الهندسة';

  @override
  String get navExperience => 'الخبرات';

  @override
  String get navStack => 'المهارات';

  @override
  String get navAbout => 'نبذة';

  @override
  String get navContact => 'تواصل';

  @override
  String get navResume => 'السيرة الذاتية';

  @override
  String get introLocation => 'عمان → برنو · 2027';

  @override
  String get sectionEducation => 'التعليم';

  @override
  String get sectionCertifications => 'الشهادات';

  @override
  String get contactHeroEyebrow => 'البريد الإلكتروني';

  @override
  String get contactReplyWindow => 'الرد خلال 24 ساعة · إنجليزي / عربي';

  @override
  String get contactSendEmailBtn => 'أرسل بريدًا';

  @override
  String get contactCopyAddressBtn => 'نسخ العنوان';

  @override
  String get skillsEmptyTitle => 'لا توجد مهارات في هذه الفئة بعد';

  @override
  String skillsNoMatch(String query) {
    return 'لا توجد مهارات تطابق «$query»';
  }

  @override
  String get skillsEmptyShowAll => 'عرض الكل';

  @override
  String get keyboardHintTitle => 'اختصارات لوحة المفاتيح';

  @override
  String get keyboardHintDigits => '1–7   الانتقال إلى قسم';

  @override
  String get keyboardHintArrows => 'سهما الأعلى / الأسفل · السابق / التالي';

  @override
  String get keyboardHintHome => 'الصفحة الأولى';

  @override
  String get keyboardHintEnd => 'الصفحة الأخيرة';

  @override
  String get closeTooltip => 'إغلاق';

  @override
  String get showHelpShortcut => 'عرض هذه المساعدة';

  @override
  String resumeOpenError(Object publicUrl) {
    return 'تعذر فتح السيرة الذاتية — قم بزيارة $publicUrl';
  }

  @override
  String projectOpenError(Object url) {
    return 'تعذر فتح $url';
  }

  @override
  String get spreadAction => 'توزيع';

  @override
  String get alignAction => 'محاذاة';

  @override
  String get previousAction => 'السابق';

  @override
  String get nextAction => 'التالي';

  @override
  String emailCopied(Object email) {
    return 'تم نسخ البريد الإلكتروني · $email';
  }

  @override
  String get viewMyWork => 'عرض أعمالي';

  @override
  String get downloadResume => 'تحميل السيرة الذاتية';

  @override
  String get introDownloadResume => 'تحميل السيرة الذاتية';

  @override
  String get contactMe => 'لنتحدث';

  @override
  String get copyEmail => 'نسخ البريد';

  @override
  String get introSeniorEngineer => 'مهندس تطبيقات هواتف أول';

  @override
  String get introRoleLine => 'مهندس تطبيقات هواتف أول';

  @override
  String get introValueProposition =>
      'أصمم وأطلق منتجات جوال مرنة تحوّل الأنظمة المعقدة إلى تجارب استخدام واضحة وجديرة بالثقة.';

  @override
  String get introSkillArchitecture => 'هندسة الأنظمة';

  @override
  String get introSkillProductDelivery => 'تسليم المنتجات';

  @override
  String get introWorkEligibility => 'الانتقال إلى برنو في 2027';

  @override
  String get introAvailableContracts => 'متاح للعقود';

  @override
  String get contactEngagementScopes => '// مجالات المشاركة وأساليب التعاون';

  @override
  String get contactAtsVerified => 'معتمد لنظام ATS · إصدار 2026';

  @override
  String get contactPdfSize => 'بي دي إف · 22 ك.ب';

  @override
  String get contactCvDossierTitle => 'السيرة الذاتية التنفيذية وملف الأعمال';

  @override
  String get contactCvDossierDesc =>
      'سجل زمني متكامل، دراسات حالة لبنية المؤسسات، وكفاءات هندسية.';

  @override
  String get contactDownloadCvPdf => 'تحميل السيرة · PDF';

  @override
  String get contactPreview => 'معاينة';

  @override
  String get footerRightsReserved => '© 2026 عبدالله الحياري';

  @override
  String get contactPhone => 'هاتف';

  @override
  String get contactCall => 'اتصال';

  @override
  String get contactWhatsapp => 'واتساب';

  @override
  String get contactOpen => 'فتح';

  @override
  String get contactCopy => 'نسخ';

  @override
  String get contactLinkedin => 'لينكد إن';

  @override
  String get contactProfile => 'حساب شخصي';

  @override
  String get contactGithub => 'جيت هاب';

  @override
  String get contactVisit => 'زيارة';

  @override
  String get semanticPortrait => 'صورة شخصية لعبدالله الحياري';

  @override
  String get semanticTitle => 'عبدالله الحياري، مهندس تطبيقات هواتف أول';

  @override
  String folioIndicator(Object current, Object total) {
    return 'الصحيفة $current / $total';
  }

  @override
  String get introTechStack =>
      'فلاتر · أندرويد · آي أو إس · معمارية برمجيات · أنظمة دون اتصال · NFC · أمان · أنظمة الوقت الفعلي';

  @override
  String get introBasedIn => 'الموقع';

  @override
  String get introStatus => 'الحالة';

  @override
  String get introOpenForRoles => 'متاح لأدوار هندسية قيادية';

  @override
  String get introMasthead => '// الترويسة';

  @override
  String get navSectionCover => 'الغلاف';

  @override
  String get navSubCover => 'مهندس تطبيقات فلاتر وأندرويد أول';

  @override
  String get navSectionExperience => 'الخبرات';

  @override
  String get navSubExperience => 'خمس سنوات من تطوير تطبيقات المؤسسات';

  @override
  String get navSectionWork => 'الأعمال';

  @override
  String get navSubWork => 'دراسات حالة من تطبيقات في بيئة الإنتاج';

  @override
  String get navSectionStack => 'المهارات';

  @override
  String get navSubStack => 'الأدوات والتخصصات';

  @override
  String get navSectionEngineering => 'الهندسة';

  @override
  String get navSubEngineering => 'كيف بُنيت التطبيقات';

  @override
  String get navSectionAbout => 'رؤى';

  @override
  String get navSubAbout => 'كيف أعمل مع الفرق';

  @override
  String get navSectionContact => 'تواصل';

  @override
  String get navSubContact => 'البريد والهاتف والحسابات';

  @override
  String selectedRoleAnnouncement(String role) {
    return 'تم تحديد الدور: $role';
  }

  @override
  String copiedToClipboard(String value) {
    return 'تم نسخ $value إلى الحافظة';
  }

  @override
  String get skillsSearchHint => 'ابحث في المهارات والتقنيات وهندسة الأنظمة...';

  @override
  String skillsCountAll(int count) {
    return '$count مهارة';
  }

  @override
  String skillsCountFiltered(int filtered, int total) {
    return '$filtered من أصل $total مهارة';
  }

  @override
  String get skillsClearSearch => 'مسح البحث';

  @override
  String get perspectivePrev => 'الدور السابق';

  @override
  String get perspectiveNext => 'الدور التالي';

  @override
  String get perspectiveShortcutsHint =>
      'الأسهم أو A / D للتنقل · S خلط · R محاذاة';

  @override
  String get sectionSubtitleWork =>
      'أربع جهات عمل وأربعة أنظمة. تعرض كل حالة المشكلة وكيف بُني الحل وما الذي تغيّر.';

  @override
  String get sectionSubtitleExperience =>
      'أربعة أدوار منذ 2021، من إنجاز الميزات إلى تولّي الطبقة الأصلية وطبقة الأمان.';

  @override
  String get projectsHeaderKicker => 'القسم 03 · أعمال مختارة';

  @override
  String get projectDomainAll => 'الكل';

  @override
  String get projectDomainHealthcare => 'الرعاية الصحية والبطاقات الذكية';

  @override
  String get projectDomainEnterprise => 'أنظمة المستشفيات والتعليم';

  @override
  String get projectDomainFleet => 'الأساطيل والاتصالات عن بُعد';

  @override
  String get projectDomainCommerce => 'التجارة الإلكترونية والبث';

  @override
  String projectTechFilter(String technology) {
    return 'تصفية بالتقنية: $technology';
  }

  @override
  String readCaseStudyFor(String project) {
    return 'اقرأ دراسة حالة: $project';
  }

  @override
  String get projectTaglineNatHealth =>
      'منصة صحية حيوية تستخدم بطاقات NFC الذكية للرعاية الرقمية والمطالبات والامتثال التنظيمي.';

  @override
  String get projectTaglineEskadenia =>
      'تطبيقات مؤسسية عالية الأداء لأنظمة معلومات المستشفيات ومنصات التعليم.';

  @override
  String get projectTaglineSolutions =>
      'منصة لمكافآت الولاء وتجربة لمقاطع الفيديو والقصص المؤقتة، مصممتان للتوسع.';

  @override
  String get projectTaglineFais =>
      'تجارب دفع تجارية عالية السعة وتطبيقات بث وسائط متواصل.';

  @override
  String get projectOutcomeNatHealth =>
      'استبدال المطالبات الورقية بالتحقق الفوري واللاتلامسي عبر البطاقات الذكية.';

  @override
  String get projectOutcomeEskadenia =>
      'الحفاظ على 60 إطارًا في الثانية ضمن سير عمل المستشفيات والجامعات كثيف البيانات.';

  @override
  String get projectOutcomeSolutions =>
      'إطلاق التطبيقين في الموعد مع تقييمات تجاوزت 4.7 نجوم في المتاجر.';

  @override
  String get projectOutcomeFais =>
      'رفع إتمام عمليات الشراء وتقليل المعاملات المتروكة.';

  @override
  String get skillMasteryLead => 'قيادة';

  @override
  String get skillMasteryCore => 'أساسي';

  @override
  String get skillMasterySolid => 'متقدم';

  @override
  String get skillMasteryGrowing => 'قيد التطوير';

  @override
  String skillCardSemantics(String skill, String level) {
    return '$skill، مستوى $level. فعّل لقلب البطاقة وعرض التفاصيل.';
  }

  @override
  String get experienceHeaderKicker => 'القسم 02 · المسيرة المهنية';

  @override
  String get engineeringHeaderKicker => 'القسم 05 · هندسة الأنظمة';

  @override
  String get hatsHeaderKickerMobile => 'القسم 06 · 6 أدوار';

  @override
  String get hatsHeaderKickerDesktop => 'القسم 06 · قيادة متعددة التخصصات';

  @override
  String get hatsHeaderSubtitle =>
      'هندسة تضع المنتج في المقدمة، وتواصل واضح، وقيادة عملية عبر الفرق والقيود ومراحل التسليم الحساسة.';

  @override
  String get contactHeaderKicker => 'القسم 07 · تواصل مباشر';

  @override
  String get contactHeaderTitle => 'هل لديك مشكلة صعبة في تطبيقات الهاتف؟';

  @override
  String get contactHeaderSubtitle =>
      'أرسلها لي. أقبل مراجعات معمارية الهواتف والعمل التعاقدي الآن، وأبحث عن دور أول في تطبيقات الهاتف في برنو من فبراير 2027. البريد الإلكتروني أسرع طريقة للرد.';

  @override
  String get skillsHeaderKicker => 'القسم 04 · الأنظمة والتسليم';

  @override
  String get skillsHeaderTitle => 'المهارات';

  @override
  String get skillsHeaderSubtitle =>
      'ما أعمل به وأين استخدمته. ابحث عن أداة أو صفِّ حسب المجال.';

  @override
  String get sectionSubtitleEngineering =>
      'البُنى المعمارية خلف تطبيقاتي: الطبقات، والمزامنة دون اتصال، وNFC، وأمان الرموز.';

  @override
  String get flipHintTap => 'اضغط للقلب';

  @override
  String get flipHintClick => 'انقر للقلب';

  @override
  String get folioNext => 'التالي';

  @override
  String get folioBackToStart => 'العودة إلى البداية';

  @override
  String welcomeBack(String section) {
    return 'مرحبًا بعودتك — هل تريد المتابعة من $section؟';
  }

  @override
  String get continueAction => 'متابعة';

  @override
  String get quickProfile => 'ملف في 30 ثانية';

  @override
  String get quickProfileTitle => 'ملخص للتوظيف';

  @override
  String get quickProfileRole => 'الدور';

  @override
  String get quickProfileExperience => 'الخبرة';

  @override
  String quickProfileYears(int years) {
    return 'أكثر من $years سنوات في هندسة تطبيقات الجوال';
  }

  @override
  String get quickProfileStack => 'التقنيات الأساسية';

  @override
  String get quickProfileRecent => 'أحدث المناصب';

  @override
  String get quickProfileEmail => 'البريد الإلكتروني';

  @override
  String get quickProfileCopy => 'نسخ الملخص';

  @override
  String get quickProfileCopied => 'تم نسخ ملخص الملف';

  @override
  String get studyCaseStudy => 'دراسة حالة';

  @override
  String get studyProblem => 'المشكلة';

  @override
  String get studyRole => 'دوري';

  @override
  String get studyArchitecture => 'بنية النظام';

  @override
  String get studyOutcomes => 'النتائج';

  @override
  String get studyLessons => 'الدروس';

  @override
  String get studyMore => 'دراسات حالة أخرى';

  @override
  String get studyDockProblem => 'المشكلة';

  @override
  String get studyDockProblemShort => 'المشكلة';

  @override
  String get studyDockRole => 'الدور';

  @override
  String get studyDockArch => 'البنية';

  @override
  String get studyDockOutcomes => 'النتائج';

  @override
  String get studyDockOutcomesShort => 'النتائج';

  @override
  String get studyDockLessons => 'الدروس';

  @override
  String get studyBackToPortfolio => 'العودة إلى الملف';

  @override
  String studyReadPercent(int pct) {
    return 'قُرئ $pct٪';
  }

  @override
  String get studyTop => 'للأعلى';

  @override
  String get studyBackToTop => 'العودة إلى الأعلى';

  @override
  String studyJumpTo(String chapter) {
    return 'الانتقال إلى $chapter';
  }

  @override
  String studyChapter(String chapter) {
    return 'الفصل $chapter';
  }

  @override
  String get studyOfficialWebsite => 'الموقع الرسمي';

  @override
  String studyVisitWebsite(String company) {
    return 'زيارة الموقع الرسمي لـ $company';
  }

  @override
  String get studyCompanyLinkedIn => 'LinkedIn الشركة';

  @override
  String studyViewOnLinkedIn(String company) {
    return 'عرض $company على LinkedIn';
  }

  @override
  String get studyShare => 'مشاركة الدراسة';

  @override
  String get studyShareTooltip => 'نسخ رابط مباشر لهذه الدراسة';

  @override
  String studyShareSemantics(String title) {
    return 'مشاركة رابط مباشر لدراسة $title';
  }

  @override
  String get studyShareButton => 'مشاركة رابط الدراسة';

  @override
  String studyLinkCopied(String url) {
    return 'تم نسخ رابط الدراسة: $url';
  }

  @override
  String get studyGlanceKicker => 'لمحة سريعة · قراءة في 30 ثانية';

  @override
  String get studyGlance => 'لمحة سريعة';

  @override
  String get studyChallenge => 'التحدي';

  @override
  String get studyBuilt => 'ما بنيته';

  @override
  String get studyResult => 'النتيجة';

  @override
  String get studySeeOutcomes => 'عرض كل النتائج';

  @override
  String get studyEnglishNote => 'التفاصيل التقنية أدناه باللغة الإنجليزية.';

  @override
  String studyOutcomeSemantics(String headline, String body) {
    return 'مقياس نتيجة رئيسي: $headline. $body';
  }

  @override
  String get studyPresent => 'حتى الآن';

  @override
  String get studyRoleMobileDev => 'مطوّر تطبيقات الجوال';

  @override
  String get studyRoleFlutterDev => 'مطوّر Flutter';

  @override
  String get studyNatIntro =>
      'منصة رعاية صحية حرجة تعتمد بطاقات NFC الذكية لأكبر جهة إدارة تأمين صحي (TPA) في الأردن. ‏Ring App وE-Health Gate وCompliance System — ثلاثة تطبيقات منسّقة على بنية مشتركة.';

  @override
  String get studyNatChallenge =>
      'كانت المطالبات الورقية تُبطئ التعويضات وتعرّض أكبر جهة لإدارة التأمين الصحي في الأردن للاحتيال، وكان اتصال كثير من العيادات غير مستقر.';

  @override
  String get studyNatBuilt =>
      'مجموعة من ثلاثة تطبيقات لبطاقات NFC الذكية: جسر APDU أصلي بلغة Kotlin، ومزامنة offline-first عبر WorkManager، ورموز JWT مرتبطة بالعتاد.';

  @override
  String get studyNatResult =>
      'تحقّق من البطاقة في أقل من ثانية، ومطالبات لا تضيع عند انقطاع الاتصال، وصفر اختراقات أمنية، وثلاثة تطبيقات على بنية واحدة.';

  @override
  String get studyNatOutcome1 =>
      'تحقّق لاتلامسي من البطاقة، من الهواتف الرائدة إلى الاقتصادية';

  @override
  String get studyNatOutcome2 =>
      'مزامنة دفعية موثوقة دون اتصال أثناء انقطاع الشبكة';

  @override
  String get studyNatOutcome3 =>
      'اختراقات أمنية مع دورة حياة رموز مرتبطة بالعتاد';

  @override
  String get studyNatOutcome4 => 'تطبيقات منسّقة أُطلقت على البنية المشتركة';

  @override
  String get studyEskIntro =>
      'بنية جوال مؤسسية عالية الأداء تشغّل أنظمة معلومات المستشفيات (HIS) ومنصات التعليم في منطقة الشرق الأوسط وشمال أفريقيا. أُعيد بناء قواعد الكود القديمة الأحادية إلى حزم ميزات منفصلة قابلة للاختبار دون أي توقف تشغيلي.';

  @override
  String get studyEskChallenge =>
      'كانت تطبيقات المستشفيات والجامعات القديمة الأحادية تتلعثم مع السجلات الكثيفة وتنهار على الأجهزة اللوحية الضعيفة في الأجنحة خلال المناوبات الطويلة.';

  @override
  String get studyEskBuilt =>
      'إعادة هيكلة تدريجية إلى MVVM بحزم ميزات منفصلة ومستودعات مخزّنة مؤقتًا وعقود بيانات محددة الأنواع، مع قياس الأداء عبر DevTools ودون أي توقف.';

  @override
  String get studyEskResult =>
      '‏60 FPS على جداول البيانات الكثيفة، وأعطال أقل بنسبة 35%، وعرض أكثر من 1,000 سجل بسلاسة، ونشر أربع منصات مؤسسية.';

  @override
  String get studyEskOutcome1 =>
      'معدل إطارات ثابت على جداول بيانات المستشفى والمخططات الطبية الكثيفة';

  @override
  String get studyEskOutcome2 =>
      'انخفاض في معدل الأعطال لدى المستخدم خلال المناوبات السريرية الطويلة';

  @override
  String get studyEskOutcome3 => 'سجل للمرضى والطلاب يُعرض دون أي تأخير';

  @override
  String get studyEskOutcome4 =>
      'منصات مؤسسية منشورة (HIS، العيادة، الجامعة، المدرسة)';

  @override
  String get studySolIntro =>
      'تطبيقات استهلاكية عالية الأداء لنظامي iOS وAndroid: محرّك استبدال مكافآت ولاء في الوقت الفعلي ومنصة كاميرا لقصص فيديو مؤقتة على غرار Snapchat. مبنية على معالجة فيديو مسرّعة بالعتاد ونظام تصميم داخلي قابل لإعادة الاستخدام.';

  @override
  String get studySolChallenge =>
      'تطبيقان استهلاكيان (مكافآت الولاء وقصص الفيديو المؤقتة) بمواعيد نهائية ضيقة، مع معالجة كاميرا تسرّب الذاكرة وتشوّه الصورة عبر أجهزة Android المختلفة.';

  @override
  String get studySolBuilt =>
      'محرّك كاميرا وفيديو مسرّع بالعتاد، وعمليات isolate في الخلفية تضغط الوسائط قبل رفعها إلى S3، ومكتبة design tokens مشتركة للتطبيقين.';

  @override
  String get studySolResult =>
      'أُطلق التطبيقان في الموعد بتقييم 4.7+ في المتاجر، وتسليم أسرع للميزات بنسبة 40%، ودون أي إطار مفقود في شريط القصص.';

  @override
  String get studySolOutcome1 => 'متوسط التقييم في App Store وGoogle Play';

  @override
  String get studySolOutcome2 =>
      'تقليص وقت تسليم الميزات اللاحقة بفضل مكتبة مكوّنات مشتركة';

  @override
  String get studySolOutcome3 =>
      'إطارات مفقودة أثناء التنقل بالإيماءات في شريط القصص';

  @override
  String get studySolOutcome4 => 'تطبيقان استهلاكيان أُطلقا معًا في الموعد';

  @override
  String get studyFaisIntro =>
      'مسارات دفع تجارية عالية الأداء للتجارة عبر الجوال وتطبيقات لياقة ببث وسائط متواصل. مبنية على معاملات دفع ذرّية، ومعترضات شبكة دفاعية، وبث صوت وفيديو مرن.';

  @override
  String get studyFaisChallenge =>
      'كان انقطاع الدفع على الشبكات غير المستقرة يسبب خصومات مكررة وسلال تسوق متروكة، وكانت أنظمة توفير البطارية لدى الشركات المصنّعة توقف تشغيل البث.';

  @override
  String get studyFaisBuilt =>
      'دفع idempotent مع مواءمة الحالة لدى العميل، ومعترضات شبكة دفاعية، ومدير ذاكرة تخزين مؤقت للبث يعمل كخدمة في المقدّمة.';

  @override
  String get studyFaisResult =>
      'إتمام 99.8% من عمليات الدفع دون أي خصم مكرر، وتصعيدات أقل للدعم بنسبة 45%، ومواءمة السلة في أقل من 200 ms.';

  @override
  String get studyFaisOutcome1 =>
      'نسبة إتمام ناجح لمعاملات الدفع دون أي خصم مكرر';

  @override
  String get studyFaisOutcome2 =>
      'انخفاض في تذاكر تصعيد الدعم لطلبات الدفع الفاشلة';

  @override
  String get studyFaisOutcome3 => 'زمن فوري لحساب السلة ومواءمة الحالة';

  @override
  String get studyFaisOutcome4 => 'جلسة نشطة يوميًا عبر مسارات التجارة';

  @override
  String get skillCatAll => 'الكل';

  @override
  String get skillCatDomain => 'الخبرة المتخصصة';

  @override
  String get skillCatMobile => 'أنظمة الهاتف المحمول';

  @override
  String get skillCatSecurity => 'الأمان والبروتوكولات';

  @override
  String get skillCatArchitecture => 'البنية وإدارة الحالة';

  @override
  String get skillCatCloud => 'السحابة والبنية التحتية';

  @override
  String get skillCatLanguages => 'اللغات والتواصل';

  @override
  String get hatThinking => 'التفكير';

  @override
  String get hatCommunicating => 'التواصل';

  @override
  String get hatSorting => 'الفرز';

  @override
  String get hatBuilding => 'البناء';

  @override
  String get hatFixing => 'الإصلاح';

  @override
  String get hatCompassion => 'التعاطف';

  @override
  String get archTopicClean => 'البنية النظيفة لتطبيقات الهاتف';

  @override
  String get archTopicOffline => 'المزامنة بأولوية العمل دون اتصال';

  @override
  String get archTopicNfc => 'مسار البطاقات الذكية ISO-7816 وNFC';

  @override
  String get archTopicKeystore =>
      'مخزن المفاتيح المدعوم بالعتاد ودورة حياة JWT';

  @override
  String get archTopicState => 'إدارة الحالة التفاعلية (BLoC)';

  @override
  String get uiComposeInquiry => 'كتابة استفسار';

  @override
  String get uiPresetsTitle => 'قوالب تواصل سريعة بلمسة واحدة';

  @override
  String get uiActiveHours => 'ضمن ساعات العمل';

  @override
  String get uiStandbyAsync => 'أرد خلال يوم';

  @override
  String get uiRelocating => 'الانتقال إلى برنو 2027';

  @override
  String get uiInquireTrack => 'استفسر عن هذا المسار';

  @override
  String get uiComposerTitle => 'نموذج الاستفسار المباشر';

  @override
  String get uiSelectTrack => 'اختر نوع التعاون';

  @override
  String get uiCopyDraft => 'نسخ المسودة';

  @override
  String get uiSending => 'جارٍ الإرسال...';

  @override
  String get uiSendMessage => 'إرسال الرسالة';

  @override
  String get uiOpenEmailClient => 'فتح في تطبيق البريد';

  @override
  String get uiReadCaseStudy => 'قراءة دراسة الحالة';

  @override
  String get uiNoCaseStudies => 'لا توجد دراسات حالة مطابقة';

  @override
  String get uiResetFilters => 'إعادة ضبط الفلاتر';

  @override
  String get uiScrollToExplore => 'مرّر للاستكشاف';

  @override
  String get uiPortfolioSections => 'أقسام الملف';

  @override
  String get uiDownloadResumePdf => 'تنزيل السيرة الذاتية · PDF';

  @override
  String get uiDragCardsHint =>
      'اسحب البطاقات · انقر للقلب · اخلط لإعادة الترتيب';

  @override
  String get uiTapSwipeHint => 'اضغط للقلب · اسحب لتغيير الدور';

  @override
  String get uiTapToReturn => 'اضغط للعودة';

  @override
  String get uiArchFlowchart => 'مخطط البنية';

  @override
  String get uiArchRationale => 'مبررات البنية (لماذا هذا الخيار)';

  @override
  String get uiKeySafeguards => 'ضمانات التنفيذ الأساسية';

  @override
  String get uiLatencyBudget => 'ميزانية زمن الاستجابة لكل طبقة';

  @override
  String get uiActiveTrace => 'المسار النشط';

  @override
  String get uiLatestDispatch => 'الأحدث';

  @override
  String badgeSkills(int count) {
    return '$count تخصصًا أساسيًا';
  }

  @override
  String badgeCaseStudies(int count) {
    return '$count دراسات حالة';
  }

  @override
  String badgeArchitectures(int count) {
    return '$count هياكل معمارية';
  }

  @override
  String badgeRoles(int count) {
    return '$count أدوار · أثر مؤسسي';
  }

  @override
  String get coverName => 'عبدالله الحياري';

  @override
  String get coverStatement =>
      'تطبيقات جوال تعمل دون اتصال، وتقرأ البطاقات الذكية، وتحمي بيانات المرضى.';

  @override
  String get coverLead =>
      'أنا مهندس فلاتر وأندرويد أول بخبرة خمس سنوات في تطبيقات المؤسسات للرعاية الصحية والتعليم والتجارة. أقيم في عمّان وأنتقل إلى برنو في 2027.';

  @override
  String get coverEmailPrefix => 'أو راسلني على';

  @override
  String get cardHintTap => 'انقر على البطاقة لقراءة شريحتها';

  @override
  String get cardHintClick => 'انقر على البطاقة لقراءة شريحتها';

  @override
  String get cardHintTurnBackTap => 'انقر على البطاقة مرة أخرى لقلبها';

  @override
  String get cardHintTurnBackClick => 'انقر على البطاقة مرة أخرى لقلبها';

  @override
  String get cardSurname => 'الحياري';

  @override
  String get cardGivenName => 'عبدالله';

  @override
  String get cardFieldSurname => 'اسم العائلة';

  @override
  String get cardFieldGiven => 'الاسم';

  @override
  String get cardFieldRole => 'الدور';

  @override
  String get cardFieldBase => 'مكان الإقامة';

  @override
  String get cardRole => 'مهندس تطبيقات جوال أول';

  @override
  String get cardBase => 'عمّان، وبرنو ابتداءً من 2027';

  @override
  String get cardBackTitle => 'مقروء من الشريحة';

  @override
  String get cardOutcome1 =>
      'استبدال المطالبات الورقية بتحقق لاسلكي عبر البطاقة الذكية';

  @override
  String get cardOutcome2 =>
      'قراءة NFC في أقل من ثانية على مجموعة واسعة من هواتف أندرويد';

  @override
  String get cardOutcome3 =>
      'أعطال أقل بنسبة 35% وأداء ثابت بمعدل 60 إطارًا في الثانية في تطبيقات المستشفيات كثيفة البيانات';

  @override
  String get cardSemantics =>
      'بطاقة تعريف عبدالله الحياري. فعّلها لقراءة الشريحة وقلب البطاقة.';

  @override
  String get coverHintDrag => 'اسحب البطاقة إلى القارئ أو انقر عليها.';

  @override
  String get coverHintTap => 'انقر على البطاقة لقراءتها.';

  @override
  String get coverGranted => 'تم السماح بالدخول';

  @override
  String get introPitch =>
      'أبني تطبيقات Flutter وAndroid جاهزة للإنتاج: مزامنة تعمل دون اتصال، وبطاقات NFC ذكية، ومصادقة آمنة. وأبقى معها بعد الإطلاق.';

  @override
  String get projectFigureValueNatHealth => '+400,000';

  @override
  String get projectFigureLabelNatHealth =>
      'مستفيد في الأردن وفلسطين والعراق. حلّت بطاقات NFC محل المطالبات الورقية.';

  @override
  String get projectFigureValueEskadenia => '35%';

  @override
  String get projectFigureLabelEskadenia =>
      'أعطال أقل، مع 60 إطاراً في الثانية بثبات على جداول بيانات المستشفيات الكثيفة.';

  @override
  String get projectFigureValueSolutions => '+4.7';

  @override
  String get projectFigureLabelSolutions =>
      'نجمة تقييم في المتجر. أُطلق التطبيقان في موعدهما.';

  @override
  String get heroFactAvailableLabel => 'التوفر';

  @override
  String get heroFactAvailableValue =>
      'عن بُعد أو بدوام جزئي الآن. حضورياً في برنو من فبراير 2027.';

  @override
  String get heroFactPermitLabel => 'تصريح العمل';

  @override
  String get heroFactPermitValue =>
      'غير مطلوب في التشيك أثناء دراستي بدوام كامل.';

  @override
  String get heroFactBasedLabel => 'مقيم في';

  @override
  String get heroFactBasedValue => 'عمّان، الأردن';

  @override
  String get heroFactFocusLabel => 'التخصص';

  @override
  String get heroFactFocusValue =>
      'بطاقات NFC الذكية، والمزامنة دون اتصال، والمصادقة الآمنة';

  @override
  String get heroFactLanguagesLabel => 'اللغات';

  @override
  String get heroFactLanguagesValue => 'الإنجليزية (مهنية)، العربية (لغة أم)';

  @override
  String get heroFactStudyLabel => 'الدراسة';

  @override
  String get heroFactStudyValue =>
      'ماجستير المعلوماتية المفتوحة، جامعة مندل، من فبراير 2027';

  @override
  String get traceCta => 'تتبّع نقرة';

  @override
  String get traceAgain => 'تتبّع مجدداً';

  @override
  String get traceDone => 'أُدرجت المطالبة في الطابور وتمت مزامنتها وتأكيدها.';

  @override
  String get traceHint =>
      'تابع مطالبة NFC واحدة عبر كل طبقة. مرّر المؤشر فوق خطوة لقراءة ما يحدث فيها.';

  @override
  String get traceNote =>
      'أسماء الاستدعاءات توضيحية. التدفق مبسّط من عملي على مطالبات NFC في NatHealth.';

  @override
  String get traceRunning => 'جارٍ التتبّع…';

  @override
  String get traceDetailFlutter =>
      'تتحول النقرة إلى استدعاء Dart مُنمَّط. لا تلمس الواجهة العتاد أو المفاتيح أبداً.';

  @override
  String get traceDetailChannel =>
      'تعبر الاستدعاءات حدّ Dart إلى Kotlin كرسائل مُسلسلة. وتعود الإخفاقات كأخطاء مُنمَّطة.';

  @override
  String get traceDetailNative =>
      'يتحدث Kotlin إلى البطاقة عبر ISO-DEP: تحديد، ثم مصادقة، ثم قراءة. هذا ما لا تستطيعه Flutter وحدها.';

  @override
  String get traceDetailSecurity =>
      'تُوقَّع الرموز بمفاتيح مدعومة بالعتاد. وعند غياب الشبكة تُوضع المطالبة في طابور ويعيد WorkManager المحاولة.';

  @override
  String get traceDetailBackend =>
      'REST عبر HTTPS بمصادقة JWT. ويغلق ردّ الخادم الحلقة للمطالبة المنتظرة.';

  @override
  String get traceStepFlutter => 'Flutter UI';

  @override
  String get traceStepChannel => 'Platform channel';

  @override
  String get traceStepNative => 'Native Android';

  @override
  String get traceStepSecurity => 'الأمان والمزامنة';

  @override
  String get traceStepBackend => 'Backend';

  @override
  String get introTagline =>
      'مهندس تطبيقات هواتف أبني برمجيات تعمل خلف الشاشة.';

  @override
  String get introPitch2 =>
      'تطبيقات Flutter وAndroid الأصلية جاهزة للإنتاج: بطاقات NFC الذكية، والتشفير، والمزامنة دون اتصال، وتكاملات المؤسسات.';

  @override
  String get letsTalk => 'لنتحدث';

  @override
  String get downloadCv => 'تحميل السيرة الذاتية';

  @override
  String get aboutTitle => 'نبذة';

  @override
  String get aboutSubtitle =>
      'كيف أعمل كمهندس، والمشكلات التي أحلّها، وبعض الأمور التي يمكنك تشغيلها بنفسك.';

  @override
  String get aboutTabProfile => 'الملف';

  @override
  String get aboutTabHood => 'تحت الغطاء';

  @override
  String get aboutTabPlayground => 'ساحة التجارب';

  @override
  String get aboutEngineerLabel => 'المهندس';

  @override
  String get aboutEngineerValue => 'Flutter وAndroid والأنظمة المحيطة بهما';

  @override
  String get aboutExperienceLabel => 'الخبرة';

  @override
  String aboutExperienceValue(int years) {
    return 'أكثر من $years سنوات في تطبيقات الهواتف';
  }

  @override
  String get aboutFocusLabel => 'التركيز';

  @override
  String get aboutFocusValue =>
      'أنظمة الهواتف، والتكامل مع النظام الأصلي، والأمان، وتطبيقات المؤسسات';

  @override
  String get aboutStackLabel => 'الأدوات';

  @override
  String get aboutStory =>
      'بدأت في تطبيقات الهواتف عام 2021 بإطلاق تطبيقات Flutter للتجارة والوسائط. وما أبقى اهتمامي هو الطبقة التي تحت الواجهة: Android الأصلي، وبطاقات NFC الذكية، والتشفير، والمزامنة في الخلفية.\n\nفي NatHealth أقود هذا العمل لمنصة مطالبات تُستخدم في الأردن وفلسطين والعراق. وأرتاح لوراثة نظام قديم معقّد وتركه معيارياً وقابلاً للاختبار.';

  @override
  String get aboutHoodHint => 'اختر قدرة لترى كيف أستخدمها.';

  @override
  String get aboutWhereLabel => 'أين استخدمتها';

  @override
  String get hoodNfcTitle => 'NFC';

  @override
  String get hoodNfcTag => 'اتصال ومصادقة آمنان مع البطاقات.';

  @override
  String get hoodNfcDetail =>
      'طبقة Kotlin أصلية تتحدث مع البطاقات الذكية عبر ISO 7816 APDU. صممت واجهة قارئ البطاقات لتقف عدة تقنيات بطاقات خلف عقد واحد.';

  @override
  String get hoodNfcWhere => 'NatHealth';

  @override
  String get hoodCryptoTitle => 'التشفير';

  @override
  String get hoodCryptoTag => 'RSA وAES وPBKDF2 مع تعامل دقيق مع المفاتيح.';

  @override
  String get hoodCryptoDetail =>
      'إصدار JWT على خطوتين، وتخزين آمن للرموز، وربط الجهاز بمعرّف GUID تحمي بيانات المرضى الحساسة.';

  @override
  String get hoodCryptoWhere => 'NatHealth';

  @override
  String get hoodBackgroundTitle => 'المعالجة في الخلفية';

  @override
  String get hoodBackgroundTag => 'مزامنة ومعالجة رسائل موثوقة.';

  @override
  String get hoodBackgroundDetail =>
      'يشغّل WorkManager المزامنة في الخلفية واستعلام الحالة وتجديد الرموز، فيكتمل العمل دون أن يراقبه المستخدم.';

  @override
  String get hoodBackgroundWhere => 'NatHealth';

  @override
  String get hoodOfflineTitle => 'دون اتصال أولاً';

  @override
  String get hoodOfflineTag => 'تطبيقات تواصل العمل حين ينقطع الاتصال.';

  @override
  String get hoodOfflineDetail =>
      'تُخزَّن الطلبات على الجهاز وتُرسل عند عودة الشبكة، مع إعادة محاولة بتراجع أسّي ومعالجة موحّدة للأخطاء.';

  @override
  String get hoodOfflineWhere => 'NatHealth';

  @override
  String get hoodNativeTitle => 'التكامل مع النظام الأصلي';

  @override
  String get hoodNativeTag => 'ربط Flutter بنظام Android الأصلي المعقّد.';

  @override
  String get hoodNativeDetail =>
      'تربط قنوات المنصة بين Dart وشيفرة Kotlin وJava للوصول إلى العتاد الذي لا تبلغه Flutter وحدها.';

  @override
  String get hoodNativeWhere => 'NatHealth';

  @override
  String get hoodEnterpriseTitle => 'أنظمة المؤسسات';

  @override
  String get hoodEnterpriseTag => 'الرعاية الصحية وERP وسير العمل الكبيرة.';

  @override
  String get hoodEnterpriseDetail =>
      'بنية معيارية ومكوّنات قابلة لإعادة الاستخدام عبر عملاء الرعاية الصحية والتعليم الإلكتروني وERP، أُعيد بناؤها دون إيقاف التطبيقات.';

  @override
  String get hoodEnterpriseWhere => 'ESKADENIA Software';

  @override
  String get playKdfTitle => 'اشتقاق المفتاح';

  @override
  String get playKdfIntro =>
      'PBKDF2-HMAC-SHA256 يعمل في متصفحك. كلما زادت التكرارات أصبح كل تخمين لكلمة المرور أبطأ، على المهاجم وعليك.';

  @override
  String get playKdfPassword => 'كلمة المرور';

  @override
  String get playKdfIterations => 'التكرارات';

  @override
  String get playKdfRun => 'اشتقاق المفتاح';

  @override
  String get playKdfRunning => 'جارٍ الاشتقاق…';

  @override
  String get playKdfResult => 'المفتاح المشتق (256 بت)';

  @override
  String playKdfTime(int ms) {
    return 'استغرق $ms مللي ثانية على هذا الجهاز.';
  }

  @override
  String get playKdfNote =>
      'الملح ثابت في هذا العرض. الأنظمة الحقيقية تستخدم ملحاً عشوائياً لكل مستخدم.';

  @override
  String get playSyncTitle => 'من دون اتصال إلى متصل';

  @override
  String get playSyncIntro =>
      'قدّم مطالبات وأنت دون اتصال. تنتظر في الطابور على الجهاز وتُزامَن عند عودة الاتصال، مع إعادة المحاولة بتراجع أسّي.';

  @override
  String get playSyncOnline => 'متصل';

  @override
  String get playSyncOffline => 'دون اتصال';

  @override
  String get playSyncFlaky => 'شبكة غير مستقرة';

  @override
  String get playSyncSubmit => 'إرسال مطالبة';

  @override
  String get playSyncEmpty => 'لا مطالبات بعد. أرسل واحدة.';

  @override
  String get playSyncQueued => 'في الطابور';

  @override
  String get playSyncSending => 'قيد الإرسال';

  @override
  String get playSyncSynced => 'تمت المزامنة';

  @override
  String playSyncRetry(int seconds) {
    return 'إعادة المحاولة بعد $seconds ث';
  }

  @override
  String playSyncClaim(int number) {
    return 'المطالبة $number';
  }

  @override
  String get playSyncNote => 'محاكاة. لا تُستخدم أي شبكة.';

  @override
  String get navPerspectives => 'رؤى';

  @override
  String get projectLblProblem => 'المشكلة';

  @override
  String get projectLblSystem => 'النظام';

  @override
  String get projectLblRole => 'دوري';

  @override
  String get projectProblemNatHealth =>
      'المطالبات الورقية ومخاطر الاحتيال وضعف اتصال العيادات أبطأت معالجة مطالبات التأمين.';

  @override
  String get projectSystemNatHealth =>
      'جسر NFC بـ Kotlin إلى البطاقات الذكية، وJWT مع ربط الجهاز، وطابور WorkManager يعمل دون اتصال.';

  @override
  String get projectRoleNatHealth =>
      'قدت بنية التطبيق وتكامل NFC الأصلي والأمان.';

  @override
  String get projectProblemEskadenia =>
      'تطبيقات المستشفيات والجامعات القديمة كانت تُسقط الإطارات وتخلط الحالة وتستهلك ذاكرة كبيرة.';

  @override
  String get projectSystemEskadenia =>
      'حزم ميزات MVVM منفصلة، وطبقات REST مُنمَّطة، ومستودعات مخزّنة مؤقتاً.';

  @override
  String get projectRoleEskadenia =>
      'قدت إعادة الهيكلة المعمارية والتحليل واستخراج الحزم.';

  @override
  String get projectProblemSolutions =>
      'تطبيقان استهلاكيان كبيران، محرك ولاء وقصص فورية، كان عليهما الإطلاق في مواعيد ضيقة.';

  @override
  String get projectSystemSolutions =>
      'مكتبة مكوّنات Flutter مشتركة، ومسارات كاميرا وفيديو بتسريع عتادي، ونماذج REST ديناميكية.';

  @override
  String get projectRoleSolutions =>
      'وضعت معايير تصميم الهواتف وبنيت مسارات الكاميرا وتكامل الخلفية.';

  @override
  String get projectProblemFais =>
      'كان على الدفع متعدد الخطوات وبث الوسائط المستمر أن يعملا دون تسرّب ذاكرة أو تسابق حالات.';

  @override
  String get projectSystemFais =>
      'تكامل شامل لواجهات الدفع مع مفاتيح idempotency، وتشخيص المشكلات الحية من بيانات القياس.';

  @override
  String get projectRoleFais =>
      'نسّقت التكامل بين الخلفية والواجهة وحللت مشكلات الإنتاج.';

  @override
  String get navAvailable => 'متاح لفرص جديدة';

  @override
  String get expLblChallenge => 'التحدي';

  @override
  String get expLblImpact => 'الأثر';

  @override
  String get playAesTitle => 'التشفير وفك التشفير';

  @override
  String get playAesIntro =>
      'AES-256-CBC بمفتاح مشتق من كلمة المرور عبر PBKDF2. كل شيء يعمل في متصفحك.';

  @override
  String get playAesMessage => 'الرسالة';

  @override
  String get playAesPassword => 'كلمة المرور';

  @override
  String get playAesEncrypt => 'تشفير';

  @override
  String get playAesDecryptWith => 'فك التشفير بكلمة المرور';

  @override
  String get playAesDecrypt => 'فك التشفير';

  @override
  String get playAesIv => 'IV';

  @override
  String get playAesCipher => 'النص المشفّر';

  @override
  String get playAesPlain => 'النص بعد فك التشفير';

  @override
  String get playAesWrongKey =>
      'مفتاح خاطئ: الحشو غير صالح لذا يتوقف فك التشفير.';

  @override
  String get playAesNote =>
      'CBC يخفي الرسالة لكنه لا يكشف العبث. الأنظمة الحقيقية تضيف MAC أو تستخدم وضع AEAD مثل GCM.';

  @override
  String get playApduTitle => 'تبادل مع البطاقة الذكية';

  @override
  String get playApduIntro =>
      'أمر APDU وفق ISO 7816 ورد البطاقة، بايتاً بايتاً. البطاقة هنا محاكاة.';

  @override
  String get playApduSelect => 'تحديد التطبيق';

  @override
  String get playApduRead => 'قراءة 16 بايت';

  @override
  String get playApduUnknown => 'تحديد تطبيق غير معروف';

  @override
  String get playApduBadClass => 'صنف غير مدعوم';

  @override
  String get playApduCommand => 'الأمر';

  @override
  String get playApduResponse => 'الرد';

  @override
  String get playApduData => 'البيانات';

  @override
  String get playApduStatus => 'الحالة';

  @override
  String get playApduNote => 'محاكاة. كلمات الحالة رموز ISO 7816-4 حقيقية.';

  @override
  String get apduSw9000 => 'نجاح';

  @override
  String get apduSw6A82 => 'الملف أو التطبيق غير موجود';

  @override
  String get apduSw6E00 => 'الصنف غير مدعوم';

  @override
  String get playChanTitle => 'رسالة قناة المنصة';

  @override
  String get playChanIntro =>
      'يُسلسَل استدعاء من Flutter إلى Kotlin إلى بايتات قبل عبور الحدّ. هذه هي البايتات الحقيقية التي ينتجها المرمّز القياسي في Flutter.';

  @override
  String get playChanMethod => 'الدالة';

  @override
  String get playChanTimeout => 'المهلة (مللي ثانية)';

  @override
  String playChanBytes(int count) {
    return '$count بايت على السلك';
  }

  @override
  String get playChanDecoded => 'بعد فك الترميز في الجانب الأصلي';

  @override
  String get playChanNote => 'مرمَّز بـ StandardMethodCodec.';

  @override
  String get aboutTryIt => 'جرّبه في ساحة التجارب';
}
