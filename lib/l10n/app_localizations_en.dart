// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lucid Reader';

  @override
  String get libraryTitle => 'Library';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get emptyLibraryTitle => 'No books yet';

  @override
  String get emptyLibrarySubtitle => 'Your imported books will appear here.';

  @override
  String get importBookAction => 'Import book';

  @override
  String get importUnavailableMessage =>
      'Book import is planned for the next stage.';

  @override
  String get interfaceLanguageSection => 'Interface language';

  @override
  String get localeSystem => 'Follow system';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeChinese => '中文';

  @override
  String get localeJapanese => '日本語';

  @override
  String get unknownRouteTitle => 'Page not found';

  @override
  String get unknownRouteMessage => 'This destination is not available.';
}
