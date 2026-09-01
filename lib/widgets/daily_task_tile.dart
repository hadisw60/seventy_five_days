import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../l10n/localized_labels.dart';
import '../models/daily_task.dart';
import '../theme/app_theme.dart';

/// A single task row. Checkbox tasks toggle on tap; the photo task launches
/// photo capture via [onCapturePhoto]; the training task opens the learning
/// timer via [onOpenTimer]. Neither photo nor training can be checked off
/// directly.
class DailyTaskTile extends StatelessWidget {
  const DailyTaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    this.onCapturePhoto,
    this.onOpenTimer,
  });

  final DailyTask task;
  final VoidCallback onToggle;
  final VoidCallback? onCapturePhoto;
  final VoidCallback? onOpenTimer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final completed = task.isCompleted;
    final isPhotoTask = task.isPhotoTask;
    final isTrainingTask = task.isTrainingTask;

    final VoidCallback? onTap =
        isPhotoTask ? onCapturePhoto : (isTrainingTask ? onOpenTimer : onToggle);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
              completed ? Colors.green.shade100 : AppTheme.pink.withValues(alpha: 0.12),
          child: Icon(
            completed ? Icons.check_rounded : task.icon,
            color: completed ? Colors.green.shade700 : AppTheme.pink,
          ),
        ),
        title: Text(
          taskTitle(context, task.type),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          _subtitle(l10n, completed, isPhotoTask, isTrainingTask),
          style: TextStyle(color: Colors.red.shade300, fontSize: 12),
        ),
        trailing: _trailing(completed, isPhotoTask, isTrainingTask),
      ),
    );
  }

  String _subtitle(AppLocalizations l10n, bool completed, bool isPhotoTask, bool isTrainingTask) {
    if (!task.isRequired) return '';
    if (completed) return l10n.requiredLabel;
    if (isPhotoTask) return l10n.requiredTapPhoto;
    if (isTrainingTask) return l10n.requiredTapTimer;
    return l10n.requiredLabel;
  }

  Widget _trailing(bool completed, bool isPhotoTask, bool isTrainingTask) {
    if (isPhotoTask) {
      return Icon(
        completed ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
        color: completed ? Colors.green.shade700 : AppTheme.blue,
      );
    }
    if (isTrainingTask) {
      if (completed) {
        return Icon(Icons.check_circle_rounded, color: Colors.green.shade700);
      }
      final progress = (task.elapsedSeconds / DailyTask.trainingTargetSeconds).clamp(0.0, 1.0);
      return SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 3,
          backgroundColor: Colors.grey.shade200,
          color: AppTheme.blue,
        ),
      );
    }
    return Checkbox(value: completed, onChanged: (_) => onToggle());
  }
}
