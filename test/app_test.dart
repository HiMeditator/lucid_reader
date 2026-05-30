import 'package:flutter_test/flutter_test.dart';
import 'package:lucid_reader/app/app.dart';
import 'package:lucid_reader/core/di/app_dependencies.dart';
import 'package:lucid_reader/core/logging/app_logger.dart';
import 'package:lucid_reader/core/storage/app_database.dart';
import 'package:lucid_reader/features/settings/application/settings_controller.dart';

void main() {
  testWidgets('shows the empty library screen', (tester) async {
    await tester.pumpWidget(LucidReaderApp(dependencies: _testDependencies()));

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('No books yet'), findsOneWidget);
    expect(find.text('Import book'), findsOneWidget);
  });

  testWidgets('opens settings and switches interface language', (tester) async {
    await tester.pumpWidget(LucidReaderApp(dependencies: _testDependencies()));

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Interface language'), findsOneWidget);

    await tester.tap(find.text('中文'));
    await tester.pumpAndSettle();

    expect(find.text('设置'), findsOneWidget);
    expect(find.text('界面语言'), findsOneWidget);

    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('インターフェース言語'), findsOneWidget);
  });
}

AppDependencies _testDependencies() {
  final logger = AppLogger();

  return AppDependencies(
    logger: logger,
    database: PlaceholderAppDatabase(logger: logger),
    settingsController: SettingsController(),
  );
}
