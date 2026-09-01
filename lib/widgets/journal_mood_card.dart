import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/localized_labels.dart';
import '../models/mood.dart';
import '../theme/app_theme.dart';
import 'voice_note_badge.dart';

/// Optional daily reflection: mood, a free-text journal note, and a voice
/// memo. None of these gate `Complete Day` — they're purely reflective.
///
/// Owns its own [TextEditingController] so that rebuilds triggered
/// elsewhere in the app (e.g. the training timer ticking every second)
/// never reset the user's cursor position mid-typing.
class JournalMoodCard extends StatefulWidget {
  const JournalMoodCard({super.key, required this.controller});

  final ChallengeController controller;

  @override
  State<JournalMoodCard> createState() => _JournalMoodCardState();
}

class _JournalMoodCardState extends State<JournalMoodCard> {
  late final TextEditingController _journalTextController =
      TextEditingController(text: widget.controller.state.journalText);

  @override
  void dispose() {
    _journalTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = widget.controller;
    final state = controller.state;
    final voiceNotePath = state.voiceNotePath;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.howWasToday,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final mood in Mood.values)
                _MoodButton(
                  mood: mood,
                  selected: state.mood == mood,
                  onTap: () => controller.updateMood(mood),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _journalTextController,
            onChanged: controller.updateJournalText,
            maxLines: 3,
            minLines: 2,
            decoration: InputDecoration(
              hintText: l10n.journalHint,
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (voiceNotePath != null)
            Row(
              children: [
                const Expanded(child: VoiceNoteBadge()),
                TextButton(
                  onPressed: controller.isRecordingVoice
                      ? controller.stopVoiceRecording
                      : controller.startVoiceRecording,
                  child: Text(l10n.reRecord),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: controller.isRecordingVoice
                    ? controller.stopVoiceRecording
                    : controller.startVoiceRecording,
                icon: Icon(
                  controller.isRecordingVoice ? Icons.stop_circle_rounded : Icons.mic_rounded,
                  color: controller.isRecordingVoice ? Colors.red : AppTheme.pink,
                ),
                label: Text(controller.isRecordingVoice ? l10n.stopRecording : l10n.addVoiceNote),
              ),
            ),
        ],
      ),
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({required this.mood, required this.selected, required this.onTap});

  final Mood mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: moodLabel(context, mood),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? mood.color.withValues(alpha: 0.15) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: selected ? mood.color : Colors.transparent, width: 2),
          ),
          child: Icon(
            mood.icon,
            color: selected ? mood.color : Colors.grey.shade400,
            size: selected ? 32 : 26,
          ),
        ),
      ),
    );
  }
}
