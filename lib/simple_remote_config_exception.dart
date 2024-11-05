
/// A custom exception class for handling errors related to the Simple Remote Config.
/// 
/// This exception can be used to indicate various issues that may arise when
/// working with the Simple Remote Config, such as network errors, parsing errors,
/// or configuration issues.
/// 
/// Example usage:
/// ```dart
/// try {
///   // Code that might throw a SimpleRemoteConfigException
/// } catch (e) {
///   if (e is SimpleRemoteConfigException) {
///     // Handle the exception
///   }
/// }
/// ```
class SimpleRemoteConfigException implements Exception {
  /// The error message associated with this exception.
  final String message;

  /// The stack trace associated with this exception.
  final StackTrace? stackTrace;

  SimpleRemoteConfigException({required this.message, StackTrace? stackTrace})
      : stackTrace = stackTrace ?? StackTrace.current;

  @override
  String toString() {
    return 'SimpleRemoteConfigException: $message';
  }
}