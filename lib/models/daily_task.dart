import 'package:flutter/material.dart';

/// The kind of task a user must complete each day of the challenge.
///
/// Display titles are localized; see `lib/l10n/localized_labels.dart`.
enum TaskType { reading, training, prayer, photo }

/// A single task for the current day, together with its completion state.
///
/// Instances are immutable; use [copyWith] or [resetForNewDay] to derive a
/// new state instead of mutating fields directly.
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

  /// Returns a fresh, uncompleted copy of this task for a new day.
  DailyTask resetForNewDay() {
    return DailyTask(
      type: type,
      icon: icon,
      isRequired: isRequired,
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

  /// The four tasks required to complete a day, in display order.
  static const List<DailyTask> template = [
    DailyTask(type: TaskType.reading, icon: Icons.menu_book_rounded),
    DailyTask(type: TaskType.training, icon: Icons.fitness_center_rounded),
    DailyTask(type: TaskType.prayer, icon: Icons.favorite_rounded),
    DailyTask(type: TaskType.photo, icon: Icons.camera_alt_rounded),
  ];
}
