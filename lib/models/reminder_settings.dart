import 'package:flutter/foundation.dart';

/// Whether and when the app should nudge the user about today's tasks.
@immutable
class ReminderSettings {
  const ReminderSettings({
    this.enabled = false,
    this.hour = 20,
    this.minute = 0,
  });

  final bool enabled;
  final int hour;
  final int minute;

  ReminderSettings copyWith({bool? enabled, int? hour, int? minute}) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'hour': hour,
        'minute': minute,
      };

  factory ReminderSettings.fromJson(Map<String, dynamic> json) => ReminderSettings(
        enabled: json['enabled'] as bool? ?? false,
        hour: json['hour'] as int? ?? 20,
        minute: json['minute'] as int? ?? 0,
      );
}
