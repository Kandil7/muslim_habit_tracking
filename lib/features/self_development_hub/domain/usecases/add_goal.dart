import 'package:muslim_habbit/features/self_development_hub/domain/entities/goal.dart';
import 'package:muslim_habbit/features/self_development_hub/domain/repositories/goal_repository.dart';

/// Use case to add a new goal
class AddGoal {
  final GoalRepository repository;

  AddGoal(this.repository);

  /// Add a new goal
  Future<Goal> call(Goal goal) async {
    return await repository.addGoal(goal);
  }
}