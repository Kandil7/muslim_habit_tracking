import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/prayer_time.dart';
import '../repositories/prayer_time_repository.dart';

/// Use case for getting prayer times for a date range
class GetPrayerTimesByDateRange {
  final PrayerTimeRepository repository;

  GetPrayerTimesByDateRange(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<PrayerTime>>> call(GetPrayerTimesByDateRangeParams params) async {
    return await repository.getPrayerTimesByDateRange(
      params.startDate,
      params.endDate,
    );
  }
}

/// Parameters for the GetPrayerTimesByDateRange use case
class GetPrayerTimesByDateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const GetPrayerTimesByDateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}
