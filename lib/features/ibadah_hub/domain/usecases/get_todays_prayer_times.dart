import 'package:muslim_habbit/features/ibadah_hub/domain/entities/prayer_time.dart';
import 'package:muslim_habbit/features/ibadah_hub/domain/repositories/prayer_time_repository.dart';

/// Use case to get today's prayer times
class GetTodaysPrayerTimes {
  final PrayerTimeRepository repository;

  GetTodaysPrayerTimes(this.repository);

  /// Get all prayer times for today
  Future<List<PrayerTime>> call() async {
    final today = DateTime.now();
    return await repository.getPrayerTimesForDate(today);
  }
}