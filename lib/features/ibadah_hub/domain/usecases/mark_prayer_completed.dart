import 'package:muslim_habbit/features/ibadah_hub/domain/entities/prayer_time.dart';
import 'package:muslim_habbit/features/ibadah_hub/domain/repositories/prayer_time_repository.dart';

/// Use case to mark a prayer as completed
class MarkPrayerCompleted {
  final PrayerTimeRepository repository;

  MarkPrayerCompleted(this.repository);

  /// Mark a prayer as completed
  Future<PrayerTime> call(String id) async {
    return await repository.markPrayerAsCompleted(id);
  }
}