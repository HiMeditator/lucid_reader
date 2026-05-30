import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_reader/app/theme/app_theme.dart';

void main() {
  test('uses Simplified Chinese UI fonts on Windows', () {
    final theme = AppTheme.light(
      locale: const Locale('zh'),
      platform: TargetPlatform.windows,
    );

    final fallback = theme.textTheme.bodyMedium?.fontFamilyFallback;

    expect(theme.textTheme.bodyMedium?.fontFamily, 'Microsoft YaHei UI');
    expect(fallback, isNotNull);
    expect(
      fallback!.take(3),
      orderedEquals(['Microsoft YaHei', 'SimHei', 'SimSun']),
    );
  });

  test('keeps Android font selection platform default', () {
    final theme = AppTheme.light(
      locale: const Locale('zh'),
      platform: TargetPlatform.android,
    );

    expect(theme.textTheme.bodyMedium?.fontFamily, isNot('Microsoft YaHei UI'));
    expect(theme.textTheme.bodyMedium?.fontFamilyFallback, isNull);
  });
}
