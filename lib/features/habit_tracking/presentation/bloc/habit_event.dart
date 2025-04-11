import 'package:equatable/equatable.dart';

import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_log.dart';

/// Events for the habit feature
abstract class HabitEvent extends Equatable {
  const HabitEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to get all habits
class GetHabitsEvent extends HabitEvent {}

/// Event to get a habit by ID
class GetHabitByIdEvent extends HabitEvent {
  final String id;
  
  const GetHabitByIdEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}

/// Event to create a habit
class CreateHabitEvent extends HabitEvent {
  final Habit habit;
  
  const CreateHabitEvent({required this.habit});
  
  @override
  List<Object?> get props => [habit];
}

/// Event to update a habit
class UpdateHabitEvent extends HabitEvent {
  final Habit habit;
  
  const UpdateHabitEvent({required this.habit});
  
  @override
  List<Object?> get props => [habit];
}

/// Event to delete a habit
class DeleteHabitEvent extends HabitEvent {
  final String id;
  
  const DeleteHabitEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}

/// Event to get all logs for a habit
class GetHabitLogsEvent extends HabitEvent {
  final String habitId;
  
  const GetHabitLogsEvent({required this.habitId});
  
  @override
  List<Object?> get props => [habitId];
}

/// Event to get logs for a habit within a date range
class GetHabitLogsByDateRangeEvent extends HabitEvent {
  final String habitId;
  final DateTime startDate;
  final DateTime endDate;
  
  const GetHabitLogsByDateRangeEvent({
    required this.habitId,
    required this.startDate,
    required this.endDate,
  });
  
  @override
  List<Object?> get props => [habitId, startDate, endDate];
}

/// Event to create a habit log
class CreateHabitLogEvent extends HabitEvent {
  final HabitLog habitLog;
  
  const CreateHabitLogEvent({required this.habitLog});
  
  @override
  List<Object?> get props => [habitLog];
}

/// Event to update a habit log
class UpdateHabitLogEvent extends HabitEvent {
  final HabitLog habitLog;
  
  const UpdateHabitLogEvent({required this.habitLog});
  
  @override
  List<Object?> get props => [habitLog];
}

/// Event to delete a habit log
class DeleteHabitLogEvent extends HabitEvent {
  final String id;
  
  const DeleteHabitLogEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}
