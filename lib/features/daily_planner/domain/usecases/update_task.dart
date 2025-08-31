import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/repositories/task_repository.dart';

/// Use case to update an existing task
class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  /// Update an existing task
  Future<Task> call(Task task) async {
    return await repository.updateTask(task);
  }
}