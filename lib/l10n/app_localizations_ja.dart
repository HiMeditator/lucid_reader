// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Lucid Reader';

  @override
  String get libraryTitle => 'ライブラリ';

  @override
  String get settingsTitle => '設定';

  @override
  String get emptyLibraryTitle => '本はまだありません';

  @override
  String get emptyLibrarySubtitle => 'インポートした本がここに表示されます。';

  @override
  String get importBookAction => '本をインポート';

  @override
  String get importUnavailableMessage => '本のインポートは次の段階で実装します。';

  @override
  String get interfaceLanguageSection => 'インターフェース言語';

  @override
  String get localeSystem => 'システムに合わせる';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeChinese => '中文';

  @override
  String get localeJapanese => '日本語';

  @override
  String get unknownRouteTitle => 'ページが見つかりません';

  @override
  String get unknownRouteMessage => 'このページは利用できません。';
}
