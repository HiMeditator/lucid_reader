// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Lucid Reader';

  @override
  String get libraryTitle => '书库';

  @override
  String get settingsTitle => '设置';

  @override
  String get emptyLibraryTitle => '还没有书籍';

  @override
  String get emptyLibrarySubtitle => '导入后的书籍会显示在这里。';

  @override
  String get importBookAction => '导入书籍';

  @override
  String get importUnavailableMessage => '书籍导入将在下一阶段实现。';

  @override
  String get interfaceLanguageSection => '界面语言';

  @override
  String get localeSystem => '跟随系统';

  @override
  String get localeEnglish => 'English';

  @override
  String get localeChinese => '中文';

  @override
  String get localeJapanese => '日本語';

  @override
  String get unknownRouteTitle => '页面不存在';

  @override
  String get unknownRouteMessage => '此页面暂不可用。';
}
