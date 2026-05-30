enum AppErrorCode {
  unknown,
  fileNotFound,
  permissionDenied,
  unsupportedFormat,
  documentParseFailed,
  providerNotConfigured,
  requestTimeout,
}

class AppError {
  const AppError({
    required this.code,
    required this.message,
    this.cause,
    this.stackTrace,
  });

  final AppErrorCode code;
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'AppError(code: $code, message: $message)';
  }
}
