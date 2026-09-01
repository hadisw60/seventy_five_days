import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/day_record.dart';
import '../theme/app_theme.dart';

class DayHistoryTile extends StatelessWidget {
  const DayHistoryTile({super.key, required this.record});

  final DayRecord record;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = record.photoPath != null && File(record.photoPath!).existsSync();

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.pink.withValues(alpha: 0.12),
          backgroundImage: hasPhoto ? FileImage(File(record.photoPath!)) : null,
          child: hasPhoto
              ? null
              : Icon(Icons.check_rounded, color: AppTheme.pink.withValues(alpha: 0.9)),
        ),
        title: Text(
          AppLocalizations.of(context)!.dayNumber(record.day),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(_formatDate(record.completedAt)),
        trailing: const Icon(Icons.check_circle_rounded, color: Colors.green),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
