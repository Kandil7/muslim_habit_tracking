import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/prayer_time.dart';
import '../repositories/prayer_time_repository.dart';

/// Use case for getting prayer times for a specific date
class GetPrayerTimeByDate {
  final PrayerTimeRepository repository;

  GetPrayerTimeByDate(this.repository);

  /// Execute the use case
  Future<Either<Failure, PrayerTime>> call(GetPrayerTimeByDateParams params) async {
    return await repository.getPrayerTimeByDate(params.date);
  }
}

/// Parameters for the GetPrayerTimeByDate use case
class GetPrayerTimeByDateParams extends Equatable {
  final DateTime date;

  const GetPrayerTimeByDateParams({required this.date});

  @override
  List<Object> get props => [date];
}
