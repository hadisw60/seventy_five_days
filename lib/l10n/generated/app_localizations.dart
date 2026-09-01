import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'75 Days'**
  String get appTitle;

  /// No description provided for @remindersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTooltip;

  /// No description provided for @calendarTooltip.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTooltip;

  /// No description provided for @progressTooltip.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTooltip;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @completeDay.
  ///
  /// In en, this message translates to:
  /// **'Complete Day'**
  String get completeDay;

  /// No description provided for @finishChallenge.
  ///
  /// In en, this message translates to:
  /// **'Finish Challenge'**
  String get finishChallenge;

  /// No description provided for @challengeCompletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Challenge completed!'**
  String get challengeCompletedSnackbar;

  /// No description provided for @dayStartedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Day {day} started!'**
  String dayStartedSnackbar(int day);

  /// No description provided for @completeTheseFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete these first: {tasks}'**
  String completeTheseFirst(String tasks);

  /// No description provided for @yourChallenge.
  ///
  /// In en, this message translates to:
  /// **'Your 75 Day Challenge'**
  String get yourChallenge;

  /// No description provided for @dayOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Day {day} / {total}'**
  String dayOfTotal(int day, int total);

  /// No description provided for @percentCompleted.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the challenge completed'**
  String percentCompleted(String percent);

  /// No description provided for @requiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredLabel;

  /// No description provided for @requiredTapPhoto.
  ///
  /// In en, this message translates to:
  /// **'Required - tap to add a photo'**
  String get requiredTapPhoto;

  /// No description provided for @requiredTapTimer.
  ///
  /// In en, this message translates to:
  /// **'Required - tap to open the timer'**
  String get requiredTapTimer;

  /// No description provided for @taskReading.
  ///
  /// In en, this message translates to:
  /// **'Read 10 pages'**
  String get taskReading;

  /// No description provided for @taskTraining.
  ///
  /// In en, this message translates to:
  /// **'Train for 2 hours'**
  String get taskTraining;

  /// No description provided for @taskPrayer.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get taskPrayer;

  /// No description provided for @taskPhoto.
  ///
  /// In en, this message translates to:
  /// **'Today\'s progress photo'**
  String get taskPhoto;

  /// No description provided for @allTasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'All tasks completed. You can finish today!'**
  String get allTasksCompleted;

  /// No description provided for @challengeCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge Completed!'**
  String get challengeCompletedTitle;

  /// No description provided for @challengeCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'You finished all 75 days. That\'s it - no day 76, just take the win.'**
  String get challengeCompletedBody;

  /// No description provided for @howWasToday.
  ///
  /// In en, this message translates to:
  /// **'How was today? (optional)'**
  String get howWasToday;

  /// No description provided for @journalHint.
  ///
  /// In en, this message translates to:
  /// **'Write a quick note about your day...'**
  String get journalHint;

  /// No description provided for @reRecord.
  ///
  /// In en, this message translates to:
  /// **'Re-record'**
  String get reRecord;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// No description provided for @addVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Add a voice note'**
  String get addVoiceNote;

  /// No description provided for @voiceNoteSaved.
  ///
  /// In en, this message translates to:
  /// **'Voice note saved'**
  String get voiceNoteSaved;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodGreat;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// No description provided for @moodOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodOkay;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get moodBad;

  /// No description provided for @moodTerrible.
  ///
  /// In en, this message translates to:
  /// **'Terrible'**
  String get moodTerrible;

  /// No description provided for @dayNumber.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayNumber(int day);

  /// No description provided for @noPhotoForDay.
  ///
  /// In en, this message translates to:
  /// **'No photo saved for this day'**
  String get noPhotoForDay;

  /// No description provided for @feltMood.
  ///
  /// In en, this message translates to:
  /// **'Felt {mood}'**
  String feltMood(String mood);

  /// No description provided for @completedDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed Days'**
  String get completedDaysTitle;

  /// No description provided for @daysDone.
  ///
  /// In en, this message translates to:
  /// **'Days done'**
  String get daysDone;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get daysLeft;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressLabel;

  /// No description provided for @noCompletedDaysYet.
  ///
  /// In en, this message translates to:
  /// **'No completed days yet. Finish today to start your history.'**
  String get noCompletedDaysYet;

  /// No description provided for @learningTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Timer'**
  String get learningTimerTitle;

  /// No description provided for @ofDuration.
  ///
  /// In en, this message translates to:
  /// **'of {duration}'**
  String ofDuration(String duration);

  /// No description provided for @trainingCompleteToday.
  ///
  /// In en, this message translates to:
  /// **'Training complete for today!'**
  String get trainingCompleteToday;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @timerBackgroundNote.
  ///
  /// In en, this message translates to:
  /// **'The timer keeps running in the background even if you leave this screen.'**
  String get timerBackgroundNote;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// No description provided for @nudgeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Nudge me if today\'s tasks aren\'t done yet'**
  String get nudgeSubtitle;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @reminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'75 Days Challenge'**
  String get reminderNotificationTitle;

  /// No description provided for @reminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget today\'s tasks!'**
  String get reminderNotificationBody;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was denied.'**
  String get notificationPermissionDenied;

  /// No description provided for @couldNotScheduleReminder.
  ///
  /// In en, this message translates to:
  /// **'Could not schedule the reminder: {error}'**
  String couldNotScheduleReminder(String error);

  /// No description provided for @couldNotRescheduleReminder.
  ///
  /// In en, this message translates to:
  /// **'Could not reschedule the reminder: {error}'**
  String couldNotRescheduleReminder(String error);

  /// No description provided for @couldNotRearmReminder.
  ///
  /// In en, this message translates to:
  /// **'Could not re-arm the daily reminder: {error}'**
  String couldNotRearmReminder(String error);

  /// No description provided for @couldNotLoadProgress.
  ///
  /// In en, this message translates to:
  /// **'Could not load your saved progress. Starting fresh.'**
  String get couldNotLoadProgress;

  /// No description provided for @couldNotSaveProgress.
  ///
  /// In en, this message translates to:
  /// **'Could not save your progress.'**
  String get couldNotSaveProgress;

  /// No description provided for @couldNotCapturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not capture photo: {error}'**
  String couldNotCapturePhoto(String error);

  /// No description provided for @couldNotStartRecording.
  ///
  /// In en, this message translates to:
  /// **'Could not start recording: {error}'**
  String couldNotStartRecording(String error);

  /// No description provided for @couldNotSaveRecording.
  ///
  /// In en, this message translates to:
  /// **'Could not save recording: {error}'**
  String couldNotSaveRecording(String error);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePersian.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get languagePersian;

  /// No description provided for @languageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystemDefault;

  /// No description provided for @transformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Transformation'**
  String get transformationTitle;

  /// No description provided for @viewTransformation.
  ///
  /// In en, this message translates to:
  /// **'View Transformation'**
  String get viewTransformation;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @beforeAfterTitle.
  ///
  /// In en, this message translates to:
  /// **'Before / After'**
  String get beforeAfterTitle;

  /// No description provided for @beforeLabel.
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get beforeLabel;

  /// No description provided for @afterLabel.
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get afterLabel;

  /// No description provided for @viewBeforeAfter.
  ///
  /// In en, this message translates to:
  /// **'View Before / After'**
  String get viewBeforeAfter;

  /// No description provided for @beforeAfterNeedsMorePhotos.
  ///
  /// In en, this message translates to:
  /// **'Take progress photos on at least two days to see a before/after comparison.'**
  String get beforeAfterNeedsMorePhotos;

  /// No description provided for @weightCheckinTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Check-in'**
  String get weightCheckinTitle;

  /// No description provided for @weightCheckinBody.
  ///
  /// In en, this message translates to:
  /// **'Day {day} — time to log your weight'**
  String weightCheckinBody(int day);

  /// No description provided for @logWeight.
  ///
  /// In en, this message translates to:
  /// **'Log Weight'**
  String get logWeight;

  /// No description provided for @weightDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightDialogHint;

  /// No description provided for @weightProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Progress'**
  String get weightProgressTitle;

  /// No description provided for @noWeightEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No weight logged yet. You\'ll be checked in every 15 days.'**
  String get noWeightEntriesYet;

  /// No description provided for @weightEntryLine.
  ///
  /// In en, this message translates to:
  /// **'Day {day}: {weight} kg'**
  String weightEntryLine(int day, String weight);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @quote1.
  ///
  /// In en, this message translates to:
  /// **'Discipline is choosing what you want most over what you want now.'**
  String get quote1;

  /// No description provided for @quote2.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to be great to start, but you have to start to be great.'**
  String get quote2;

  /// No description provided for @quote3.
  ///
  /// In en, this message translates to:
  /// **'Small steps every day add up to big change.'**
  String get quote3;

  /// No description provided for @quote4.
  ///
  /// In en, this message translates to:
  /// **'Show up for yourself today. Future you is watching.'**
  String get quote4;

  /// No description provided for @quote5.
  ///
  /// In en, this message translates to:
  /// **'Progress, not perfection.'**
  String get quote5;

  /// No description provided for @quote6.
  ///
  /// In en, this message translates to:
  /// **'The pain of discipline weighs ounces; the pain of regret weighs tons.'**
  String get quote6;

  /// No description provided for @quote7.
  ///
  /// In en, this message translates to:
  /// **'You\'re not just building a habit, you\'re building who you are.'**
  String get quote7;

  /// No description provided for @quote8.
  ///
  /// In en, this message translates to:
  /// **'One more day, one more brick in the wall you are building.'**
  String get quote8;

  /// No description provided for @quote9.
  ///
  /// In en, this message translates to:
  /// **'Consistency beats intensity.'**
  String get quote9;

  /// No description provided for @quote10.
  ///
  /// In en, this message translates to:
  /// **'Nobody is coming to save you. Save yourself, one day at a time.'**
  String get quote10;
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
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
