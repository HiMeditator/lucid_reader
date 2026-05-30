import 'package:flutter/material.dart';

import 'app_locale_preference.dart';

class AppSettings {
  const AppSettings({
    this.localePreference = const AppLocalePreference.system(),
    this.themeMode = ThemeMode.system,
  });

  final AppLocalePreference localePreference;
  final ThemeMode themeMode;

  AppSettings copyWith({
    AppLocalePreference? localePreference,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      localePreference: localePreference ?? this.localePreference,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppSettings &&
        other.localePreference == localePreference &&
        other.themeMode == themeMode;
  }

  @override
  int get hashCode => Object.hash(localePreference, themeMode);
}
