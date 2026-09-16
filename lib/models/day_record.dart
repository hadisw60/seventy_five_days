import 'package:flutter/foundation.dart';

import 'adherence_level.dart';
import 'energy_level.dart';
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
    this.energyLevel,
    this.adherenceLevel,
    this.voiceNotePath,
  });

  final int day;
  final DateTime completedAt;
  final String? photoPath;

  /// The day's check-in: mood, energy, and adherence, plus an optional free
  /// note. Mood/energy/adherence gated the check-in task; the note itself
  /// never did.
  final String? journalText;
  final Mood? mood;
  final EnergyLevel? energyLevel;
  final AdherenceLevel? adherenceLevel;
  final String? voiceNotePath;

  Map<String, dynamic> toJson() => {
        'day': day,
        'completedAt': completedAt.toIso8601String(),
        'photoPath': photoPath,
        'journalText': journalText,
        'mood': mood?.name,
        'energyLevel': energyLevel?.name,
        'adherenceLevel': adherenceLevel?.name,
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
        energyLevel: EnergyLevel.fromName(json['energyLevel'] as String?),
        adherenceLevel: AdherenceLevel.fromName(json['adherenceLevel'] as String?),
        voiceNotePath: json['voiceNotePath'] as String?,
      );
}
