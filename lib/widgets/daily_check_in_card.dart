import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/localized_labels.dart';
import '../models/adherence_level.dart';
import '../models/energy_level.dart';
import '../models/mood.dart';
import '../theme/app_theme.dart';
import 'voice_note_badge.dart';

/// The daily check-in: mood, energy, and adherence, plus an optional
/// free-text note and voice memo. Mood + energy + adherence together gate
/// the [TaskType.checkin] task; the note and voice memo stay optional.
///
/// Owns its own [TextEditingController] so that rebuilds triggered
/// elsewhere in the app (e.g. the training timer ticking every second)
/// never reset the user's cursor position mid-typing.
class DailyCheckInCard extends StatefulWidget {
  const DailyCheckInCard({super.key, required this.controller});

  final ChallengeController controller;

  @override
  State<DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends State<DailyCheckInCard> {
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
    final isComplete =
        state.mood != null && state.energyLevel != null && state.adherenceLevel != null;

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
          const SizedBox(height: 2),
          Text(
            l10n.checkinRequiredHint,
            style: TextStyle(
              color: isComplete ? Colors.green.shade700 : Colors.red.shade300,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 18),
          Text(l10n.energyTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final energy in EnergyLevel.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _OptionChip(
                      icon: energy.icon,
                      label: energyLabel(context, energy),
                      selected: state.energyLevel == energy,
                      onTap: () => controller.updateEnergy(energy),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Text(l10n.adherenceTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final adherence in AdherenceLevel.values)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _OptionChip(
                      icon: adherence.icon,
                      label: adherenceLabel(context, adherence),
                      selected: state.adherenceLevel == adherence,
                      onTap: () => controller.updateAdherence(adherence),
                    ),
                  ),
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

/// A labeled, tappable pill used for the energy and adherence pickers.
class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppTheme.pink.withValues(alpha: 0.12) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppTheme.pink : Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: selected ? AppTheme.pink : Colors.grey.shade500),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected ? AppTheme.pink : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
