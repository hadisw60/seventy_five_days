// Named constructor params below must stay public while their backing
// fields are private, so initializing formals aren't usable here.
// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/adherence_level.dart';
import '../models/challenge_state.dart';
import '../models/day_record.dart';
import '../models/daily_task.dart';
import '../models/energy_level.dart';
import '../models/mood.dart';
import '../models/weight_entry.dart';
import '../services/photo_service.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../services/voice_service.dart';

enum ChallengeLoadStatus { loading, ready, error }

/// Identifies what went wrong, without hardcoding any language's text.
/// The UI resolves this (plus [ChallengeController.errorDetail], when
/// present) into a localized message.
enum ChallengeErrorType {
  loadFailed,
  saveFailed,
  photoCaptureFailed,
  voiceStartFailed,
  voiceSaveFailed,
}

/// Owns [ChallengeState] and every rule for mutating it: toggling tasks,
/// capturing the daily photo, and advancing the challenge day by day.
///
/// The UI only ever reads [state] and calls these methods — it holds no
/// business logic of its own.
class ChallengeController extends ChangeNotifier {
  ChallengeController({
    required StorageService storageService,
    required PhotoService photoService,
    required VoiceService voiceService,
  })  : _storageService = storageService,
        _photoService = photoService,
        _voiceService = voiceService;

  final StorageService _storageService;
  final PhotoService _photoService;
  final VoiceService _voiceService;

  ChallengeState _state = ChallengeState.initial();
  ChallengeLoadStatus _status = ChallengeLoadStatus.loading;
  ChallengeErrorType? _errorType;
  String? _errorDetail;
  Timer? _trainingTimer;
  Timer? _journalDebounce;
  bool _isRecordingVoice = false;

  ChallengeState get state => _state;
  ChallengeLoadStatus get status => _status;
  ChallengeErrorType? get errorType => _errorType;
  String? get errorDetail => _errorDetail;

  Future<void> load() async {
    _status = ChallengeLoadStatus.loading;
    notifyListeners();

    try {
      final loaded = await _storageService.loadState();
      _state = loaded ?? ChallengeState.initial();
      _status = ChallengeLoadStatus.ready;
      _errorType = null;
    } catch (_) {
      _state = ChallengeState.initial();
      _status = ChallengeLoadStatus.error;
      _errorType = ChallengeErrorType.loadFailed;
    }
    notifyListeners();
  }

  /// Toggles a checkbox-style task. Not valid for [TaskType.photo] (see
  /// [capturePhoto]), [TaskType.training] (see [startTraining]), or
  /// [TaskType.checkin] (completed automatically once mood, energy, and
  /// adherence are all set — see [updateMood], [updateEnergy],
  /// [updateAdherence]).
  Future<void> toggleTask(TaskType type) async {
    if (type == TaskType.photo || type == TaskType.training || type == TaskType.checkin) {
      return;
    }

    final tasks = _state.todayTasks
        .map((task) => task.type == type
            ? task.copyWith(isCompleted: !task.isCompleted)
            : task)
        .toList();

    _state = _state.copyWith(todayTasks: tasks);
    notifyListeners();
    unawaited(AppSounds.tap());
    await _persist();
  }

  bool get isTrainingRunning => _trainingTimer != null;

  int get trainingElapsedSeconds => _state.taskOf(TaskType.training).elapsedSeconds;

