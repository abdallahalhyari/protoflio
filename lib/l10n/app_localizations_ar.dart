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
  String get introLocation => 'عمان، الأردن → برنو، التشيك (2027)';

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
  String get keyboardHintArrows => '↑ ↓   السابق / التالي';

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
}
