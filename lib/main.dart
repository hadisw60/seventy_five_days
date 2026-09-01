import 'dart:async';

import 'package:flutter/material.dart';

import 'controllers/challenge_controller.dart';
import 'controllers/locale_controller.dart';
import 'controllers/reminder_controller.dart';
import 'l10n/generated/app_localizations.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/photo_service.dart';
import 'services/settings_service.dart';
import 'services/storage_service.dart';
import 'services/voice_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SharedPreferencesSettingsService();

  final controller = ChallengeController(
    storageService: SharedPreferencesStorageService(),
    photoService: ImagePickerPhotoService(),
    voiceService: RecorderVoiceService(),
  );

  final reminderController = ReminderController(
    settingsService: settingsService,
    notificationService: LocalNotificationService(),
  );
  unawaited(reminderController.initialize());

  final localeController = LocaleController(settingsService: settingsService);
  unawaited(localeController.load());

  runApp(
    SeventyFiveDaysApp(
      controller: controller,
      reminderController: reminderController,
      localeController: localeController,
    ),
  );
}

class SeventyFiveDaysApp extends StatelessWidget {
  const SeventyFiveDaysApp({
    super.key,
    required this.controller,
    required this.reminderController,
    required this.localeController,
  });

  final ChallengeController controller;
  final ReminderController reminderController;
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: AppTheme.light,
          locale: localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: HomeScreen(
            controller: controller,
            reminderController: reminderController,
            localeController: localeController,
          ),
        );
      },
    );
  }
}
