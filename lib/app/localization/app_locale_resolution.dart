import 'package:flutter/widgets.dart';

abstract final class AppLocaleResolution {
  static Locale resolve(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) {
      return const Locale('en');
    }

    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }

    return const Locale('en');
  }
}
