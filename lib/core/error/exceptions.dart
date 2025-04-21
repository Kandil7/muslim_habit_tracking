/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;

  AppException({required this.message});

  @override
  String toString() => message;
}

/// Server exceptions (API errors, network issues)
class ServerException extends AppException {
  ServerException({required String message}) : super(message: message);
}

/// Cache exceptions (local storage issues)
class CacheException extends AppException {
  CacheException({required String message}) : super(message: message);
}

/// Input validation exceptions
class ValidationException extends AppException {
  ValidationException({required String message}) : super(message: message);
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException({required String message}) : super(message: message);
}

/// Permission exceptions (e.g., notification permissions)
class PermissionException extends AppException {
  PermissionException({required String message}) : super(message: message);
}

/// Location exceptions (e.g., location services not enabled)

class LocationException extends AppException {
  LocationException({required String message}) : super(message: message);
}

/// Network exceptions (e.g., no internet connection)

class NetworkException extends AppException {
  NetworkException({required String message}) : super(message: message);
}
