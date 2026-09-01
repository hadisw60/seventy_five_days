import 'package:flutter/material.dart';

/// How the user felt on a given day. Purely optional, journal-style data —
/// it never gates day completion.
///
/// Display labels are localized; see `lib/l10n/localized_labels.dart`.
enum Mood {
  great(Icons.sentiment_very_satisfied_rounded, Colors.green),
  good(Icons.sentiment_satisfied_rounded, Colors.lightGreen),
  okay(Icons.sentiment_neutral_rounded, Colors.amber),
  bad(Icons.sentiment_dissatisfied_rounded, Colors.orange),
  terrible(Icons.sentiment_very_dissatisfied_rounded, Colors.red);

  const Mood(this.icon, this.color);

  final IconData icon;
  final Color color;

  static Mood? fromName(String? name) {
    if (name == null) return null;
    for (final mood in Mood.values) {
      if (mood.name == name) return mood;
    }
    return null;
  }
}