  /// Starts (or resumes) the learning timer. Does nothing if it's already
  /// running or the training task is already complete.
  void startTraining() {
    if (_trainingTimer != null) return;
    if (_state.taskOf(TaskType.training).isCompleted) return;

    _trainingTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickTraining());
    notifyListeners();
  }

  /// Pauses the learning timer and saves the elapsed time so far.
  Future<void> pauseTraining() async {
    if (_trainingTimer == null) return;
    _trainingTimer?.cancel();
    _trainingTimer = null;
    notifyListeners();
    await _persist();
  }

  void _tickTraining() {
    final task = _state.taskOf(TaskType.training);
    final newElapsed = task.elapsedSeconds + 1;
    final reachedTarget = newElapsed >= DailyTask.trainingTargetSeconds;

    final tasks = _state.todayTasks
        .map((t) => t.type == TaskType.training
            ? t.copyWith(elapsedSeconds: newElapsed, isCompleted: reachedTarget)
            : t)
        .toList();

    _state = _state.copyWith(todayTasks: tasks);

    if (reachedTarget) {
      _trainingTimer?.cancel();
      _trainingTimer = null;
      unawaited(AppSounds.celebrate());
    }

    notifyListeners();

    if (reachedTarget || newElapsed % 10 == 0) {
      _persist();
    }
  }

  /// Launches the photo picker and marks the photo task complete on success.
  /// Returns false if the user cancelled or capture failed.
  Future<bool> capturePhoto() async {
    try {
      final path = await _photoService.pickPhotoForDay(_state.currentDay);
      if (path == null) return false;

      final tasks = _state.todayTasks
          .map((task) => task.type == TaskType.photo
              ? task.copyWith(isCompleted: true, photoPath: path)
              : task)
          .toList();

      _state = _state.copyWith(todayTasks: tasks);
      _errorType = null;
      notifyListeners();
      unawaited(AppSounds.tap());
      await _persist();
      return true;
    } catch (e) {
      _errorType = ChallengeErrorType.photoCaptureFailed;
      _errorDetail = e is UnsupportedError ? e.message : e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Sets today's mood, one third of the daily check-in (with
  /// [updateEnergy] and [updateAdherence]); the check-in task completes once
  /// all three are set.
  Future<void> updateMood(Mood mood) async {
    _state = _state.copyWith(mood: mood);
    _syncCheckinTask();
    notifyListeners();
    unawaited(AppSounds.tap());
    await _persist();
  }

  /// Sets today's energy level, one third of the daily check-in.
  Future<void> updateEnergy(EnergyLevel energy) async {
    _state = _state.copyWith(energyLevel: energy);
    _syncCheckinTask();
    notifyListeners();
    unawaited(AppSounds.tap());
    await _persist();
  }

  /// Sets today's adherence rating, one third of the daily check-in.
  Future<void> updateAdherence(AdherenceLevel adherence) async {
    _state = _state.copyWith(adherenceLevel: adherence);
    _syncCheckinTask();
    notifyListeners();
    unawaited(AppSounds.tap());
    await _persist();
  }

  /// Marks [TaskType.checkin] complete once mood, energy, and adherence are
  /// all set for today.
  void _syncCheckinTask() {
    final isComplete =
        _state.mood != null && _state.energyLevel != null && _state.adherenceLevel != null;
    final tasks = _state.todayTasks
        .map((task) =>
            task.type == TaskType.checkin ? task.copyWith(isCompleted: isComplete) : task)
        .toList();
    _state = _state.copyWith(todayTasks: tasks);
  }

  /// Updates today's journal text as the user types. Persisted with a short
  /// debounce so every keystroke doesn't hit disk.
  void updateJournalText(String text) {
    _state = _state.copyWith(journalText: text);
    notifyListeners();
    _journalDebounce?.cancel();
    _journalDebounce = Timer(const Duration(milliseconds: 600), () => _persist());
  }

  bool get isRecordingVoice => _isRecordingVoice;

  Future<void> startVoiceRecording() async {
    try {
      await _voiceService.startRecording();
      _isRecordingVoice = true;
      _errorType = null;
      notifyListeners();
    } catch (e) {
      _isRecordingVoice = false;
      _errorType = ChallengeErrorType.voiceStartFailed;
      _errorDetail = e is StateError ? e.message : e.toString();
      notifyListeners();
    }
  }

  Future<void> stopVoiceRecording() async {
    if (!_isRecordingVoice) return;
    try {
      final path = await _voiceService.stopRecording();
      _isRecordingVoice = false;
      if (path != null) {
        _state = _state.copyWith(voiceNotePath: path);
      }
      notifyListeners();
      await _persist();
    } catch (e) {
      _isRecordingVoice = false;
      _errorType = ChallengeErrorType.voiceSaveFailed;
      _errorDetail = e.toString();
      notifyListeners();
    }
  }

  /// Logs (or replaces) the weight check-in for the current day.
  Future<void> logWeight(double weightKg) async {
    final entries = [
      ..._state.weightEntries.where((entry) => entry.day != _state.currentDay),
      WeightEntry(day: _state.currentDay, weightKg: weightKg, recordedAt: DateTime.now()),
    ]..sort((a, b) => a.day.compareTo(b.day));

    _state = _state.copyWith(weightEntries: entries);
    notifyListeners();
    unawaited(AppSounds.tap());
    await _persist();
  }

  /// Attempts to finish the current day. Returns false without changing
  /// state if required tasks remain incomplete.
  Future<bool> completeDay() async {
    if (!_state.allRequiredTasksCompleted) return false;

    _trainingTimer?.cancel();
    _trainingTimer = null;
    _journalDebounce?.cancel();
    _journalDebounce = null;

    final photoPath = _state.taskOf(TaskType.photo).photoPath;
    final updatedHistory = [
      ..._state.completedDays,
      DayRecord(
        day: _state.currentDay,
        completedAt: DateTime.now(),
        photoPath: photoPath,
        journalText: _state.journalText.isEmpty ? null : _state.journalText,
        mood: _state.mood,
        energyLevel: _state.energyLevel,
        adherenceLevel: _state.adherenceLevel,
        voiceNotePath: _state.voiceNotePath,
      ),
    ];

    if (_state.currentDay >= ChallengeState.totalDays) {
      _state = _state.copyWith(
        completedDays: updatedHistory,
        isChallengeCompleted: true,
      );
    } else {
      _state = _state.copyWith(
        currentDay: _state.currentDay + 1,
        todayTasks: DailyTask.templateForDate(DateTime.now()),
        completedDays: updatedHistory,
        journalText: '',
        clearMood: true,
        clearEnergyLevel: true,
        clearAdherenceLevel: true,
        clearVoiceNotePath: true,
      );
    }

    notifyListeners();
    unawaited(AppSounds.celebrate());
    await _persist();
    return true;
  }

  Future<void> _persist() async {
    try {
      await _storageService.saveState(_state);
    } catch (_) {
      _errorType = ChallengeErrorType.saveFailed;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _trainingTimer?.cancel();
    _journalDebounce?.cancel();
    super.dispose();
  }
}
