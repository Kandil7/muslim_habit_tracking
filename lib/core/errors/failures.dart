import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Server failures (API errors, network issues)
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

/// Cache failures (local storage issues)
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Input validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({required String message}) : super(message: message);
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}

/// Permission failures (e.g., notification permissions)
class PermissionFailure extends Failure {
  const PermissionFailure({required String message}) : super(message: message);
}

/// Location failures (e.g., location services disabled)
class LocationFailure extends Failure {
  const LocationFailure({required String message}) : super(message: message);
}

/// General application failures
class AppFailure extends Failure {
  const AppFailure({required String message}) : super(message: message);
}
