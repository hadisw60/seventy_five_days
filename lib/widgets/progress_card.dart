import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

/// The hero card showing the current day and overall challenge progress.
class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.currentDay,
    required this.totalDays,
    required this.progress,
  });

  final int currentDay;
  final int totalDays;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.pink, AppTheme.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourChallenge,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.dayOfTotal(currentDay, totalDays),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white30,
              color: Colors.white,
              minHeight: 9,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.percentCompleted((progress * 100).clamp(0, 100).toStringAsFixed(1)),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
