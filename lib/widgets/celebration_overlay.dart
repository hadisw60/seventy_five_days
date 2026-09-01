import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A confetti burst shown over the current screen. Fed by an externally
/// owned [ConfettiController] so callers decide exactly when to [play].
class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay({super.key, required this.controller, this.big = false});

  final ConfettiController controller;

  /// Bigger, denser burst for finishing the entire 75-day challenge.
  final bool big;

  static const _colors = [AppTheme.pink, AppTheme.blue, Colors.amber, Colors.green];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: pi / 2,
          blastDirectionality: BlastDirectionality.explosive,
          maxBlastForce: big ? 28 : 18,
          minBlastForce: big ? 14 : 6,
          emissionFrequency: big ? 0.08 : 0.04,
          numberOfParticles: big ? 4 : 2,
          gravity: 0.25,
          shouldLoop: false,
          colors: _colors,
        ),
      ),
    );
  }
}
