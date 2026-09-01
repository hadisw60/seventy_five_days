import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/daily_task.dart';
import '../theme/app_theme.dart';

/// A real, running timer for the daily training session. The task only
/// completes once the accumulated time reaches the target — there is no way
/// to check it off directly.
class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key, required this.controller});

  final ChallengeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.learningTimerTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final elapsed = controller.trainingElapsedSeconds;
    final target = DailyTask.trainingTargetSeconds;
    final progress = (elapsed / target).clamp(0.0, 1.0);
    final isRunning = controller.isTrainingRunning;
    final isDone = elapsed >= target;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                      color: isDone ? Colors.green : AppTheme.pink,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatDuration(elapsed),
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.ofDuration(_formatDuration(target)),
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (isDone)
              Column(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    l10n.trainingCompleteToday,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: isRunning ? controller.pauseTraining : controller.startTraining,
                  icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  label: Text(isRunning ? l10n.pause : l10n.start),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              l10n.timerBackgroundNote,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final h = hours.toString().padLeft(2, '0');
    final m = minutes.toString().padLeft(2, '0');
    final s = seconds.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}
