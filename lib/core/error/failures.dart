import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const Failure({required this.message, this.code, this.stackTrace});

  @override
  List<Object?> get props => [message, code, stackTrace];
}

/// Server failures (API errors, network issues)
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, statusCode];
}

/// Cache failures (local storage issues)
class CacheFailure extends Failure {
  final String? key;

  const CacheFailure({
    required super.message,
    this.key,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, key];
}

/// Input validation failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, fieldErrors];
}

/// Authentication failures
class AuthFailure extends Failure {
  final AuthErrorType errorType;

  const AuthFailure({
    required super.message,
    this.errorType = AuthErrorType.unknown,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, errorType];
}

/// Authentication error types
enum AuthErrorType {
  invalidCredentials,
  userNotFound,
  userDisabled,
  tooManyRequests,
  serverError,
  networkError,
  unknown,
}

/// Permission failures (e.g., notification permissions)
class PermissionFailure extends Failure {
  final PermissionType permissionType;

  const PermissionFailure({
    required super.message,
    required this.permissionType,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, permissionType];
}

/// Permission types
enum PermissionType {
  location,
  notification,
  storage,
  camera,
  microphone,
  calendar,
  contacts,
  unknown,
}

/// General application failures
class AppFailure extends Failure {
  const AppFailure({required super.message, super.code, super.stackTrace});
}

/// Location failures (e.g., location services not enabled)
class LocationFailure extends Failure {
  final LocationErrorType errorType;

  const LocationFailure({
    required super.message,
    this.errorType = LocationErrorType.unknown,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, errorType];
}

/// Location error types
enum LocationErrorType {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  networkError,
  timeout,
  unknown,
}

/// Network failures (e.g., no internet connection)
class NetworkFailure extends Failure {
  final NetworkErrorType errorType;

  const NetworkFailure({
    required super.message,
    this.errorType = NetworkErrorType.unknown,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, errorType];
}

/// Network error types
enum NetworkErrorType { noInternet, timeout, serverError, badResponse, unknown }

/// Database failures
class DatabaseFailure extends Failure {
  final String? operation;

  const DatabaseFailure({
    required super.message,
    this.operation,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, operation];
}

/// Timeout failures
class TimeoutFailure extends Failure {
  final Duration? duration;

  const TimeoutFailure({
    required super.message,
    this.duration,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, duration];
}

/// Format failures (e.g., parsing errors)
class FormatFailure extends Failure {
  final String? input;

  const FormatFailure({
    required super.message,
    this.input,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, input];
}

/// Resource not found failures
class ResourceNotFoundFailure extends Failure {
  final String? resourceId;
  final String? resourceType;

  const ResourceNotFoundFailure({
    required super.message,
    this.resourceId,
    this.resourceType,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [
    message,
    code,
    stackTrace,
    resourceId,
    resourceType,
  ];
}

/// Feature not available failures
class FeatureNotAvailableFailure extends Failure {
  final String? featureName;

  const FeatureNotAvailableFailure({
    required super.message,
    this.featureName,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, stackTrace, featureName];
}

/// Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
    super.stackTrace,
  });
}
