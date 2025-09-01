import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/analytics/domain/entities/enhanced/overall_stats.dart';
import 'package:muslim_habbit/features/analytics/domain/repositories/enhanced_analytics_repository.dart';

/// Use case to get overall statistics
class GetOverallStats {
  final EnhancedAnalyticsRepository repository;

  GetOverallStats(this.repository);

  /// Get overall statistics for a date range
  Future<Either<Failure, OverallStats>> call(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await repository.getOverallStats(startDate, endDate);
  }
}