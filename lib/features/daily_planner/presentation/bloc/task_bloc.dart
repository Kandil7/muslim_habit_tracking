import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/usecases/add_task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/usecases/delete_task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/usecases/get_todays_tasks.dart';
import 'package:muslim_habbit/features/daily_planner/domain/usecases/mark_task_completed.dart';
import 'package:muslim_habbit/features/daily_planner/domain/usecases/update_task.dart';

import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
part 'task_event.dart';
part 'task_state.dart';
/// BLoC for managing task state
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTodaysTasks getTodaysTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final MarkTaskCompleted markTaskCompleted;

  TaskBloc({
    required this.getTodaysTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
    required this.markTaskCompleted,
  }) : super(TaskInitial()) {
    on<LoadTodaysTasks>(_onLoadTodaysTasks);
    on<AddTaskEvent>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<MarkTaskCompletedEvent>(_onMarkTaskCompleted);
    on<MarkTaskInProgressEvent>(_onMarkTaskInProgress);
    on<MarkTaskSkippedEvent>(_onMarkTaskSkipped);
  }

  /// Handle loading today's tasks
  Future<void> _onLoadTodaysTasks(
    LoadTodaysTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTodaysTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle adding a new task
  Future<void> _onAddTask(
    AddTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = await addTask(event.task);
      // Reload tasks to reflect the new addition
      final tasks = await getTodaysTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle updating a task
  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = await updateTask(event.task);
      // Reload tasks to reflect the update
      final tasks = await getTodaysTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle deleting a task
  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTask(event.id);
      // Reload tasks to reflect the deletion
      final tasks = await getTodaysTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle marking a task as completed
  Future<void> _onMarkTaskCompleted(
    MarkTaskCompletedEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final task = await markTaskCompleted(event.id);
      // Reload tasks to reflect the status change
      final tasks = await getTodaysTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle marking a task as in progress
  Future<void> _onMarkTaskInProgress(
    MarkTaskInProgressEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Implementation would update task status to in progress
    // This would typically involve calling an update use case
    try {
      // For now, we'll just reload the tasks
      final tasks = await getTodaysTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }

  /// Handle marking a task as skipped
  Future<void> _onMarkTaskSkipped(
    MarkTaskSkippedEvent event,
    Emitter<TaskState> emit,
  ) async {
    // Implementation would update task status to skipped
    // This would typically involve calling an update use case
    try {
      // For now, we'll just reload the tasks
      final tasks = await getTodaysTasks();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(message: e.toString()));
    }
  }
}