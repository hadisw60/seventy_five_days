import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/challenge_state.dart';

/// Persists and restores [ChallengeState].
///
/// Kept as an abstraction so the underlying storage (currently
/// `shared_preferences`) can later be swapped for SQLite/Isar/Hive without
/// touching the controller or UI layers.
abstract class StorageService {
  Future<ChallengeState?> loadState();
  Future<void> saveState(ChallengeState state);
}

class SharedPreferencesStorageService implements StorageService {
  static const String _stateKey = 'challenge_state_v1';

  @override
  Future<ChallengeState?> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_stateKey);
    if (raw == null) return null;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ChallengeState.fromJson(json);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> saveState(ChallengeState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stateKey, jsonEncode(state.toJson()));
  }
}
