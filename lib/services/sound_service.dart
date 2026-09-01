import 'package:flutter/services.dart';

/// Thin wrapper around Flutter's built-in system sound API. Deliberately not
/// backed by a custom audio plugin — these are just short OS-level UI
/// sounds, and every platform already supports them with zero extra
/// dependencies or native build steps.
class AppSounds {
  AppSounds._();

  /// A light tick for a small, immediate action (checking off a task,
  /// capturing a photo, picking a mood).
  static Future<void> tap() => SystemSound.play(SystemSoundType.click);

  /// A more attention-grabbing sound for a bigger milestone (finishing the
  /// training timer, completing a day, finishing the whole challenge).
  static Future<void> celebrate() => SystemSound.play(SystemSoundType.alert);
}
