import 'package:flutter/material.dart';

/// The kind of task a user must complete each day of the challenge.
///
/// Display titles are localized; see `lib/l10n/localized_labels.dart`.
enum TaskType { reading, training, prayer, photo, gym, walking, checkin }

/// Gym days are Saturday, Monday, and Wednesday — every other day is a
/// recovery day and gym/walking aren't required.
bool isGymDay(DateTime date) =>
    date.weekday == DateTime.saturday ||
    date.weekday == DateTime.monday ||
    date.weekday == DateTime.wednesday;

/// A single task for the current day, together with its completion state.
///
/// Instances are immutable; use [copyWith] to derive a new state instead of
/// mutating fields directly. Moving to a new day rebuilds the whole list via
/// [templateForDate] rather than resetting each task in place, since
/// gym/walking's required state depends on that day's weekday.
@immutable
class DailyTask {
  const DailyTask({
    required this.type,
    required this.icon,
    this.isRequired = true,
    this.isCompleted = false,
    this.photoPath,
    this.elapsedSeconds = 0,
  });

  /// How long the training timer must run before the task auto-completes.
  static const int trainingTargetSeconds = 2 * 60 * 60;

  final TaskType type;
  final IconData icon;
  final bool isRequired;
  final bool isCompleted;

  /// Local file path of the photo taken for this task. Only ever set for
  /// [TaskType.photo].
  final String? photoPath;

  /// Seconds accumulated on the learning timer. Only ever set for
  /// [TaskType.training].
  final int elapsedSeconds;

  bool get isPhotoTask => type == TaskType.photo;
  bool get isTrainingTask => type == TaskType.training;

  DailyTask copyWith({bool? isCompleted, String? photoPath, int? elapsedSeconds}) {
    return DailyTask(
      type: type,
      icon: icon,
      isRequired: isRequired,
      isCompleted: isCompleted ?? this.isCompleted,
      photoPath: photoPath ?? this.photoPath,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'isCompleted': isCompleted,
        'photoPath': photoPath,
        'elapsedSeconds': elapsedSeconds,
      };

  DailyTask mergeSavedState(Map<String, dynamic>? json) {
    if (json == null) return this;
    return copyWith(
      isCompleted: json['isCompleted'] as bool? ?? false,
      photoPath: json['photoPath'] as String?,
      elapsedSeconds: json['elapsedSeconds'] as int? ?? 0,
    );
  }

  /// The day's tasks, in display order. Gym and walking are only required
  /// on gym days (Saturday/Monday/Wednesday) — on other days they're still
  /// shown, but optional, so the day isn't blocked on a rest day.
  static List<DailyTask> templateForDate(DateTime date) {
    final gymDay = isGymDay(date);
    return [
      const DailyTask(type: TaskType.reading, icon: Icons.menu_book_rounded),
      const DailyTask(type: TaskType.training, icon: Icons.code_rounded),
      const DailyTask(type: TaskType.prayer, icon: Icons.favorite_rounded),
      const DailyTask(type: TaskType.photo, icon: Icons.camera_alt_rounded),
      DailyTask(
        type: TaskType.gym,
        icon: Icons.fitness_center_rounded,
        isRequired: gymDay,
      ),
      DailyTask(
        type: TaskType.walking,
        icon: Icons.directions_walk_rounded,
        isRequired: gymDay,
      ),
      const DailyTask(type: TaskType.checkin, icon: Icons.edit_note_rounded),
    ];
  }
}
