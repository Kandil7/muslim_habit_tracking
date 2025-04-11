import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/prayer_time.dart';

/// Repository interface for prayer times
abstract class PrayerTimeRepository {
  /// Get prayer times for a specific date
  Future<Either<Failure, PrayerTime>> getPrayerTimeByDate(DateTime date);
  
  /// Get prayer times for a date range
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Update calculation method
  Future<Either<Failure, void>> updateCalculationMethod(String method);
  
  /// Get current calculation method
  Future<Either<Failure, String>> getCalculationMethod();
  
  /// Get available calculation methods
  Future<Either<Failure, Map<String, String>>> getAvailableCalculationMethods();
}
