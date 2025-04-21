import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_stats.dart';

/// Repository interface for analytics
abstract class AnalyticsRepository {
  /// Get statistics for all habits
  Future<Either<Failure, List<HabitStats>>> getAllHabitStats();

  /// Get statistics for a specific habit
  Future<Either<Failure, HabitStats>> getHabitStats(String habitId);

  /// Get statistics for habits within a date range
  Future<Either<Failure, List<HabitStats>>> getHabitStatsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get overall completion rate for all habits
  Future<Either<Failure, double>> getOverallCompletionRate();

  /// Get the most consistent habit
  Future<Either<Failure, HabitStats>> getMostConsistentHabit();

  /// Get the least consistent habit
  Future<Either<Failure, HabitStats>> getLeastConsistentHabit();
}
