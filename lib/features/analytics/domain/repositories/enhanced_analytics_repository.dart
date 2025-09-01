import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/enhanced/overall_stats.dart';
import '../../../../core/error/failures.dart';

/// Repository interface for enhanced analytics
abstract class EnhancedAnalyticsRepository {
  /// Get overall statistics for a date range
  Future<Either<Failure, OverallStats>> getOverallStats(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get habit analytics for a date range
  Future<Either<Failure, HabitAnalytics>> getHabitAnalytics(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get Ibadah analytics for a date range
  Future<Either<Failure, IbadahAnalytics>> getIbadahAnalytics(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get skills analytics for a date range
  Future<Either<Failure, SkillsAnalytics>> getSkillsAnalytics(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get self-development analytics for a date range
  Future<Either<Failure, SelfDevelopmentAnalytics>> getSelfDevelopmentAnalytics(
    DateTime startDate,
    DateTime endDate,
  );

  /// Export enhanced analytics data
  Future<Either<Failure, String>> exportEnhancedAnalyticsData(
    DateTime startDate,
    DateTime endDate,
    String format,
  );

  /// Get personalized insights based on user data
  Future<Either<Failure, List<String>>> getPersonalizedInsights(
    DateTime startDate,
    DateTime endDate,
  );
}