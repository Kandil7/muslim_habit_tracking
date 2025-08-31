import 'package:hive/hive.dart';
import 'package:muslim_habbit/features/daily_planner/data/models/task_model.dart';

/// Local data source for task management using Hive
class TaskLocalDataSource {
  static const String _boxName = 'tasks';
  late Box<Map> _box;

  /// Initialize the data source
  Future<void> init() async {
    _box = await Hive.openBox<Map>(_boxName);
  }

  /// Get all tasks for a specific date
  Future<List<TaskModel>> getTasksForDate(DateTime date) async {
    final tasks = <TaskModel>[];
    final keys = _box.keys;

    for (final key in keys) {
      final json = _box.get(key);
      if (json != null) {
        final task = TaskModel.fromJson(Map<String, dynamic>.from(json));
        // Check if the task is scheduled for the given date
        if (task.scheduledDate.year == date.year &&
            task.scheduledDate.month == date.month &&
            task.scheduledDate.day == date.day) {
          tasks.add(task);
        }
      }
    }

    return tasks;
  }

  /// Get all tasks for a date range
  Future<List<TaskModel>> getTasksForDateRange(
      DateTime startDate, DateTime endDate) async {
    final tasks = <TaskModel>[];
    final keys = _box.keys;

    for (final key in keys) {
      final json = _box.get(key);
      if (json != null) {
        final task = TaskModel.fromJson(Map<String, dynamic>.from(json));
        // Check if the task is scheduled within the date range
        if (task.scheduledDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
            task.scheduledDate.isBefore(endDate.add(const Duration(days: 1)))) {
          tasks.add(task);
        }
      }
    }

    return tasks;
  }

  /// Get a specific task by ID
  Future<TaskModel?> getTaskById(String id) async {
    final json = _box.get(id);
    if (json != null) {
      return TaskModel.fromJson(Map<String, dynamic>.from(json));
    }
    return null;
  }

  /// Add a new task
  Future<TaskModel> addTask(TaskModel task) async {
    await _box.put(task.id, task.toJson());
    return task;
  }

  /// Update an existing task
  Future<TaskModel> updateTask(TaskModel task) async {
    await _box.put(task.id, task.toJson());
    return task;
  }

  /// Delete a task
  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  /// Get tasks by category
  Future<List<TaskModel>> getTasksByCategory(String category) async {
    final tasks = <TaskModel>[];
    final keys = _box.keys;

    for (final key in keys) {
      final json = _box.get(key);
      if (json != null) {
        final task = TaskModel.fromJson(Map<String, dynamic>.from(json));
        if (_categoryToString(task.category) == category) {
          tasks.add(task);
        }
      }
    }

    return tasks;
  }

  /// Get tasks by status
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    final tasks = <TaskModel>[];
    final keys = _box.keys;

    for (final key in keys) {
      final json = _box.get(key);
      if (json != null) {
        final task = TaskModel.fromJson(Map<String, dynamic>.from(json));
        if (_statusToString(task.status) == status) {
          tasks.add(task);
        }
      }
    }

    return tasks;
  }

  /// Get overdue tasks
  Future<List<TaskModel>> getOverdueTasks() async {
    final tasks = <TaskModel>[];
    final now = DateTime.now();
    final keys = _box.keys;

    for (final key in keys) {
      final json = _box.get(key);
      if (json != null) {
        final task = TaskModel.fromJson(Map<String, dynamic>.from(json));
        if (task.dueDate != null &&
            task.dueDate!.isBefore(now) &&
            task.status != TaskStatus.completed) {
          tasks.add(task);
        }
      }
    }

    return tasks;
  }

  /// Get recurring tasks
  Future<List<TaskModel>> getRecurringTasks() async {
    final tasks = <TaskModel>[];
    final keys = _box.keys;

    for (final key in keys) {
      final json = _box.get(key);
      if (json != null) {
        final task = TaskModel.fromJson(Map<String, dynamic>.from(json));
        if (task.isRecurring) {
          tasks.add(task);
        }
      }
    }

    return tasks;
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