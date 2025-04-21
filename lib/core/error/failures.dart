import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  /// Error message
  final String message;

  /// Constructor
  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Failure when a cache operation fails
class CacheFailure extends Failure {
  /// Constructor
  const CacheFailure({required super.message});
}

/// Failure when a server operation fails
class ServerFailure extends Failure {
  /// Constructor
  const ServerFailure({required super.message});
}

/// Failure when a network operation fails
class NetworkFailure extends Failure {
  /// Constructor
  const NetworkFailure({required super.message});
}

/// Failure when data is not found
class NotFoundFailure extends Failure {
  /// Constructor
  const NotFoundFailure({required super.message});
}

/// Failure when an operation is not permitted
class PermissionFailure extends Failure {
  /// Constructor
  const PermissionFailure({required super.message});
}

/// Failure when an unknown error occurs
class UnknownFailure extends Failure {
  /// Constructor
  const UnknownFailure({required super.message});
}
