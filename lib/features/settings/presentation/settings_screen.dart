import 'package:flutter/material.dart';
import 'package:lucid_reader/l10n/app_localizations.dart';

import '../../../app/app_scope.dart';
import '../domain/app_locale_preference.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = AppScope.of(context);

    return ListenableBuilder(
      listenable: dependencies.settingsController,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        final selection = _LocaleSelection.fromPreference(
          dependencies.settingsController.localePreference,
        );

        return Scaffold(
          appBar: AppBar(title: Text(l10n.settingsTitle)),
          body: SafeArea(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    l10n.interfaceLanguageSection,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                RadioGroup<_LocaleSelection>(
                  groupValue: selection,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    switch (value) {
                      case _LocaleSelection.system:
                        dependencies.settingsController.useSystemLocale();
                      case _LocaleSelection.english:
                        dependencies.settingsController.useManualLocale(
                          SupportedAppLocale.english,
                        );
                      case _LocaleSelection.chinese:
                        dependencies.settingsController.useManualLocale(
                          SupportedAppLocale.chinese,
                        );
                      case _LocaleSelection.japanese:
                        dependencies.settingsController.useManualLocale(
                          SupportedAppLocale.japanese,
                        );
                    }
                  },
                  child: Column(
                    children: [
                      RadioListTile<_LocaleSelection>(
                        value: _LocaleSelection.system,
                        title: Text(l10n.localeSystem),
                      ),
                      RadioListTile<_LocaleSelection>(
                        value: _LocaleSelection.english,
                        title: Text(l10n.localeEnglish),
                      ),
                      RadioListTile<_LocaleSelection>(
                        value: _LocaleSelection.chinese,
                        title: Text(l10n.localeChinese),
                      ),
                      RadioListTile<_LocaleSelection>(
                        value: _LocaleSelection.japanese,
                        title: Text(l10n.localeJapanese),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum _LocaleSelection {
  system,
  english,
  chinese,
  japanese;

  static _LocaleSelection fromPreference(AppLocalePreference preference) {
    if (preference.mode == AppLocaleMode.system) {
      return _LocaleSelection.system;
    }

    return switch (preference.locale) {
      SupportedAppLocale.english => _LocaleSelection.english,
      SupportedAppLocale.chinese => _LocaleSelection.chinese,
      SupportedAppLocale.japanese => _LocaleSelection.japanese,
      null => _LocaleSelection.system,
    };
  }
}
