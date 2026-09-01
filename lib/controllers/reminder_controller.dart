// Named constructor params below must stay public while their backing
// fields are private, so initializing formals aren't usable here.
// ignore_for_file: prefer_initializing_formals

import 'package:flutter/foundation.dart';

import '../l10n/generated/app_localizations_en.dart';
import '../l10n/generated/app_localizations_fa.dart';
import '../models/reminder_settings.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';

/// Identifies what went wrong; the UI resolves this (plus
/// [ReminderController.errorDetail]) into a localized message.
enum ReminderErrorType { permissionDenied, scheduleFailed, rescheduleFailed, rearmFailed }

/// Owns the daily reminder's on/off + time-of-day state and talks to the
/// notification plugin on the UI's behalf.
class ReminderController extends ChangeNotifier {
  ReminderController({
    required SettingsService settingsService,
    required NotificationService notificationService,
  })  : _settingsService = settingsService,
        _notificationService = notificationService;

  final SettingsService _settingsService;
  final NotificationService _notificationService;

  ReminderSettings _settings = const ReminderSettings();
  ReminderErrorType? _errorType;
  String? _errorDetail;
  bool _isReady = false;

  ReminderSettings get settings => _settings;
  ReminderErrorType? get errorType => _errorType;
  String? get errorDetail => _errorDetail;
  bool get isReady => _isReady;

  /// Loads saved settings and, if a reminder was already enabled, re-arms it
  /// (scheduled alarms don't necessarily survive across app reinstalls or
  /// certain platform restarts, so this keeps it in sync on every launch).
  Future<void> initialize() async {
    await _notificationService.initialize();
    _settings = await _settingsService.loadReminderSettings();

    if (_settings.enabled) {
      try {
        final text = await _resolveReminderText();
        await _notificationService.scheduleDailyReminder(
          hour: _settings.hour,
          minute: _settings.minute,
          title: text.title,
          body: text.body,
        );
      } catch (e) {
        _errorType = ReminderErrorType.rearmFailed;
        _errorDetail = e.toString();
      }
    }

    _isReady = true;
    notifyListeners();
  }

  Future<void> setEnabled(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermission();
      if (!granted) {
        _errorType = ReminderErrorType.permissionDenied;
        notifyListeners();
        return;
      }

      try {
        final text = await _resolveReminderText();
        await _notificationService.scheduleDailyReminder(
          hour: _settings.hour,
          minute: _settings.minute,
          title: text.title,
          body: text.body,
        );
      } catch (e) {
        _errorType = ReminderErrorType.scheduleFailed;
        _errorDetail = e.toString();
        notifyListeners();
        return;
      }
    } else {
      await _notificationService.cancelDailyReminder();
    }

    _settings = _settings.copyWith(enabled: enabled);
    _errorType = null;
    notifyListeners();
    await _settingsService.saveReminderSettings(_settings);
  }

  Future<void> setTime({required int hour, required int minute}) async {
    _settings = _settings.copyWith(hour: hour, minute: minute);
    notifyListeners();
    await _settingsService.saveReminderSettings(_settings);

    if (_settings.enabled) {
      try {
        final text = await _resolveReminderText();
        await _notificationService.scheduleDailyReminder(
          hour: hour,
          minute: minute,
          title: text.title,
          body: text.body,
        );
      } catch (e) {
        _errorType = ReminderErrorType.rescheduleFailed;
        _errorDetail = e.toString();
        notifyListeners();
      }
    }
  }

  /// Called whenever the app's language changes, so an already-scheduled
  /// reminder picks up the new wording without waiting for the next toggle.
  Future<void> refreshScheduledText() async {
    if (!_settings.enabled) return;
    try {
      final text = await _resolveReminderText();
      await _notificationService.scheduleDailyReminder(
        hour: _settings.hour,
        minute: _settings.minute,
        title: text.title,
        body: text.body,
      );
    } catch (_) {
      // Non-critical: the old wording just stays until the next successful
      // reschedule.
    }
  }

  Future<({String title, String body})> _resolveReminderText() async {
    final code = await _settingsService.loadLocaleCode() ??
        PlatformDispatcher.instance.locale.languageCode;
    final l10n = code == 'fa' ? AppLocalizationsFa() : AppLocalizationsEn();
    return (title: l10n.reminderNotificationTitle, body: l10n.reminderNotificationBody);
  }
}
