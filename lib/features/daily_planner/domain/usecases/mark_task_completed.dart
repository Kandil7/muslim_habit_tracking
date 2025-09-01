import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/repositories/task_repository.dart';

/// Use case to mark a task as completed
class MarkTaskCompleted {
  final TaskRepository repository;

  MarkTaskCompleted(this.repository);

  /// Mark a task as completed
  Future<Task> call(String id) async {
    return await repository.markTaskAsCompleted(id);
  }
}