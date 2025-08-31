import 'package:muslim_habbit/features/daily_planner/domain/entities/task.dart';
import 'package:muslim_habbit/features/daily_planner/domain/repositories/task_repository.dart';

/// Use case to add a new task
class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  /// Add a new task
  Future<Task> call(Task task) async {
    return await repository.addTask(task);
  }
}