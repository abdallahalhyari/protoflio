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
  String get navWork => 'أعمالي';

  @override
  String get navEngineering => 'الهندسة';

  @override
  String get navExperience => 'الخبرات';

  @override
  String get navStack => 'التقنيات';

  @override
  String get navAbout => 'عني';

  @override
  String get navContact => 'تواصل';

  @override
  String get navResume => 'السيرة الذاتية';

  @override
  String get navSkills => 'مهارات';

  @override
  String get navProjects => 'مشاريع';

  @override
  String get introLocation => 'عمان، الأردن › برنو، التشيك (2027)';

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
  String get introSystemArchitect => 'مهندس نظم';

  @override
  String get introEuEligibility => 'مؤهل للعمل في أوروبا';

  @override
  String get introAvailableContracts => 'متاح للعقود';

  @override
  String get introMeticulouslyEngineered => 'معرض أعمال مصمم هندسياً بعناية.';

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
  String get contactInitiateEncrypted => 'بدء محادثة مشفرة';

  @override
  String get contactStartConversation => 'بدء محادثة';

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
  String get blocSectionTitle => 'عمارة BLoC / التصميم النظيف';

  @override
  String get blocSectionSubtitle =>
      'تغيرات حالة متوقعة عبر تدفق بيانات أحادي الاتجاه';

  @override
  String get blocStep1Title => 'إرسال حدث';

  @override
  String get blocStep1Desc =>
      'واجهة المستخدم تطلق حدثاً. لا يوجد منطق أعمال في الواجهات.';

  @override
  String get blocStep2Title => 'تعيين الحالة';

  @override
  String get blocStep2Desc => 'BLoC يعالج الحدث وينتج حالة جديدة ثابتة.';

  @override
  String get blocStep3Title => 'عرض المخرجات';

  @override
  String get blocStep3Desc =>
      'يتم إعادة بناء الواجهة بكفاءة بناءً على فروق الحالة الدقيقة.';

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
  String get navSubCover => 'مهندس ومعماري تطبيقات فلاتر وأندرويد أول';

  @override
  String get navSectionExperience => 'المسيرة المهنية والخبرات';

  @override
  String get navSubExperience => '+4 سنوات من هندسة الأنظمة المؤسسية';

  @override
  String get navSectionWork => 'أبرز الأعمال والمشاريع';

  @override
  String get navSubWork => 'أنظمة الإنتاج ودراسات الحالة المتعمقة';

  @override
  String get navSectionStack => 'المهارات والتقنيات';

  @override
  String get navSubStack => 'مصفوفة الكفاءة الهندسية والتقنية';

  @override
  String get navSectionEngineering => 'بنية وهندسة الأنظمة';

  @override
  String get navSubEngineering => 'مخططات معمارية وأنظمة تدعم وضع عدم الاتصال';

  @override
  String get navSectionAbout => 'رؤى وأدوار قيادية';

  @override
  String get navSubAbout => 'وجهات نظر معمارية وأدوار قيادية';

  @override
  String get navSectionContact => 'التواصل والاستفسارات';

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
      'التخصصات والتقنيات التي يقوم عليها العمل · اضغط على أي بطاقة لقلبها';

  @override
  String get sectionSubtitleEngineering =>
      'هياكل معمارية مُختبَرة في بيئات الإنتاج خلف تطبيقات الهاتف';

  @override
  String get sectionSubtitleAbout => 'ستة أدوار يتنقّل بينها المهندس الخبير';
}
