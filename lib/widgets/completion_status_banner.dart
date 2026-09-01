import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// Explains, in plain language, whether the day can be completed yet and
/// what's still missing if not.
class CompletionStatusBanner extends StatelessWidget {
  const CompletionStatusBanner({super.key, required this.incompleteMessage});

  /// Null when every required task is done.
  final String? incompleteMessage;

  @override
  Widget build(BuildContext context) {
    final isComplete = incompleteMessage == null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isComplete ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isComplete ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            color: isComplete ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              incompleteMessage ?? AppLocalizations.of(context)!.allTasksCompleted,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
