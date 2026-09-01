// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => '75 Days';

  @override
  String get remindersTooltip => 'Reminders';

  @override
  String get calendarTooltip => 'Calendar';

  @override
  String get progressTooltip => 'Progress';

  @override
  String get todaysTasks => 'Today\'s Tasks';

  @override
  String get completeDay => 'Complete Day';

  @override
  String get finishChallenge => 'Finish Challenge';

  @override
  String get challengeCompletedSnackbar => 'Challenge completed!';

  @override
  String dayStartedSnackbar(int day) {
    return 'Day $day started!';
  }

  @override
  String completeTheseFirst(String tasks) {
    return 'Complete these first: $tasks';
  }

  @override
  String get yourChallenge => 'Your 75 Day Challenge';

  @override
  String dayOfTotal(int day, int total) {
    return 'Day $day / $total';
  }

  @override
  String percentCompleted(String percent) {
    return '$percent% of the challenge completed';
  }

  @override
  String get requiredLabel => 'Required';

  @override
  String get requiredTapPhoto => 'Required - tap to add a photo';

  @override
  String get requiredTapTimer => 'Required - tap to open the timer';

  @override
  String get taskReading => 'Read 10 pages';

  @override
  String get taskTraining => 'Train for 2 hours';

  @override
  String get taskPrayer => 'Prayer';

  @override
  String get taskPhoto => 'Today\'s progress photo';

  @override
  String get allTasksCompleted => 'All tasks completed. You can finish today!';

  @override
  String get challengeCompletedTitle => 'Challenge Completed!';

  @override
  String get challengeCompletedBody =>
      'You finished all 75 days. That\'s it - no day 76, just take the win.';

  @override
  String get howWasToday => 'How was today? (optional)';

  @override
  String get journalHint => 'Write a quick note about your day...';

  @override
  String get reRecord => 'Re-record';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get addVoiceNote => 'Add a voice note';

  @override
  String get voiceNoteSaved => 'Voice note saved';

  @override
  String get moodGreat => 'Great';

  @override
  String get moodGood => 'Good';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodBad => 'Bad';

  @override
  String get moodTerrible => 'Terrible';

  @override
  String dayNumber(int day) {
    return 'Day $day';
  }

  @override
  String get noPhotoForDay => 'No photo saved for this day';

  @override
  String feltMood(String mood) {
    return 'Felt $mood';
  }

  @override
  String get completedDaysTitle => 'Completed Days';

  @override
  String get daysDone => 'Days done';

  @override
  String get daysLeft => 'Days left';

  @override
  String get progressLabel => 'Progress';

  @override
  String get noCompletedDaysYet =>
      'No completed days yet. Finish today to start your history.';

  @override
  String get learningTimerTitle => 'Learning Timer';

  @override
  String ofDuration(String duration) {
    return 'of $duration';
  }

  @override
  String get trainingCompleteToday => 'Training complete for today!';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get timerBackgroundNote =>
      'The timer keeps running in the background even if you leave this screen.';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get nudgeSubtitle => 'Nudge me if today\'s tasks aren\'t done yet';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String get reminderNotificationTitle => '75 Days Challenge';

  @override
  String get reminderNotificationBody => 'Don\'t forget today\'s tasks!';

  @override
  String get notificationPermissionDenied =>
      'Notification permission was denied.';

  @override
  String couldNotScheduleReminder(String error) {
    return 'Could not schedule the reminder: $error';
  }

  @override
  String couldNotRescheduleReminder(String error) {
    return 'Could not reschedule the reminder: $error';
  }

  @override
  String couldNotRearmReminder(String error) {
    return 'Could not re-arm the daily reminder: $error';
  }

  @override
  String get couldNotLoadProgress =>
      'Could not load your saved progress. Starting fresh.';

  @override
  String get couldNotSaveProgress => 'Could not save your progress.';

  @override
  String couldNotCapturePhoto(String error) {
    return 'Could not capture photo: $error';
  }

  @override
  String couldNotStartRecording(String error) {
    return 'Could not start recording: $error';
  }

  @override
  String couldNotSaveRecording(String error) {
    return 'Could not save recording: $error';
  }

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePersian => 'فارسی';

  @override
  String get languageSystemDefault => 'System default';

  @override
  String get transformationTitle => 'Your Transformation';

  @override
  String get viewTransformation => 'View Transformation';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get beforeAfterTitle => 'Before / After';

  @override
  String get beforeLabel => 'Before';

  @override
  String get afterLabel => 'After';

  @override
  String get viewBeforeAfter => 'View Before / After';

  @override
  String get beforeAfterNeedsMorePhotos =>
      'Take progress photos on at least two days to see a before/after comparison.';

  @override
  String get weightCheckinTitle => 'Weight Check-in';

  @override
  String weightCheckinBody(int day) {
    return 'Day $day — time to log your weight';
  }

  @override
  String get logWeight => 'Log Weight';

  @override
  String get weightDialogHint => 'Weight (kg)';

  @override
  String get weightProgressTitle => 'Weight Progress';

  @override
  String get noWeightEntriesYet =>
      'No weight logged yet. You\'ll be checked in every 15 days.';

  @override
  String weightEntryLine(int day, String weight) {
    return 'Day $day: $weight kg';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get quote1 =>
      'Discipline is choosing what you want most over what you want now.';

  @override
  String get quote2 =>
      'You don\'t have to be great to start, but you have to start to be great.';

  @override
  String get quote3 => 'Small steps every day add up to big change.';

  @override
  String get quote4 => 'Show up for yourself today. Future you is watching.';

  @override
  String get quote5 => 'Progress, not perfection.';

  @override
  String get quote6 =>
      'The pain of discipline weighs ounces; the pain of regret weighs tons.';

  @override
  String get quote7 =>
      'You\'re not just building a habit, you\'re building who you are.';

  @override
  String get quote8 =>
      'One more day, one more brick in the wall you are building.';

  @override
  String get quote9 => 'Consistency beats intensity.';

  @override
  String get quote10 =>
      'Nobody is coming to save you. Save yourself, one day at a time.';
}
