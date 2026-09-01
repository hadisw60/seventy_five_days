import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:seventy_five_days/controllers/challenge_controller.dart';
import 'package:seventy_five_days/controllers/locale_controller.dart';
import 'package:seventy_five_days/controllers/reminder_controller.dart';
import 'package:seventy_five_days/main.dart';
import 'package:seventy_five_days/models/daily_task.dart';
import 'package:seventy_five_days/services/notification_service.dart';
import 'package:seventy_five_days/services/photo_service.dart';
import 'package:seventy_five_days/services/settings_service.dart';
import 'package:seventy_five_days/services/storage_service.dart';
import 'package:seventy_five_days/services/voice_service.dart';

// Neither is initialized/loaded in tests to avoid touching real platform
// channels; screens only read their (default) settings, which is enough
// for these assertions.
ReminderController _buildReminderController() => ReminderController(
      settingsService: SharedPreferencesSettingsService(),
      notificationService: LocalNotificationService(),
    );

LocaleController _buildLocaleController() =>
    LocaleController(settingsService: SharedPreferencesSettingsService());

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('starts fresh challenges on Day 1 of 75', (tester) async {
    final controller = ChallengeController(
      storageService: SharedPreferencesStorageService(),
      photoService: ImagePickerPhotoService(),
      voiceService: RecorderVoiceService(),
    );

    await tester.pumpWidget(
      SeventyFiveDaysApp(
        controller: controller,
        reminderController: _buildReminderController(),
        localeController: _buildLocaleController(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Day 1 / 75'), findsOneWidget);
    expect(find.text('Read 10 pages'), findsOneWidget);
    expect(find.text('Complete Day'), findsOneWidget);
  });

  testWidgets('Complete Day is blocked until every required task is done', (tester) async {
    final controller = ChallengeController(
      storageService: SharedPreferencesStorageService(),
      photoService: ImagePickerPhotoService(),
      voiceService: RecorderVoiceService(),
    );

    await tester.pumpWidget(
      SeventyFiveDaysApp(
        controller: controller,
        reminderController: _buildReminderController(),
        localeController: _buildLocaleController(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Complete Day'));
    await tester.tap(find.text('Complete Day'));
    await tester.pump();

    expect(find.text('Day 1 / 75'), findsOneWidget);
    expect(find.textContaining('Complete these first'), findsWidgets);
  });

  testWidgets('training timer persists progress periodically while running', (tester) async {
    final storage = SharedPreferencesStorageService();
    final controller = ChallengeController(
      storageService: storage,
      photoService: ImagePickerPhotoService(),
      voiceService: RecorderVoiceService(),
    );

    await tester.pumpWidget(
      SeventyFiveDaysApp(
        controller: controller,
        reminderController: _buildReminderController(),
        localeController: _buildLocaleController(),
      ),
    );
    await tester.pumpAndSettle();

    controller.startTraining();
    await tester.pump(const Duration(seconds: 11));

    expect(controller.trainingElapsedSeconds, greaterThanOrEqualTo(10));

    final saved = await storage.loadState();
    expect(
      saved!.taskOf(TaskType.training).elapsedSeconds,
      greaterThanOrEqualTo(10),
      reason: 'periodic auto-save should have written by the 10s mark',
    );

    controller.pauseTraining();
  });
}
