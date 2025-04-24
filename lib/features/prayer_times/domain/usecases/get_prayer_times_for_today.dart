import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/prayer_time.dart';
import '../repositories/prayer_times_repository.dart';

/// Use case to get prayer times for today
class GetPrayerTimesForToday implements UseCase<PrayerTime, NoParams> {
  final PrayerTimesRepository repository;

  /// Creates a new GetPrayerTimesForToday use case
  GetPrayerTimesForToday(this.repository);

  @override
  Future<Either<Failure, PrayerTime>> call(NoParams params) {
    return repository.getPrayerTimesForToday();
  }
}
