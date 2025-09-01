part of 'task_bloc.dart';

/// Base state class for task management
abstract class TaskState {}

/// Initial state
class TaskInitial extends TaskState {}

/// Loading state
class TaskLoading extends TaskState {}

/// Loaded state with tasks
class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded({required this.tasks});
}

/// Error state
class TaskError extends TaskState {
  final String message;

  TaskError({required this.message});
}