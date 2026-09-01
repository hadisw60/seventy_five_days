import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Records the optional daily voice note and stores it somewhere durable,
/// mirroring [PhotoService]'s approach for the mandatory photo.
abstract class VoiceService {
  Future<void> startRecording();
  Future<String?> stopRecording();
}

class RecorderVoiceService implements VoiceService {
  RecorderVoiceService({AudioRecorder? recorder}) : _recorder = recorder ?? AudioRecorder();

  final AudioRecorder _recorder;

  @override
  Future<void> startRecording() async {
    if (!await _recorder.hasPermission()) {
      throw StateError('Microphone permission was denied.');
    }

    final voiceDir = await _voiceNotesDirectory();
    final path = '${voiceDir.path}/note_${DateTime.now().microsecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(), path: path);
  }

  @override
  Future<String?> stopRecording() => _recorder.stop();

  Future<Directory> _voiceNotesDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final voiceDir = Directory('${documentsDir.path}/voice_notes');
    if (!await voiceDir.exists()) {
      await voiceDir.create(recursive: true);
    }
    return voiceDir;
  }
}
