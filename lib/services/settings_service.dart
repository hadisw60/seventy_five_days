import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/reminder_settings.dart';

/// Persists app-wide preferences that aren't part of the challenge's daily
/// progress, such as reminder settings and the chosen app language.
abstract class SettingsService {
  Future<ReminderSettings> loadReminderSettings();
  Future<void> saveReminderSettings(ReminderSettings settings);

  /// Null means "follow the system language".
  Future<String?> loadLocaleCode();
  Future<void> saveLocaleCode(String? code);
}

class SharedPreferencesSettingsService implements SettingsService {
  static const String _reminderKey = 'reminder_settings_v1';
  static const String _localeKey = 'locale_code_v1';

  @override
  Future<ReminderSettings> loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_reminderKey);
    if (raw == null) return const ReminderSettings();

    try {
      return ReminderSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return const ReminderSettings();
    }
  }

  @override
  Future<void> saveReminderSettings(ReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reminderKey, jsonEncode(settings.toJson()));
  }

  @override
  Future<String?> loadLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey);
  }

  @override
  Future<void> saveLocaleCode(String? code) async {
    final prefs = await SharedPreferences.getInstance();
    if (code == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, code);
    }
  }
}
