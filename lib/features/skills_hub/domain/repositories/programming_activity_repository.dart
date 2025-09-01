import 'package:muslim_habbit/features/skills_hub/domain/entities/programming_activity.dart';

/// Repository interface for programming activity management
abstract class ProgrammingActivityRepository {
  /// Add a new programming activity
  Future<ProgrammingActivity> addActivity(ProgrammingActivity activity);

  /// Get programming activities for a date range
  Future<List<ProgrammingActivity>> getActivitiesForDateRange(
      DateTime startDate, DateTime endDate);

  /// Get programming activity by ID
  Future<ProgrammingActivity?> getActivityById(String id);

  /// Update programming activity
  Future<ProgrammingActivity> updateActivity(ProgrammingActivity activity);

  /// Delete programming activity
  Future<void> deleteActivity(String id);

  /// Get activities by type
  Future<List<ProgrammingActivity>> getActivitiesByType(ProgrammingActivityType type);

  /// Get activity statistics
  Future<ActivityStatistics> getActivityStatistics();
}

/// Class to hold activity statistics
class ActivityStatistics {
  final int totalActivities;
  final Duration totalTimeSpent;
  final Map<ProgrammingActivityType, int> activitiesByType;
  final Map<int, int> activitiesByDifficulty; // difficulty -> count
  final DateTime? lastActivityDate;

  ActivityStatistics({
    required this.totalActivities,
    required this.totalTimeSpent,
    required this.activitiesByType,
    required this.activitiesByDifficulty,
    this.lastActivityDate,
  });
}