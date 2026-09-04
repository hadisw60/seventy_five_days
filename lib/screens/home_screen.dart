import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/reminder_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/localized_labels.dart';
import '../models/challenge_state.dart';
import '../models/daily_task.dart';
import '../theme/app_theme.dart';
import '../widgets/celebration_overlay.dart';
import '../widgets/challenge_completed_card.dart';
import '../widgets/completion_status_banner.dart';
import '../widgets/daily_check_in_card.dart';
import '../widgets/daily_task_tile.dart';
import '../widgets/language_picker_button.dart';
import '../widgets/progress_card.dart';
import '../widgets/weight_checkin_card.dart';
import 'calendar_screen.dart';
import 'day75_celebration_screen.dart';
import 'notification_settings_screen.dart';
import 'progress_screen.dart';
import 'timer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.reminderController,
    required this.localeController,
  });

  final ChallengeController controller;
  final ReminderController reminderController;
  final LocaleController localeController;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void initState() {
    super.initState();
    widget.controller.load();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String? _incompleteTasksMessage(BuildContext context) {
    final missing = widget.controller.state.incompleteRequiredTasks;
    if (missing.isEmpty) return null;
    final l10n = AppLocalizations.of(context)!;
    final titles = missing.map((task) => taskTitle(context, task.type)).join(', ');
    return l10n.completeTheseFirst(titles);
  }

  Future<void> _handleCompleteDay() async {
    final controller = widget.controller;
    final l10n = AppLocalizations.of(context)!;
    final missing = _incompleteTasksMessage(context);
    if (missing != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(missing)));
      return;
    }

    final wasLastDay = controller.state.currentDay >= ChallengeState.totalDays;
    final succeeded = await controller.completeDay();
    if (!succeeded || !mounted) return;

    if (wasLastDay) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => Day75CelebrationScreen(controller: controller)),
      );
      return;
    }

    _confettiController.play();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(l10n.dayStartedSnackbar(controller.state.currentDay))),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          LanguagePickerButton(localeController: widget.localeController),
          IconButton(
            tooltip: l10n.remindersTooltip,
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NotificationSettingsScreen(controller: widget.reminderController),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.calendarTooltip,
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CalendarScreen(controller: widget.controller),
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.progressTooltip,
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProgressScreen(controller: widget.controller),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) => _buildBody(context),
            ),
          ),
          CelebrationOverlay(controller: _confettiController),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final controller = widget.controller;

    switch (controller.status) {
      case ChallengeLoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case ChallengeLoadStatus.error:
      case ChallengeLoadStatus.ready:
        return _buildContent(context);
    }
  }

  Widget _buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = widget.controller;
    final state = controller.state;
    final maxWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = maxWidth > 700 ? (maxWidth - 700) / 2 + 20 : 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.errorType != null) ...[
                _ErrorBanner(message: _resolveError(context, controller.errorType!, controller.errorDetail)),
                const SizedBox(height: 16),
              ],
              ProgressCard(
                currentDay: state.currentDay,
                totalDays: ChallengeState.totalDays,
                progress: state.progress,
              ),
              const SizedBox(height: 28),
              if (state.isChallengeCompleted)
                const ChallengeCompletedCard()
              else ...[
                if (state.isWeightCheckInDueToday) ...[
                  WeightCheckinCard(controller: controller),
                  const SizedBox(height: 20),
                ],
                Text(
                  l10n.todaysTasks,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                for (final task in state.todayTasks)
                  if (task.type != TaskType.checkin)
                    DailyTaskTile(
                      task: task,
                      onToggle: () => controller.toggleTask(task.type),
                      onCapturePhoto:
                          task.type == TaskType.photo ? controller.capturePhoto : null,
                      onOpenTimer: task.type == TaskType.training
                          ? () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TimerScreen(controller: controller),
                                ),
                              )
                          : null,
                    ),
                const SizedBox(height: 12),
                DailyCheckInCard(controller: controller),
                const SizedBox(height: 20),
                CompletionStatusBanner(incompleteMessage: _incompleteTasksMessage(context)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleCompleteDay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          state.allRequiredTasksCompleted ? AppTheme.pink : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      state.currentDay == ChallengeState.totalDays
                          ? l10n.finishChallenge
                          : l10n.completeDay,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _resolveError(BuildContext context, ChallengeErrorType type, String? detail) {
    final l10n = AppLocalizations.of(context)!;
    return switch (type) {
      ChallengeErrorType.loadFailed => l10n.couldNotLoadProgress,
      ChallengeErrorType.saveFailed => l10n.couldNotSaveProgress,
      ChallengeErrorType.photoCaptureFailed => l10n.couldNotCapturePhoto(detail ?? ''),
      ChallengeErrorType.voiceStartFailed => l10n.couldNotStartRecording(detail ?? ''),
      ChallengeErrorType.voiceSaveFailed => l10n.couldNotSaveRecording(detail ?? ''),
    };
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red.shade400),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: TextStyle(color: Colors.red.shade700))),
        ],
      ),
    );
  }
}
