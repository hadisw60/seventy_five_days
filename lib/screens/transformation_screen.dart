import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../controllers/challenge_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/day_record.dart';
import '../theme/app_theme.dart';

/// An in-app slideshow through every progress photo taken during the
/// challenge — the "75-photo clip", without needing real video encoding.
class TransformationScreen extends StatefulWidget {
  const TransformationScreen({super.key, required this.controller});

  final ChallengeController controller;

  @override
  State<TransformationScreen> createState() => _TransformationScreenState();
}

class _TransformationScreenState extends State<TransformationScreen> {
  late final List<DayRecord> _records = widget.controller.state.completedDays
      .where((record) => record.photoPath != null && File(record.photoPath!).existsSync())
      .toList();

  int _index = 0;
  Timer? _timer;
  bool _isPlaying = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    if (_isPlaying) {
      _timer?.cancel();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isPlaying = true);
    _timer = Timer.periodic(const Duration(milliseconds: 900), (_) {
      setState(() {
        _index = _index >= _records.length - 1 ? 0 : _index + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.transformationTitle),
      ),
      body: _records.isEmpty ? _buildEmpty(l10n) : _buildSlideshow(l10n),
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.beforeAfterNeedsMorePhotos,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildSlideshow(AppLocalizations l10n) {
    final record = _records[_index];

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Image.file(
                    File(record.photoPath!),
                    key: ValueKey(record.day),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          Text(
            l10n.dayNumber(record.day),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Slider(
            value: _index.toDouble(),
            min: 0,
            max: (_records.length - 1).toDouble(),
            divisions: _records.length > 1 ? _records.length - 1 : null,
            activeColor: AppTheme.pink,
            onChanged: _records.length > 1
                ? (value) {
                    _timer?.cancel();
                    setState(() {
                      _isPlaying = false;
                      _index = value.round();
                    });
                  }
                : null,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: IconButton(
              iconSize: 56,
              color: AppTheme.pink,
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
              ),
              onPressed: _records.length > 1 ? _togglePlay : null,
            ),
          ),
        ],
      ),
    );
  }
}
