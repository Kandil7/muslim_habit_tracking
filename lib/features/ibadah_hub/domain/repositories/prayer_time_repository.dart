import 'package:muslim_habbit/features/ibadah_hub/domain/entities/prayer_time.dart';

/// Repository interface for prayer time management
abstract class PrayerTimeRepository {
  /// Get prayer times for a specific date
  Future<List<PrayerTime>> getPrayerTimesForDate(DateTime date);

  /// Get next prayer time
  Future<PrayerTime?> getNextPrayerTime();

  /// Get prayer time by type for a specific date
  Future<PrayerTime?> getPrayerTimeByType(PrayerType type, DateTime date);

  /// Update prayer time
  Future<PrayerTime> updatePrayerTime(PrayerTime prayerTime);

  /// Mark prayer as completed
  Future<PrayerTime> markPrayerAsCompleted(String id);

  /// Get prayer history
  Future<List<PrayerTime>> getPrayerHistory(DateTime startDate, DateTime endDate);
}