import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/prayer_time.dart';

/// Repository interface for PrayerTime feature
abstract class PrayerTimesRepository {
  /// Get prayer times by city
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesByCity({
    required String city,
    required String country,
    required int month,
    required int year,
  });
  
  /// Get prayer times by coordinates
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesByCoordinates({
    required double latitude,
    required double longitude,
    required int month,
    required int year,
  });
  
  /// Get prayer times for today
  Future<Either<Failure, PrayerTime>> getPrayerTimesForToday();
  
  /// Get prayer times for a specific date
  Future<Either<Failure, PrayerTime>> getPrayerTimesForDate(DateTime date);
  
  /// Save user location
  Future<Either<Failure, bool>> saveUserLocation({
    String? city,
    String? country,
    double? latitude,
    double? longitude,
  });
  
  /// Get user location
  Future<Either<Failure, Map<String, dynamic>>> getUserLocation();
}
