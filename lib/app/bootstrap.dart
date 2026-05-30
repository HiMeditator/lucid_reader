import '../core/di/app_dependencies.dart';
import '../core/logging/app_logger.dart';
import '../core/storage/app_database.dart';
import '../features/settings/application/settings_controller.dart';

AppDependencies bootstrapApp() {
  final logger = AppLogger();
  final database = PlaceholderAppDatabase(logger: logger);

  return AppDependencies(
    logger: logger,
    database: database,
    settingsController: SettingsController(),
  );
}
