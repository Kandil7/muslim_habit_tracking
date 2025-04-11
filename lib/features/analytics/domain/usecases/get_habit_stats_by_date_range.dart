import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/habit_stats.dart';
import '../repositories/analytics_repository.dart';

/// Use case for getting statistics for habits within a date range
class GetHabitStatsByDateRange {
  final AnalyticsRepository repository;

  GetHabitStatsByDateRange(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<HabitStats>>> call(GetHabitStatsByDateRangeParams params) async {
    return await repository.getHabitStatsByDateRange(
      params.startDate,
      params.endDate,
    );
  }
}

/// Parameters for the GetHabitStatsByDateRange use case
class GetHabitStatsByDateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const GetHabitStatsByDateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [startDate, endDate];
}
