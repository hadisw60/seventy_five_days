import 'package:flutter/material.dart';

import '../models/daily_task.dart';
import '../models/mood.dart';
import 'generated/app_localizations.dart';

/// Central place mapping model enums to their localized display text, so
/// the models themselves stay free of any specific language's strings.
String taskTitle(BuildContext context, TaskType type) {
  final l10n = AppLocalizations.of(context)!;
  return switch (type) {
    TaskType.reading => l10n.taskReading,
    TaskType.training => l10n.taskTraining,
    TaskType.prayer => l10n.taskPrayer,
    TaskType.photo => l10n.taskPhoto,
  };
}

String moodLabel(BuildContext context, Mood mood) {
  final l10n = AppLocalizations.of(context)!;
  return switch (mood) {
    Mood.great => l10n.moodGreat,
    Mood.good => l10n.moodGood,
    Mood.okay => l10n.moodOkay,
    Mood.bad => l10n.moodBad,
    Mood.terrible => l10n.moodTerrible,
  };
}
