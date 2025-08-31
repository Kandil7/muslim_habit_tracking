import 'package:muslim_habbit/features/daily_planner/data/datasources/task_local_data_source.dart';
import 'package:muslim_habbit/features/daily_planner/data/models/task_model.dart';
import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/repositories/task_repository.dart';

/// Implementation of TaskRepository using local data source
class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<List<Task>> getTasksForDate(DateTime date) async {
    final tasks = await localDataSource.getTasksForDate(date);
    return tasks;
  }

  @override
  Future<List<Task>> getTasksForDateRange(DateTime startDate, DateTime endDate) async {
    final tasks = await localDataSource.getTasksForDateRange(startDate, endDate);
    return tasks;
  }

  @override
  Future<Task?> getTaskById(String id) async {
    final task = await localDataSource.getTaskById(id);
    return task;
  }

  @override
  Future<Task> addTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final addedTask = await localDataSource.addTask(taskModel);
    return addedTask;
  }

  @override
  Future<Task> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final updatedTask = await localDataSource.updateTask(taskModel);
    return updatedTask;
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<Task> markTaskAsCompleted(String id) async {
    final task = await localDataSource.getTaskById(id);
    if (task != null) {
      final completedTask = task.copyWith(
        status: TaskStatus.completed,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final updatedTaskModel = TaskModel.fromEntity(completedTask);
      await localDataSource.updateTask(updatedTaskModel);
      return completedTask;
    }
    throw Exception('Task not found');
  }

  @override
  Future<Task> markTaskAsInProgress(String id) async {
    final task = await localDataSource.getTaskById(id);
    if (task != null) {
      final inProgressTask = task.copyWith(
        status: TaskStatus.inProgress,
        updatedAt: DateTime.now(),
      );
      final updatedTaskModel = TaskModel.fromEntity(inProgressTask);
      await localDataSource.updateTask(updatedTaskModel);
      return inProgressTask;
    }
    throw Exception('Task not found');
  }

  @override
  Future<Task> markTaskAsSkipped(String id) async {
    final task = await localDataSource.getTaskById(id);
    if (task != null) {
      final skippedTask = task.copyWith(
        status: TaskStatus.skipped,
        updatedAt: DateTime.now(),
      );
      final updatedTaskModel = TaskModel.fromEntity(skippedTask);
      await localDataSource.updateTask(updatedTaskModel);
      return skippedTask;
    }
    throw Exception('Task not found');
  }

  @override
  Future<List<Task>> getTasksByCategory(TaskCategory category) async {
    final tasks = await localDataSource.getTasksByCategory(_categoryToString(category));
    return tasks;
  }

  @override
  Future<List<Task>> getTasksByStatus(TaskStatus status) async {
    final tasks = await localDataSource.getTasksByStatus(_statusToString(status));
    return tasks;
  }

  @override
  Future<List<Task>> getOverdueTasks() async {
    final tasks = await localDataSource.getOverdueTasks();
    return tasks;
  }

  @override
  Future<List<Task>> getRecurringTasks() async {
    final tasks = await localDataSource.getRecurringTasks();
    return tasks;
  }

  @override
  Future<List<Task>> generateRecurringTasksForDate(DateTime date) async {
    // This would be implemented to generate recurring tasks for a specific date
    // For now, we'll return an empty list
    return [];
  }

  /// Convert category to string
  String _categoryToString(TaskCategory category) {
    switch (category) {
      case TaskCategory.ibadah:
        return 'ibadah';
      case TaskCategory.programming:
        return 'programming';
      case TaskCategory.selfDevelopment:
        return 'selfDevelopment';
      case TaskCategory.other:
        return 'other';
    }
  }

  /// Convert status to string
  String _statusToString(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.inProgress:
        return 'inProgress';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.skipped:
        return 'skipped';
      case TaskStatus.overdue:
        return 'overdue';
    }
  }
}