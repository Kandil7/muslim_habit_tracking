import 'package:muslim_habbit/features/daily_planner/domain/repositories/task_repository.dart';

/// Use case to delete a task
class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  /// Delete a task by ID
  Future<void> call(String id) async {
    return await repository.deleteTask(id);
  }
}