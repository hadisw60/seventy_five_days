import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';

/// Shows a small dialog for entering a weight (in kg) and logs it against
/// the current day if the user confirms.
Future<void> showWeightEntryDialog(BuildContext context, ChallengeController controller) async {
  final l10n = AppLocalizations.of(context)!;
  final textController = TextEditingController();

  final result = await showDialog<double>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.logWeight),
        content: TextField(
          controller: textController,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(hintText: l10n.weightDialogHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(textController.text.trim().replaceAll(',', '.'));
              Navigator.of(dialogContext).pop(value);
            },
            child: Text(l10n.save),
          ),
        ],
      );
    },
  );

  textController.dispose();

  if (result != null && result > 0) {
    await controller.logWeight(result);
  }
}
