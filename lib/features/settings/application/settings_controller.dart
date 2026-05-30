import 'package:flutter/material.dart';

import '../domain/app_locale_preference.dart';
import '../domain/app_settings.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({AppSettings? initialSettings})
    : _settings = initialSettings ?? const AppSettings();

  AppSettings _settings;

  AppSettings get settings => _settings;

  AppLocalePreference get localePreference => _settings.localePreference;

  Locale? get appLocale => _settings.localePreference.materialAppLocale;

  ThemeMode get themeMode => _settings.themeMode;

  void useSystemLocale() {
    _update(
      _settings.copyWith(localePreference: const AppLocalePreference.system()),
    );
  }

  void useManualLocale(SupportedAppLocale locale) {
    _update(
      _settings.copyWith(localePreference: AppLocalePreference.manual(locale)),
    );
  }

  void _update(AppSettings nextSettings) {
    if (nextSettings == _settings) {
      return;
    }

    _settings = nextSettings;
    notifyListeners();
  }
}
