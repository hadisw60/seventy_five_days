import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/weight_entry.dart';
import '../theme/app_theme.dart';

class WeightEntryTile extends StatelessWidget {
  const WeightEntryTile({super.key, required this.entry, this.previousWeightKg});

  final WeightEntry entry;

  /// The prior check-in's weight, used to show a trend arrow. Null for the
  /// very first entry.
  final double? previousWeightKg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    IconData? trendIcon;
    Color trendColor = Colors.grey;
    if (previousWeightKg != null) {
      if (entry.weightKg < previousWeightKg!) {
        trendIcon = Icons.trending_down_rounded;
        trendColor = Colors.green;
      } else if (entry.weightKg > previousWeightKg!) {
        trendIcon = Icons.trending_up_rounded;
        trendColor = Colors.orange;
      } else {
        trendIcon = Icons.trending_flat_rounded;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.blue.withValues(alpha: 0.12),
          child: const Icon(Icons.monitor_weight_rounded, color: AppTheme.blue),
        ),
        title: Text(l10n.weightEntryLine(entry.day, entry.weightKg.toStringAsFixed(1))),
        trailing: trendIcon != null ? Icon(trendIcon, color: trendColor) : null,
      ),
    );
  }
}
