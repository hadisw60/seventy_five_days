import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// Returns a motivational line for the given day, picked deterministically
/// so the same day always shows the same line during a session.
String quoteForDay(BuildContext context, int day) {
  final l10n = AppLocalizations.of(context)!;
  final quotes = [
    l10n.quote1,
    l10n.quote2,
    l10n.quote3,
    l10n.quote4,
    l10n.quote5,
    l10n.quote6,
    l10n.quote7,
    l10n.quote8,
    l10n.quote9,
    l10n.quote10,
  ];
  return quotes[(day - 1) % quotes.length];
}
