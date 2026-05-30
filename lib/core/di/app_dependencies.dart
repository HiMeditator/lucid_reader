import '../../features/settings/application/settings_controller.dart';
import '../logging/app_logger.dart';
import '../storage/app_database.dart';

class AppDependencies {
  const AppDependencies({
    required this.logger,
    required this.database,
    required this.settingsController,
  });

  final AppLogger logger;
  final AppDatabase database;
  final SettingsController settingsController;
}
