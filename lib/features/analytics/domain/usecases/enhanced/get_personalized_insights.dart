import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/analytics/domain/repositories/enhanced_analytics_repository.dart';

/// Use case to get personalized insights
class GetPersonalizedInsights {
  final EnhancedAnalyticsRepository repository;

  GetPersonalizedInsights(this.repository);

  /// Get personalized insights based on user data
  Future<Either<Failure, List<String>>> call(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await repository.getPersonalizedInsights(startDate, endDate);
  }
}