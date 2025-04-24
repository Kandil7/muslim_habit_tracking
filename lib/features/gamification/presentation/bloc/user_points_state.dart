import 'package:equatable/equatable.dart';

import '../../domain/entities/user_points.dart';

/// States for the UserPoints BLoC
abstract class UserPointsState extends Equatable {
  const UserPointsState();

  @override
  List<Object> get props => [];
}

/// Initial state
class UserPointsInitial extends UserPointsState {}

/// Loading state
class UserPointsLoading extends UserPointsState {}

/// State when user points are loaded
class UserPointsLoaded extends UserPointsState {
  final UserPoints userPoints;

  const UserPointsLoaded({required this.userPoints});

  @override
  List<Object> get props => [userPoints];
}

/// State when points are added
class PointsAdded extends UserPointsState {
  final UserPoints userPoints;
  final int pointsAdded;
  final String reason;

  const PointsAdded({
    required this.userPoints,
    required this.pointsAdded,
    required this.reason,
  });

  @override
  List<Object> get props => [userPoints, pointsAdded, reason];
}

/// State when points are spent
class PointsSpent extends UserPointsState {
  final UserPoints userPoints;
  final int pointsSpent;
  final String reason;

  const PointsSpent({
    required this.userPoints,
    required this.pointsSpent,
    required this.reason,
  });

  @override
  List<Object> get props => [userPoints, pointsSpent, reason];
}

/// State when points are reset
class PointsReset extends UserPointsState {
  final UserPoints userPoints;

  const PointsReset({required this.userPoints});

  @override
  List<Object> get props => [userPoints];
}

/// Error state
class UserPointsError extends UserPointsState {
  final String message;

  const UserPointsError({required this.message});

  @override
  List<Object> get props => [message];
}
