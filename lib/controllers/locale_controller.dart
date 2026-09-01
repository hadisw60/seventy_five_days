// The named constructor param must stay public while the backing field is
// private, so an initializing formal isn't usable here.
// ignore_for_file: prefer_initializing_formals

import 'package:flutter/material.dart';

import '../services/settings_service.dart';

/// Owns the user's chosen app language. A null [locale] means "follow the
/// system language".
class LocaleController extends ChangeNotifier {
  LocaleController({required SettingsService settingsService})
      : _settingsService = settingsService;

  final SettingsService _settingsService;

  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> load() async {
    final code = await _settingsService.loadLocaleCode();
    _locale = code == null ? null : Locale(code);
    notifyListeners();
  }

  /// Pass null to follow the system language again.
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    await _settingsService.saveLocaleCode(locale?.languageCode);
  }
}
