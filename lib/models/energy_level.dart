import 'package:flutter/material.dart';

/// Self-rated energy for the day, captured as part of the daily check-in.
///
/// Display labels are localized; see `lib/l10n/localized_labels.dart`.
enum EnergyLevel {
  low(Icons.battery_1_bar_rounded),
  medium(Icons.battery_4_bar_rounded),
  high(Icons.battery_full_rounded);

  const EnergyLevel(this.icon);

  final IconData icon;

  static EnergyLevel? fromName(String? name) {
    if (name == null) return null;
    for (final level in EnergyLevel.values) {
      if (level.name == name) return level;
    }
    return null;
  }
}
