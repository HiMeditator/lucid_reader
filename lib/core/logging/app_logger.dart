enum AppLogLevel { debug, info, warning, error }

class AppLogRecord {
  const AppLogRecord({
    required this.level,
    required this.message,
    required this.createdAt,
    this.error,
    this.stackTrace,
  });

  final AppLogLevel level;
  final String message;
  final DateTime createdAt;
  final Object? error;
  final StackTrace? stackTrace;
}

class AppLogger {
  final List<AppLogRecord> _records = [];

  List<AppLogRecord> get records => List.unmodifiable(_records);

  void debug(String message) {
    _write(AppLogLevel.debug, message);
  }

  void info(String message) {
    _write(AppLogLevel.info, message);
  }

  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _write(AppLogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _write(AppLogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  void _write(
    AppLogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _records.add(
      AppLogRecord(
        level: level,
        message: message,
        createdAt: DateTime.now(),
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}
