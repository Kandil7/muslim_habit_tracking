import 'package:equatable/equatable.dart';

import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_log.dart';

/// States for the habit feature
abstract class HabitState extends Equatable {
  const HabitState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class HabitInitial extends HabitState {}

/// Loading state
class HabitLoading extends HabitState {}

/// State when habits are loaded
class HabitsLoaded extends HabitState {
  final List<Habit> habits;
  
  const HabitsLoaded({required this.habits});
  
  @override
  List<Object?> get props => [habits];
}

/// State when a single habit is loaded
class HabitLoaded extends HabitState {
  final Habit habit;
  
  const HabitLoaded({required this.habit});
  
  @override
  List<Object?> get props => [habit];
}

/// State when habit logs are loaded
class HabitLogsLoaded extends HabitState {
  final List<HabitLog> habitLogs;
  
  const HabitLogsLoaded({required this.habitLogs});
  
  @override
  List<Object?> get props => [habitLogs];
}

/// State when a habit is created
class HabitCreated extends HabitState {
  final Habit habit;
  
  const HabitCreated({required this.habit});
  
  @override
  List<Object?> get props => [habit];
}

/// State when a habit is updated
class HabitUpdated extends HabitState {
  final Habit habit;
  
  const HabitUpdated({required this.habit});
  
  @override
  List<Object?> get props => [habit];
}

/// State when a habit is deleted
class HabitDeleted extends HabitState {}

/// State when a habit log is created
class HabitLogCreated extends HabitState {
  final HabitLog habitLog;
  
  const HabitLogCreated({required this.habitLog});
  
  @override
  List<Object?> get props => [habitLog];
}

/// State when a habit log is updated
class HabitLogUpdated extends HabitState {
  final HabitLog habitLog;
  
  const HabitLogUpdated({required this.habitLog});
  
  @override
  List<Object?> get props => [habitLog];
}

/// State when a habit log is deleted
class HabitLogDeleted extends HabitState {}

/// Error state
class HabitError extends HabitState {
  final String message;
  
  const HabitError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
