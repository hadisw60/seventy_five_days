// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => '۷۵ روز';

  @override
  String get remindersTooltip => 'یادآوری‌ها';

  @override
  String get calendarTooltip => 'تقویم';

  @override
  String get progressTooltip => 'پیشرفت';

  @override
  String get todaysTasks => 'تسک‌های امروز';

  @override
  String get completeDay => 'اتمام روز';

  @override
  String get finishChallenge => 'پایان چالش';

  @override
  String get challengeCompletedSnackbar => 'چالش تکمیل شد!';

  @override
  String dayStartedSnackbar(int day) {
    return 'روز $day شروع شد!';
  }

  @override
  String completeTheseFirst(String tasks) {
    return 'اول این‌ها رو تموم کن: $tasks';
  }

  @override
  String get yourChallenge => 'چالش ۷۵ روزه‌ی تو';

  @override
  String dayOfTotal(int day, int total) {
    return 'روز $day / $total';
  }

  @override
  String percentCompleted(String percent) {
    return '$percent٪ از چالش تکمیل شده';
  }

  @override
  String get requiredLabel => 'الزامی';

  @override
  String get requiredTapPhoto => 'الزامی - برای افزودن عکس بزن';

  @override
  String get requiredTapTimer => 'الزامی - برای باز کردن تایمر بزن';

  @override
  String get taskReading => '۱۰ صفحه مطالعه';

  @override
  String get taskTraining => '۲ ساعت برنامه‌نویسی';

  @override
  String get taskPrayer => 'نماز';

  @override
  String get taskPhoto => 'عکس پیشرفت امروز';

  @override
  String get taskGym => 'باشگاه (۴۵ دقیقه)';

  @override
  String get taskWalking => 'پیاده‌روی (۴۵ دقیقه)';

  @override
  String get taskCheckin => 'چک-این روزانه';

  @override
  String get optionalRestDay => 'امروز اختیاری - روز ریکاوری';

  @override
  String get allTasksCompleted =>
      'همه‌ی تسک‌ها انجام شد. می‌تونی امروز رو تموم کنی!';

  @override
  String get challengeCompletedTitle => 'چالش تکمیل شد!';

  @override
  String get challengeCompletedBody =>
      'هر ۷۵ روز رو تموم کردی. همینه - روز ۷۶ای در کار نیست، فقط لذت پیروزی رو ببر.';

  @override
  String get howWasToday => 'امروز چطور بود؟';

  @override
  String get checkinRequiredHint =>
      'الزامی - حال روحی، انرژی و میزان پایبندی رو انتخاب کن تا روز تموم بشه';

  @override
  String get journalHint => 'یه یادداشت کوتاه از روزت بنویس (اختیاری)...';

  @override
  String get reRecord => 'ضبط دوباره';

  @override
  String get stopRecording => 'توقف ضبط';

  @override
  String get addVoiceNote => 'افزودن یادداشت صوتی';

  @override
  String get voiceNoteSaved => 'یادداشت صوتی ذخیره شد';

  @override
  String get moodGreat => 'عالی';

  @override
  String get moodGood => 'خوب';

  @override
  String get moodOkay => 'معمولی';

  @override
  String get moodBad => 'بد';

  @override
  String get moodTerrible => 'خیلی بد';

  @override
  String get energyTitle => 'انرژی';

  @override
  String get energyLow => 'کم';

  @override
  String get energyMedium => 'متوسط';

  @override
  String get energyHigh => 'زیاد';

  @override
  String get adherenceTitle => 'چقدر به قوانین امروز پایبند بودی؟';

  @override
  String get adherenceShortLabel => 'پایبندی';

  @override
  String get adherenceFull => 'کامل';

  @override
  String get adherencePartial => 'تا حدی';

  @override
  String get adherenceWeak => 'خیلی کم';

  @override
  String dayNumber(int day) {
    return 'روز $day';
  }

  @override
  String get noPhotoForDay => 'برای این روز عکسی ذخیره نشده';

  @override
  String feltMood(String mood) {
    return 'حس $mood داشتی';
  }

  @override
  String get completedDaysTitle => 'روزهای تکمیل‌شده';

  @override
  String get daysDone => 'روزهای انجام‌شده';

  @override
  String get daysLeft => 'روزهای باقی‌مانده';

  @override
  String get progressLabel => 'پیشرفت';

  @override
  String get noCompletedDaysYet =>
      'هنوز هیچ روزی تکمیل نشده. امروز رو تموم کن تا تاریخچه‌ت شروع بشه.';

  @override
  String get learningTimerTitle => 'تایمر تمرین';

  @override
  String ofDuration(String duration) {
    return 'از $duration';
  }

  @override
  String get trainingCompleteToday => 'تمرین امروز تموم شد!';

  @override
  String get start => 'شروع';

  @override
  String get pause => 'توقف موقت';

  @override
  String get timerBackgroundNote =>
      'حتی اگه از این صفحه بری، تایمر تو پس‌زمینه ادامه پیدا می‌کنه.';

  @override
  String get remindersTitle => 'یادآوری‌ها';

  @override
  String get dailyReminder => 'یادآوری روزانه';

  @override
  String get nudgeSubtitle => 'اگه تسک‌های امروز هنوز تموم نشده، یادم بنداز';

  @override
  String get reminderTime => 'ساعت یادآوری';

  @override
  String get reminderNotificationTitle => 'چالش ۷۵ روز';

  @override
  String get reminderNotificationBody => 'تسک‌های امروزت رو فراموش نکن!';

  @override
  String get notificationPermissionDenied => 'اجازه‌ی ارسال اعلان داده نشد.';

  @override
  String couldNotScheduleReminder(String error) {
    return 'یادآوری تنظیم نشد: $error';
  }

  @override
  String couldNotRescheduleReminder(String error) {
    return 'زمان یادآوری تغییر نکرد: $error';
  }

  @override
  String couldNotRearmReminder(String error) {
    return 'یادآوری روزانه دوباره فعال نشد: $error';
  }

  @override
  String get couldNotLoadProgress =>
      'پیشرفت ذخیره‌شده لود نشد. از اول شروع می‌کنیم.';

  @override
  String get couldNotSaveProgress => 'پیشرفتت ذخیره نشد.';

  @override
  String couldNotCapturePhoto(String error) {
    return 'عکس گرفته نشد: $error';
  }

  @override
  String couldNotStartRecording(String error) {
    return 'ضبط شروع نشد: $error';
  }

  @override
  String couldNotSaveRecording(String error) {
    return 'ضبط ذخیره نشد: $error';
  }

  @override
  String get language => 'زبان';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get languageSystemDefault => 'پیش‌فرض سیستم';

  @override
  String get transformationTitle => 'دگرگونی تو';

  @override
  String get viewTransformation => 'مشاهده‌ی دگرگونی';

  @override
  String get backToHome => 'بازگشت به خانه';

  @override
  String get beforeAfterTitle => 'قبل / بعد';

  @override
  String get beforeLabel => 'قبل';

  @override
  String get afterLabel => 'بعد';

  @override
  String get viewBeforeAfter => 'مشاهده‌ی قبل / بعد';

  @override
  String get beforeAfterNeedsMorePhotos =>
      'برای مقایسه‌ی قبل/بعد، حداقل تو دو روز عکس پیشرفت بگیر.';

  @override
  String get weightCheckinTitle => 'چک‌این وزن';

  @override
  String weightCheckinBody(int day) {
    return 'روز $day — وقت ثبت وزنته';
  }

  @override
  String get logWeight => 'ثبت وزن';

  @override
  String get weightDialogHint => 'وزن (کیلوگرم)';

  @override
  String get weightProgressTitle => 'روند وزن';

  @override
  String get noWeightEntriesYet =>
      'هنوز وزنی ثبت نشده. هر ۱۵ روز یه‌بار ازت پرسیده می‌شه.';

  @override
  String weightEntryLine(int day, String weight) {
    return 'روز $day: $weight کیلوگرم';
  }

  @override
  String get save => 'ذخیره';

  @override
  String get cancel => 'انصراف';

  @override
  String get quote1 =>
      'نظم یعنی چیزی رو که واقعاً می‌خوای به چیزی که همین الان دلت می‌خواد ترجیح بدی.';

  @override
  String get quote2 =>
      'لازم نیست عالی باشی تا شروع کنی، ولی باید شروع کنی تا عالی بشی.';

  @override
  String get quote3 =>
      'قدم‌های کوچیک هر روز، جمع می‌شن و یه تغییر بزرگ می‌سازن.';

  @override
  String get quote4 => 'امروز پای خودت وایسا. خودِ آینده‌ت داره تماشا می‌کنه.';

  @override
  String get quote5 => 'پیشرفت مهمه، نه کمال.';

  @override
  String get quote6 => 'درد نظم و انضباط سبکه؛ درد پشیمونی سنگینه.';

  @override
  String get quote7 => 'تو فقط یه عادت نمی‌سازی، داری خودتو می‌سازی.';

  @override
  String get quote8 => 'یه روز دیگه، یه آجر دیگه رو دیواری که داری می‌سازی.';

  @override
  String get quote9 => 'تداوم از شدت مهم‌تره.';

  @override
  String get quote10 =>
      'هیچکس نمیاد نجاتت بده. خودتو نجات بده، یه روز در یک زمان.';
}
