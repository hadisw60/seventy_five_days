import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import 'weight_entry_dialog.dart';

/// Prompts the user to log their weight on a check-in day (every 15 days).
class WeightCheckinCard extends StatelessWidget {
  const WeightCheckinCard({super.key, required this.controller});

  final ChallengeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.monitor_weight_rounded, color: AppTheme.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.weightCheckinTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  l10n.weightCheckinBody(controller.state.currentDay),
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => showWeightEntryDialog(context, controller),
            child: Text(l10n.logWeight),
          ),
        ],
      ),
    );
  }
}
