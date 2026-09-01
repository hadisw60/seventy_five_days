import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Captures or selects the mandatory daily progress photo and stores it
/// somewhere durable, returning a local path that survives app restarts.
///
/// Abstracted so the underlying picker/storage can change (e.g. a real
/// camera-only flow, or cloud-synced storage) without touching callers.
abstract class PhotoService {
  Future<String?> pickPhotoForDay(int day);
}

class ImagePickerPhotoService implements PhotoService {
  ImagePickerPhotoService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pickPhotoForDay(int day) async {
    if (kIsWeb) {
      throw UnsupportedError('Photo capture is not supported on web yet.');
    }

    final bool supportsCamera = Platform.isAndroid || Platform.isIOS;
    final XFile? picked = await _picker.pickImage(
      source: supportsCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1920,
    );

    if (picked == null) return null;

    final Directory photosDir = await _photosDirectory();
    final String destinationPath = '${photosDir.path}/day_$day.jpg';
    await File(picked.path).copy(destinationPath);
    return destinationPath;
  }

  Future<Directory> _photosDirectory() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${documentsDir.path}/daily_photos');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    return photosDir;
  }
}
