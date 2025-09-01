import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/repositories/task_repository.dart';

/// Use case to get today's tasks
class GetTodaysTasks {
  final TaskRepository repository;

  GetTodaysTasks(this.repository);

  /// Get all tasks scheduled for today
  Future<List<Task>> call() async {
    final today = DateTime.now();
    return await repository.getTasksForDate(today);
  }
}