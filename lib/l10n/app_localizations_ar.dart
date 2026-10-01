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
  String get navWork => 'أبرز الأعمال';

  @override
  String get navEngineering => 'الهندسة';

  @override
  String get navExperience => 'الخبرات';

  @override
  String get navStack => 'المهارات والتقنيات';

  @override
  String get navAbout => 'رؤى';

  @override
  String get navContact => 'تواصل';

  @override
  String get navResume => 'السيرة الذاتية';

  @override
  String get introLocation => 'عمان، الأردن ‹ برنو، التشيك (2027)';

  @override
  String get sectionEducation => 'التعليم';

  @override
  String get sectionCertifications => 'الشهادات';

  @override
  String get contactHeroEyebrow => 'البريد المباشر · الرد الأسرع';

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
  String get contactMe => 'تواصل معي';

  @override
  String get copyEmail => 'نسخ البريد';

  @override
  String get introSeniorEngineer => 'مهندس تطبيقات هواتف أول';

  @override
  String get introWorkEligibility => 'مؤهل للعمل في التشيك · طالب';

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
  String get footerRightsReserved => '© 2026 · جميع الحقوق محفوظة';

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
  String get introIssueStrip => 'الإصدار 01 · نسخة معرض الأعمال · 2026';

  @override
  String get introBuildsComplex =>
      'يبني أنظمة هواتف محمولة معقدة، موثوقة، وقابلة للتوسع';

  @override
  String get introTechStack =>
      'فلاتر · أندرويد · آي أو إس · معمارية برمجيات · أنظمة دون اتصال · NFC · أمان · أنظمة الوقت الفعلي';

  @override
  String get introBasedIn => 'مقر العمل';

  @override
  String get introStatus => 'الحالة';

  @override
  String get introOpenForRoles => 'متاح للأدوار القيادية';

  @override
  String get introDiscipline => 'التخصص';

  @override
  String get introMobileArch => 'بنية تطبيقات الهواتف';

  @override
  String get introMasthead => '// الترويسة';

  @override
  String get navSectionCover => 'الغلاف والملف الشخصي';

  @override
  String get navSubCover => 'مهندس تطبيقات فلاتر وأندرويد أول';

  @override
  String get navSectionExperience => 'الخبرات';

  @override
  String get navSubExperience => '+5 سنوات من هندسة الأنظمة المؤسسية';

  @override
  String get navSectionWork => 'أبرز الأعمال';

  @override
  String get navSubWork => 'أنظمة الإنتاج ودراسات الحالة المتعمقة';

  @override
  String get navSectionStack => 'المهارات والتقنيات';

  @override
  String get navSubStack => 'مصفوفة الكفاءة الهندسية والتقنية';

  @override
  String get navSectionEngineering => 'الهندسة';

  @override
  String get navSubEngineering => 'مخططات معمارية وأنظمة تدعم وضع عدم الاتصال';

  @override
  String get navSectionAbout => 'رؤى';

  @override
  String get navSubAbout => 'وجهات نظر معمارية وأدوار قيادية';

  @override
  String get navSectionContact => 'تواصل';

  @override
  String get navSubContact => 'القنوات المباشرة وحالة التوفر';

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
      'نظرة معمّقة على البنية المعمارية والتنفيذ والنتائج القابلة للقياس.';

  @override
  String get sectionSubtitleExperience =>
      'سنوات من تطوير أنظمة الهاتف المحمول للمؤسسات';

  @override
  String get sectionSubtitleSkills =>
      'التخصصات والتقنيات التي يقوم عليها العمل · اقلب أي بطاقة لعرض التفاصيل';

  @override
  String get sectionSubtitleEngineering =>
      'هياكل معمارية مُختبَرة في بيئات الإنتاج خلف تطبيقات الهاتف';

  @override
  String get sectionSubtitleAbout => 'ستة أدوار يتنقّل بينها المهندس الخبير';

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
  String get uiStandbyAsync => 'خارج الدوام · رد لاحق';

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
}
