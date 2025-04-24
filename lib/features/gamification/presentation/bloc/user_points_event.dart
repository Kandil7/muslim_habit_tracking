import 'package:equatable/equatable.dart';

/// Events for the UserPoints BLoC
abstract class UserPointsEvent extends Equatable {
  const UserPointsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load user points
class LoadUserPointsEvent extends UserPointsEvent {}

/// Event to add points
class AddPointsEvent extends UserPointsEvent {
  final int points;
  final String reason;

  const AddPointsEvent({
    required this.points,
    required this.reason,
  });

  @override
  List<Object> get props => [points, reason];
}

/// Event to spend points
class SpendPointsEvent extends UserPointsEvent {
  final int points;
  final String reason;

  const SpendPointsEvent({
    required this.points,
    required this.reason,
  });

  @override
  List<Object> get props => [points, reason];
}

/// Event to reset points
class ResetPointsEvent extends UserPointsEvent {}
