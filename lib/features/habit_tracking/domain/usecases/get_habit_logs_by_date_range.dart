import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/habit_log.dart';
import '../repositories/habit_repository.dart';

/// Use case for getting habit logs within a date range
class GetHabitLogsByDateRange {
  final HabitRepository repository;

  GetHabitLogsByDateRange(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<HabitLog>>> call(GetHabitLogsByDateRangeParams params) async {
    return await repository.getHabitLogsByDateRange(
      params.habitId,
      params.startDate,
      params.endDate,
    );
  }
}

/// Parameters for the GetHabitLogsByDateRange use case
class GetHabitLogsByDateRangeParams extends Equatable {
  final String habitId;
  final DateTime startDate;
  final DateTime endDate;

  const GetHabitLogsByDateRangeParams({
    required this.habitId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [habitId, startDate, endDate];
}
