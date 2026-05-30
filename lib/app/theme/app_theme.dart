import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seedColor = Color(0xFF2F6F73);

  static ThemeData light({Locale? locale, TargetPlatform? platform}) {
    return _theme(
      ColorScheme.fromSeed(seedColor: _seedColor),
      locale: locale,
      platform: platform ?? defaultTargetPlatform,
    );
  }

  static ThemeData dark({Locale? locale, TargetPlatform? platform}) {
    return _theme(
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark),
      locale: locale,
      platform: platform ?? defaultTargetPlatform,
    );
  }

  static ThemeData _theme(
    ColorScheme colorScheme, {
    required Locale? locale,
    required TargetPlatform platform,
  }) {
    final fontConfig = _PlatformFontConfig.resolve(
      locale: locale,
      platform: platform,
    );

    return ThemeData(
      useMaterial3: true,
      platform: platform,
      colorScheme: colorScheme,
      fontFamily: fontConfig.fontFamily,
      fontFamilyFallback: fontConfig.fontFamilyFallback,
      visualDensity: VisualDensity.standard,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 24),
      ),
    );
  }
}

class _PlatformFontConfig {
  const _PlatformFontConfig({
    required this.fontFamily,
    required this.fontFamilyFallback,
  });

  final String? fontFamily;
  final List<String>? fontFamilyFallback;

  static const _platformDefault = _PlatformFontConfig(
    fontFamily: null,
    fontFamilyFallback: null,
  );

  static const _windowsEnglish = _PlatformFontConfig(
    fontFamily: 'Segoe UI',
    fontFamilyFallback: ['Microsoft YaHei UI', 'Yu Gothic UI', 'Meiryo'],
  );

  static const _windowsSimplifiedChinese = _PlatformFontConfig(
    fontFamily: 'Microsoft YaHei UI',
    fontFamilyFallback: ['Microsoft YaHei', 'SimHei', 'SimSun', 'Segoe UI'],
  );

  static const _windowsJapanese = _PlatformFontConfig(
    fontFamily: 'Yu Gothic UI',
    fontFamilyFallback: [
      'Yu Gothic',
      'Meiryo',
      'Microsoft YaHei UI',
      'Segoe UI',
    ],
  );

  static _PlatformFontConfig resolve({
    required Locale? locale,
    required TargetPlatform platform,
  }) {
    if (platform != TargetPlatform.windows) {
      return _platformDefault;
    }

    return switch (locale?.languageCode) {
      'zh' => _windowsSimplifiedChinese,
      'ja' => _windowsJapanese,
      _ => _windowsEnglish,
    };
  }
}
