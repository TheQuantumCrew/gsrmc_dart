class SimpleRemoteConfigException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  SimpleRemoteConfigException({required this.message, StackTrace? stackTrace})
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return 'SimpleRemoteConfigException: $message';
  }
}