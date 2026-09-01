import 'package:flutter/foundation.dart';

/// A single weight check-in, logged roughly every 15 days.
@immutable
class WeightEntry {
  const WeightEntry({
    required this.day,
    required this.weightKg,
    required this.recordedAt,
  });

  final int day;
  final double weightKg;
  final DateTime recordedAt;

  Map<String, dynamic> toJson() => {
        'day': day,
        'weightKg': weightKg,
        'recordedAt': recordedAt.toIso8601String(),
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        day: json['day'] as int,
        weightKg: (json['weightKg'] as num).toDouble(),
        recordedAt:
            DateTime.tryParse(json['recordedAt'] as String? ?? '') ?? DateTime.now(),
      );
}
