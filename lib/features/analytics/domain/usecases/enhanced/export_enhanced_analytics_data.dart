import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/analytics/domain/repositories/enhanced_analytics_repository.dart';

/// Use case to export enhanced analytics data
class ExportEnhancedAnalyticsData {
  final EnhancedAnalyticsRepository repository;

  ExportEnhancedAnalyticsData(this.repository);

  /// Export enhanced analytics data
  Future<Either<Failure, String>> call(
    DateTime startDate,
    DateTime endDate,
    String format,
  ) async {
    return await repository.exportEnhancedAnalyticsData(startDate, endDate, format);
  }
}