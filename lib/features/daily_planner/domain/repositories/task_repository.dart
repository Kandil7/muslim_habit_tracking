import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';

/// Repository interface for task management
abstract class TaskRepository {
  /// Get all tasks for a specific date
  Future<List<Task>> getTasksForDate(DateTime date);

  /// Get all tasks for a date range
  Future<List<Task>> getTasksForDateRange(DateTime startDate, DateTime endDate);

  /// Get a specific task by ID
  Future<Task?> getTaskById(String id);

  /// Add a new task
  Future<Task> addTask(Task task);

  /// Update an existing task
  Future<Task> updateTask(Task task);

  /// Delete a task
  Future<void> deleteTask(String id);

  /// Mark a task as completed
  Future<Task> markTaskAsCompleted(String id);

  /// Mark a task as in progress
  Future<Task> markTaskAsInProgress(String id);

  /// Mark a task as skipped
  Future<Task> markTaskAsSkipped(String id);

  /// Get tasks by category
  Future<List<Task>> getTasksByCategory(TaskCategory category);

  /// Get tasks by status
  Future<List<Task>> getTasksByStatus(TaskStatus status);

  /// Get overdue tasks
  Future<List<Task>> getOverdueTasks();

  /// Get recurring tasks
  Future<List<Task>> getRecurringTasks();

  /// Generate recurring tasks for a date
  Future<List<Task>> generateRecurringTasksForDate(DateTime date);
}