import 'package:flutter/foundation.dart';

import 'day_record.dart';
import 'daily_task.dart';
import 'mood.dart';
import 'weight_entry.dart';

/// The full state of the 75 day challenge: which day the user is on, the
/// status of today's tasks, and the history of completed days.
@immutable
class ChallengeState {
  const ChallengeState({
    required this.currentDay,
    required this.todayTasks,
    this.completedDays = const [],
    this.isChallengeCompleted = false,
    this.journalText = '',
    this.mood,
    this.voiceNotePath,
    this.weightEntries = const [],
  });

  static const int totalDays = 75;
  static const int weightCheckInIntervalDays = 15;

  final int currentDay;
  final List<DailyTask> todayTasks;
  final List<DayRecord> completedDays;
  final bool isChallengeCompleted;

  /// Today's optional journal note, mood, and voice memo. None of these
  /// gate day completion — they're purely reflective extras.
  final String journalText;
  final Mood? mood;
  final String? voiceNotePath;

  /// Weight check-ins, logged roughly every [weightCheckInIntervalDays] days.
  final List<WeightEntry> weightEntries;

  factory ChallengeState.initial() => const ChallengeState(
        currentDay: 1,
        todayTasks: DailyTask.template,
      );

  bool get allRequiredTasksCompleted =>
      todayTasks.where((task) => task.isRequired).every((task) => task.isCompleted);

  List<DailyTask> get incompleteRequiredTasks =>
      todayTasks.where((task) => task.isRequired && !task.isCompleted).toList();

  /// Overall challenge progress, from 0.0 to 1.0.
  double get progress => completedDays.length / totalDays;

  DailyTask taskOf(TaskType type) =>
      todayTasks.firstWhere((task) => task.type == type);

  /// Whether today is a weight check-in day (every 15th day) that hasn't
  /// been logged yet.
  bool get isWeightCheckInDueToday =>
      currentDay % weightCheckInIntervalDays == 0 &&
      !weightEntries.any((entry) => entry.day == currentDay);

  ChallengeState copyWith({
    int? currentDay,
    List<DailyTask>? todayTasks,
    List<DayRecord>? completedDays,
    bool? isChallengeCompleted,
    String? journalText,
    Mood? mood,
    bool clearMood = false,
    String? voiceNotePath,
    bool clearVoiceNotePath = false,
    List<WeightEntry>? weightEntries,
  }) {
    return ChallengeState(
      currentDay: currentDay ?? this.currentDay,
      todayTasks: todayTasks ?? this.todayTasks,
      completedDays: completedDays ?? this.completedDays,
      isChallengeCompleted: isChallengeCompleted ?? this.isChallengeCompleted,
      journalText: journalText ?? this.journalText,
      mood: clearMood ? null : (mood ?? this.mood),
      voiceNotePath: clearVoiceNotePath ? null : (voiceNotePath ?? this.voiceNotePath),
      weightEntries: weightEntries ?? this.weightEntries,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentDay': currentDay,
        'isChallengeCompleted': isChallengeCompleted,
        'completedDays': completedDays.map((record) => record.toJson()).toList(),
        'todayTasks': {
          for (final task in todayTasks) task.type.name: task.toJson(),
        },
        'journalText': journalText,
        'mood': mood?.name,
        'voiceNotePath': voiceNotePath,
        'weightEntries': weightEntries.map((entry) => entry.toJson()).toList(),
      };

  factory ChallengeState.fromJson(Map<String, dynamic> json) {
    final savedTasks = (json['todayTasks'] as Map?)?.cast<String, dynamic>();

    final tasks = DailyTask.template.map((task) {
      final saved = savedTasks?[task.type.name] as Map?;
      return task.mergeSavedState(saved?.cast<String, dynamic>());
    }).toList();

    final completedDays = (json['completedDays'] as List? ?? const [])
        .map((entry) => DayRecord.fromJson((entry as Map).cast<String, dynamic>()))
        .toList();

    final weightEntries = (json['weightEntries'] as List? ?? const [])
        .map((entry) => WeightEntry.fromJson((entry as Map).cast<String, dynamic>()))
        .toList();

    return ChallengeState(
      currentDay: json['currentDay'] as int? ?? 1,
      todayTasks: tasks,
      completedDays: completedDays,
      isChallengeCompleted: json['isChallengeCompleted'] as bool? ?? false,
      journalText: json['journalText'] as String? ?? '',
      mood: Mood.fromName(json['mood'] as String?),
      voiceNotePath: json['voiceNotePath'] as String?,
      weightEntries: weightEntries,
    );
  }
}
