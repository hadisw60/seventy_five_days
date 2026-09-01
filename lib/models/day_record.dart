import 'package:flutter/foundation.dart';

import 'mood.dart';

/// A permanent record of a day the user finished, kept after the daily task
/// state has moved on. This is what later powers the progress history,
/// before/after comparisons, and the final 75-day recap.
@immutable
class DayRecord {
  const DayRecord({
    required this.day,
    required this.completedAt,
    this.photoPath,
    this.journalText,
    this.mood,
    this.voiceNotePath,
  });

  final int day;
  final DateTime completedAt;
  final String? photoPath;

  /// Optional journal note and mood captured for this day. Neither ever
  /// gated day completion.
  final String? journalText;
  final Mood? mood;
  final String? voiceNotePath;

  Map<String, dynamic> toJson() => {
        'day': day,
        'completedAt': completedAt.toIso8601String(),
        'photoPath': photoPath,
        'journalText': journalText,
        'mood': mood?.name,
        'voiceNotePath': voiceNotePath,
      };

  factory DayRecord.fromJson(Map<String, dynamic> json) => DayRecord(
        day: json['day'] as int,
        completedAt:
            DateTime.tryParse(json['completedAt'] as String? ?? '') ??
                DateTime.now(),
        photoPath: json['photoPath'] as String?,
        journalText: json['journalText'] as String?,
        mood: Mood.fromName(json['mood'] as String?),
        voiceNotePath: json['voiceNotePath'] as String?,
      );
}
