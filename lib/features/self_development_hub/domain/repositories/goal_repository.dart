import 'package:muslim_habbit/features/self_development_hub/domain/entities/goal.dart';

/// Repository interface for goal management
abstract class GoalRepository {
  /// Add a new goal
  Future<Goal> addGoal(Goal goal);

  /// Get all goals
  Future<List<Goal>> getAllGoals();

  /// Get goal by ID
  Future<Goal?> getGoalById(String id);

  /// Update goal
  Future<Goal> updateGoal(Goal goal);

  /// Delete goal
  Future<void> deleteGoal(String id);

  /// Get goals by area
  Future<List<Goal>> getGoalsByArea(GoalArea area);

  /// Get goals by status
  Future<List<Goal>> getGoalsByStatus(GoalStatus status);

  /// Get goals by type
  Future<List<Goal>> getGoalsByType(GoalType type);

  /// Update goal progress
  Future<Goal> updateGoalProgress(String id, int newValue);

  /// Mark goal as completed
  Future<Goal> markGoalAsCompleted(String id);

  /// Get overdue goals
  Future<List<Goal>> getOverdueGoals();

  /// Get goal statistics
  Future<GoalStatistics> getGoalStatistics();
}

/// Class to hold goal statistics
class GoalStatistics {
  final int totalGoals;
  final int completedGoals;
  final Map<GoalArea, int> goalsByArea;
  final Map<GoalStatus, int> goalsByStatus;
  final int overdueGoals;
  final double completionRate;

  GoalStatistics({
    required this.totalGoals,
    required this.completedGoals,
    required this.goalsByArea,
    required this.goalsByStatus,
    required this.overdueGoals,
    required this.completionRate,
  });
}