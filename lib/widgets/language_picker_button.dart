import 'package:flutter/material.dart';

import '../controllers/locale_controller.dart';
import '../l10n/generated/app_localizations.dart';

/// AppBar action that lets the user switch between English, Persian, or the
/// system default language.
class LanguagePickerButton extends StatelessWidget {
  const LanguagePickerButton({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<Locale?>(
      tooltip: l10n.language,
      icon: const Icon(Icons.language_rounded),
      onSelected: localeController.setLocale,
      itemBuilder: (context) => [
        PopupMenuItem<Locale?>(
          value: null,
          child: Text(l10n.languageSystemDefault),
        ),
        PopupMenuItem<Locale?>(
          value: const Locale('en'),
          child: Text(l10n.languageEnglish),
        ),
        PopupMenuItem<Locale?>(
          value: const Locale('fa'),
          child: Text(l10n.languagePersian),
        ),
      ],
    );
  }
}
