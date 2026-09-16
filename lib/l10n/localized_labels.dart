import 'package:flutter/material.dart';

import '../models/adherence_level.dart';
import '../models/daily_task.dart';
import '../models/energy_level.dart';
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
    TaskType.gym => l10n.taskGym,
    TaskType.walking => l10n.taskWalking,
    TaskType.checkin => l10n.taskCheckin,
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

String energyLabel(BuildContext context, EnergyLevel energy) {
  final l10n = AppLocalizations.of(context)!;
  return switch (energy) {
    EnergyLevel.low => l10n.energyLow,
    EnergyLevel.medium => l10n.energyMedium,
    EnergyLevel.high => l10n.energyHigh,
  };
}

String adherenceLabel(BuildContext context, AdherenceLevel adherence) {
  final l10n = AppLocalizations.of(context)!;
  return switch (adherence) {
    AdherenceLevel.full => l10n.adherenceFull,
    AdherenceLevel.partial => l10n.adherencePartial,
    AdherenceLevel.weak => l10n.adherenceWeak,
  };
}
