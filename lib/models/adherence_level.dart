import 'package:flutter/material.dart';

/// How closely the user stuck to today's rules, self-rated as part of the
/// daily check-in. This is reflective, not a task gate on its own — the
/// tasks themselves already gate day completion.
///
/// Display labels are localized; see `lib/l10n/localized_labels.dart`.
enum AdherenceLevel {
  full(Icons.check_circle_rounded),
  partial(Icons.adjust_rounded),
  weak(Icons.remove_circle_outline_rounded);

  const AdherenceLevel(this.icon);

  final IconData icon;

  static AdherenceLevel? fromName(String? name) {
    if (name == null) return null;
    for (final level in AdherenceLevel.values) {
      if (level.name == name) return level;
    }
    return null;
  }
}
