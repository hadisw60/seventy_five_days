import 'dart:io';

import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/day_record.dart';
import '../theme/app_theme.dart';

/// Side-by-side comparison of two progress photos. Defaults to the
/// earliest and latest photos taken, but either side can be changed to any
/// completed day that has a photo.
class BeforeAfterScreen extends StatefulWidget {
  const BeforeAfterScreen({super.key, required this.controller});

  final ChallengeController controller;

  @override
  State<BeforeAfterScreen> createState() => _BeforeAfterScreenState();
}

class _BeforeAfterScreenState extends State<BeforeAfterScreen> {
  int? _beforeDay;
  int? _afterDay;

  List<DayRecord> get _photoRecords => widget.controller.state.completedDays
      .where((record) => record.photoPath != null && File(record.photoPath!).existsSync())
      .toList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final records = _photoRecords;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.beforeAfterTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: records.length < 2 ? const _EmptyState() : _buildComparison(context, records),
      ),
    );
  }

  Widget _buildComparison(BuildContext context, List<DayRecord> records) {
    final beforeRecord = records.firstWhere(
      (record) => record.day == _beforeDay,
      orElse: () => records.first,
    );
    final afterRecord = records.firstWhere(
      (record) => record.day == _afterDay,
      orElse: () => records.last,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: _PhotoPanel(
              label: AppLocalizations.of(context)!.beforeLabel,
              record: beforeRecord,
              onChangeDay: () => _pickDay(records, isBefore: true),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Icon(Icons.compare_arrows_rounded, color: AppTheme.pink),
          ),
          Expanded(
            child: _PhotoPanel(
              label: AppLocalizations.of(context)!.afterLabel,
              record: afterRecord,
              onChangeDay: () => _pickDay(records, isBefore: false),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDay(List<DayRecord> records, {required bool isBefore}) async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final record in records)
                ListTile(
                  title: Text(AppLocalizations.of(sheetContext)!.dayNumber(record.day)),
                  onTap: () => Navigator.of(sheetContext).pop(record.day),
                ),
            ],
          ),
        );
      },
    );
    if (selected != null && mounted) {
      setState(() {
        if (isBefore) {
          _beforeDay = selected;
        } else {
          _afterDay = selected;
        }
      });
    }
  }
}

class _PhotoPanel extends StatelessWidget {
  const _PhotoPanel({required this.label, required this.record, required this.onChangeDay});

  final String label;
  final DayRecord record;
  final VoidCallback onChangeDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(record.photoPath!), fit: BoxFit.cover),
          Positioned(
            top: 12,
            left: 12,
            child: _Badge(text: '$label · ${l10n.dayNumber(record.day)}'),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.black.withValues(alpha: 0.55),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                onPressed: onChangeDay,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.compare_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.beforeAfterNeedsMorePhotos,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
