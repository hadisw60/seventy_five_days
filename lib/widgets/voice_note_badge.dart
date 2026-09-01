import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';

/// Indicates a voice note was saved for the day. Playback isn't wired up
/// yet — see [RecorderVoiceService] for where the audio file lives.
class VoiceNoteBadge extends StatelessWidget {
  const VoiceNoteBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.graphic_eq_rounded, color: AppTheme.blue),
        const SizedBox(width: 8),
        Text(AppLocalizations.of(context)!.voiceNoteSaved),
      ],
    );
  }
}
