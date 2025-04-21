import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_stats.dart';
import '../repositories/analytics_repository.dart';

/// Use case for getting statistics for a specific habit
class GetHabitStats {
  final AnalyticsRepository repository;

  GetHabitStats(this.repository);

  /// Execute the use case
  Future<Either<Failure, HabitStats>> call(GetHabitStatsParams params) async {
    return await repository.getHabitStats(params.habitId);
  }
}

/// Parameters for the GetHabitStats use case
class GetHabitStatsParams extends Equatable {
  final String habitId;

  const GetHabitStatsParams({required this.habitId});

  @override
  List<Object> get props => [habitId];
}
