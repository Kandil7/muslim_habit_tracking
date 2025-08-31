part of 'task_bloc.dart';

/// Base event class for task management
abstract class TaskEvent {}

/// Event to load today's tasks
class LoadTodaysTasks extends TaskEvent {}

/// Event to add a new task
class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);
}

/// Event to update an existing task
class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent(this.task);
}

/// Event to delete a task
class DeleteTaskEvent extends TaskEvent {
  final String id;

  DeleteTaskEvent(this.id);
}

/// Event to mark a task as completed
class MarkTaskCompletedEvent extends TaskEvent {
  final String id;

  MarkTaskCompletedEvent(this.id);
}

/// Event to mark a task as in progress
class MarkTaskInProgressEvent extends TaskEvent {
  final String id;

  MarkTaskInProgressEvent(this.id);
}

/// Event to mark a task as skipped
class MarkTaskSkippedEvent extends TaskEvent {
  final String id;

  MarkTaskSkippedEvent(this.id);
}