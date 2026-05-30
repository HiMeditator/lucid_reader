import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seedColor = Color(0xFF2F6F73);

  static ThemeData light() {
    return _theme(ColorScheme.fromSeed(seedColor: _seedColor));
  }

  static ThemeData dark() {
    return _theme(
      ColorScheme.fromSeed(seedColor: _seedColor, brightness: Brightness.dark),
    );
  }

  static ThemeData _theme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
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
