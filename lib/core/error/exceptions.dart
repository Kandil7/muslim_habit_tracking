/// Base class for all exceptions in the application
class AppException implements Exception {
  /// Error message
  final String message;

  /// Constructor
  const AppException({required this.message});

  @override
  String toString() => message;
}

/// Exception when a server operation fails
class ServerException extends AppException {
  /// Constructor
  const ServerException({required super.message});
}

/// Exception when a cache operation fails
class CacheException extends AppException {
  /// Constructor
  const CacheException({required super.message});
}

/// Exception when a network operation fails
class NetworkException extends AppException {
  /// Constructor
  const NetworkException({required super.message});
}

/// Exception when data is not found
class NotFoundException extends AppException {
  /// Constructor
  const NotFoundException({required super.message});
}

/// Exception when an operation is not permitted
class PermissionException extends AppException {
  /// Constructor
  const PermissionException({required super.message});
}
