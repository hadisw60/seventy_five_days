import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../data/motivational_quotes.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/challenge_state.dart';
import '../theme/app_theme.dart';
import '../widgets/day_history_tile.dart';
import '../widgets/motivational_quote_card.dart';
import '../widgets/weight_entry_dialog.dart';
import '../widgets/weight_entry_tile.dart';
import 'before_after_screen.dart';
import 'transformation_screen.dart';

/// Shows overall progress, a daily motivational line, and the history of
/// completed days (with their progress photo, when available).
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.controller});

  final ChallengeController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.progressTooltip,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = controller.state;
    final completed = state.completedDays.reversed.toList();
    final maxWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = maxWidth > 700 ? (maxWidth - 700) / 2 + 20 : 20.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsRow(state: state),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => BeforeAfterScreen(controller: controller)),
              ),
              icon: const Icon(Icons.compare_rounded, color: AppTheme.pink),
              label: Text(l10n.viewBeforeAfter),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => TransformationScreen(controller: controller)),
              ),
              icon: const Icon(Icons.movie_creation_rounded, color: AppTheme.blue),
              label: Text(l10n.viewTransformation),
            ),
          ),
          const SizedBox(height: 20),
          MotivationalQuoteCard(quote: quoteForDay(context, state.currentDay)),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.weightProgressTitle,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => showWeightEntryDialog(context, controller),
                child: Text(l10n.logWeight),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (state.weightEntries.isEmpty)
            Text(
              l10n.noWeightEntriesYet,
              style: TextStyle(color: Colors.grey.shade600),
            )
          else
            for (var i = state.weightEntries.length - 1; i >= 0; i--)
              WeightEntryTile(
                entry: state.weightEntries[i],
                previousWeightKg: i > 0 ? state.weightEntries[i - 1].weightKg : null,
              ),
          const SizedBox(height: 20),
          Text(
            l10n.completedDaysTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (completed.isEmpty)
            const _EmptyHistory()
          else
            for (final record in completed) DayHistoryTile(record: record),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state});

  final ChallengeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.pink, AppTheme.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(label: l10n.daysDone, value: '${state.completedDays.length}'),
          _Stat(
            label: l10n.daysLeft,
            value: '${ChallengeState.totalDays - state.completedDays.length}',
          ),
          _Stat(
            label: l10n.progressLabel,
            value: '${(state.progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.hourglass_empty_rounded, color: Colors.grey.shade400, size: 36),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.noCompletedDaysYet,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
