import 'package:flutter/material.dart';

import '../controllers/reminder_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key, required this.controller});

  final ReminderController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.remindersTitle,
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
    final settings = controller.settings;
    final timeLabel = _formatTime(context, settings.hour, settings.minute);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (controller.errorType != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              _resolveError(l10n, controller.errorType!, controller.errorDetail),
              style: TextStyle(color: Colors.red.shade700),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.dailyReminder, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(l10n.nudgeSubtitle),
                value: settings.enabled,
                activeThumbColor: AppTheme.pink,
                onChanged: controller.isReady ? controller.setEnabled : null,
              ),
              if (settings.enabled) ...[
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.access_time_rounded, color: AppTheme.blue),
                  title: Text(l10n.reminderTime),
                  trailing: Text(
                    timeLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onTap: () => _pickTime(context, settings.hour, settings.minute),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _resolveError(AppLocalizations l10n, ReminderErrorType type, String? detail) {
    return switch (type) {
      ReminderErrorType.permissionDenied => l10n.notificationPermissionDenied,
      ReminderErrorType.scheduleFailed => l10n.couldNotScheduleReminder(detail ?? ''),
      ReminderErrorType.rescheduleFailed => l10n.couldNotRescheduleReminder(detail ?? ''),
      ReminderErrorType.rearmFailed => l10n.couldNotRearmReminder(detail ?? ''),
    };
  }

  Future<void> _pickTime(BuildContext context, int hour, int minute) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
    );
    if (picked != null) {
      await controller.setTime(hour: picked.hour, minute: picked.minute);
    }
  }

  String _formatTime(BuildContext context, int hour, int minute) {
    return TimeOfDay(hour: hour, minute: minute).format(context);
  }
}
