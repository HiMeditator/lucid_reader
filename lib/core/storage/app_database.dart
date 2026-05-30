import '../logging/app_logger.dart';

abstract interface class AppDatabase {
  int get schemaVersion;

  Future<void> open();

  Future<void> close();
}

class PlaceholderAppDatabase implements AppDatabase {
  PlaceholderAppDatabase({required this.logger});

  final AppLogger logger;
  var _opened = false;

  @override
  int get schemaVersion => 1;

  bool get isOpen => _opened;

  @override
  Future<void> open() async {
    _opened = true;
    logger.info('Opened placeholder database schema $schemaVersion.');
  }

  @override
  Future<void> close() async {
    _opened = false;
    logger.info('Closed placeholder database.');
  }
}
