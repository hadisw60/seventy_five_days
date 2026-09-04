import 'dart:io';

import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/localized_labels.dart';
import '../models/challenge_state.dart';
import '../models/day_record.dart';
import '../theme/app_theme.dart';
import '../widgets/voice_note_badge.dart';

enum _DayStatus { completed, current, locked }

/// A 75-cell grid of the whole challenge. Completed days are tappable and
/// show their date and progress photo; the current day is highlighted;
/// everything after it is locked.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key, required this.controller});

  final ChallengeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.calendarTooltip,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => _buildGrid(context),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final state = controller.state;
    final maxWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = maxWidth > 700 ? (maxWidth - 700) / 2 + 20 : 20.0;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 30),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 68,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: ChallengeState.totalDays,
      itemBuilder: (context, index) {
        final day = index + 1;
        final record = _recordFor(state, day);
        final status = _statusFor(day, state);
        return _CalendarDayCell(
          day: day,
          status: status,
          onTap: status == _DayStatus.completed ? () => _showDayDetails(context, record!) : null,
        );
      },
    );
  }

  DayRecord? _recordFor(ChallengeState state, int day) {
    for (final record in state.completedDays) {
      if (record.day == day) return record;
    }
    return null;
  }

  _DayStatus _statusFor(int day, ChallengeState state) {
    if (_recordFor(state, day) != null) return _DayStatus.completed;
    if (day == state.currentDay) return _DayStatus.current;
    return _DayStatus.locked;
  }

  void _showDayDetails(BuildContext context, DayRecord record) {
    final hasPhoto = record.photoPath != null && File(record.photoPath!).existsSync();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final sheetL10n = AppLocalizations.of(sheetContext)!;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sheetL10n.dayNumber(record.day),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                _formatDate(record.completedAt),
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              if (hasPhoto)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(File(record.photoPath!), fit: BoxFit.cover),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.image_not_supported_outlined, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(sheetL10n.noPhotoForDay, style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              if (record.mood != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(record.mood!.icon, color: record.mood!.color),
                    const SizedBox(width: 8),
                    Text(sheetL10n.feltMood(moodLabel(sheetContext, record.mood!).toLowerCase())),
                  ],
                ),
              ],
              if (record.energyLevel != null || record.adherenceLevel != null) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 4,
                  children: [
                    if (record.energyLevel != null)
                      _DetailChip(
                        icon: record.energyLevel!.icon,
                        label:
                            '${sheetL10n.energyTitle}: ${energyLabel(sheetContext, record.energyLevel!)}',
                      ),
                    if (record.adherenceLevel != null)
                      _DetailChip(
                        icon: record.adherenceLevel!.icon,
                        label:
                            '${sheetL10n.adherenceShortLabel}: ${adherenceLabel(sheetContext, record.adherenceLevel!)}',
                      ),
                  ],
                ),
              ],
              if (record.journalText != null && record.journalText!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(record.journalText!),
                ),
              ],
              if (record.voiceNotePath != null && File(record.voiceNotePath!).existsSync()) ...[
                const SizedBox(height: 12),
                const VoiceNoteBadge(),
              ],
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({required this.day, required this.status, this.onTap});

  final int day;
  final _DayStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color foreground;
    final Border? border;

    switch (status) {
      case _DayStatus.completed:
        background = Colors.green.shade50;
        foreground = Colors.green.shade700;
        border = Border.all(color: Colors.green.shade200);
      case _DayStatus.current:
        background = Colors.white;
        foreground = AppTheme.pink;
        border = Border.all(color: AppTheme.pink, width: 2);
      case _DayStatus.locked:
        background = Colors.grey.shade100;
        foreground = Colors.grey.shade400;
        border = null;
    }

    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: border?.top ?? BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Center(
          child: status == _DayStatus.completed
              ? Icon(Icons.check_rounded, color: foreground)
              : Text(
                  '$day',
                  style: TextStyle(color: foreground, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}

/// A small labeled pill used to show the energy/adherence rating logged for
/// a completed day.
class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
