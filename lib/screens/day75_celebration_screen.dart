import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/celebration_overlay.dart';
import 'transformation_screen.dart';

/// Full-screen takeover shown once, right after finishing day 75.
class Day75CelebrationScreen extends StatefulWidget {
  const Day75CelebrationScreen({super.key, required this.controller});

  final ChallengeController controller;

  @override
  State<Day75CelebrationScreen> createState() => _Day75CelebrationScreenState();
}

class _Day75CelebrationScreenState extends State<Day75CelebrationScreen> {
  late final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 4));

  @override
  void initState() {
    super.initState();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = widget.controller.state;
    final photoCount =
        state.completedDays.where((record) => record.photoPath != null).length;
    final weightEntries = state.weightEntries;
    final hasWeightChange = weightEntries.length >= 2;

    return Scaffold(
      backgroundColor: AppTheme.pink,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 96),
                    const SizedBox(height: 20),
                    Text(
                      l10n.challengeCompletedTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.challengeCompletedBody,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StatColumn(value: '${state.completedDays.length}', label: l10n.daysDone),
                          const SizedBox(width: 24),
                          _StatColumn(value: '$photoCount', label: l10n.taskPhoto),
                          if (hasWeightChange) ...[
                            const SizedBox(width: 24),
                            _StatColumn(
                              value: (weightEntries.last.weightKg - weightEntries.first.weightKg)
                                  .toStringAsFixed(1),
                              label: l10n.weightProgressTitle,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TransformationScreen(controller: widget.controller),
                          ),
                        ),
                        icon: const Icon(Icons.movie_creation_rounded),
                        label: Text(l10n.viewTransformation),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.pink,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.backToHome, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          CelebrationOverlay(controller: _confettiController, big: true),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
