import 'package:flutter/widgets.dart';

enum AppLocaleMode { system, manual }

enum SupportedAppLocale {
  english(Locale('en')),
  chinese(Locale('zh')),
  japanese(Locale('ja'));

  const SupportedAppLocale(this.locale);

  final Locale locale;

  static SupportedAppLocale fromLocale(Locale locale) {
    return SupportedAppLocale.values.firstWhere(
      (supportedLocale) =>
          supportedLocale.locale.languageCode == locale.languageCode,
      orElse: () => SupportedAppLocale.english,
    );
  }
}

class AppLocalePreference {
  const AppLocalePreference.system()
    : mode = AppLocaleMode.system,
      locale = null;

  const AppLocalePreference.manual(SupportedAppLocale supportedLocale)
    : mode = AppLocaleMode.manual,
      locale = supportedLocale;

  final AppLocaleMode mode;
  final SupportedAppLocale? locale;

  Locale? get materialAppLocale {
    return mode == AppLocaleMode.manual ? locale?.locale : null;
  }

  @override
  bool operator ==(Object other) {
    return other is AppLocalePreference &&
        other.mode == mode &&
        other.locale == locale;
  }

  @override
  int get hashCode => Object.hash(mode, locale);
}
