import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/habit_stats.dart';
import '../repositories/analytics_repository.dart';

/// Use case for getting the least consistent habit
class GetLeastConsistentHabit implements UseCase<HabitStats, NoParams> {
  final AnalyticsRepository repository;

  GetLeastConsistentHabit(this.repository);

  /// Execute the use case
  @override
  Future<Either<Failure, HabitStats>> call(NoParams params) async {
    return await repository.getLeastConsistentHabit();
  }
}
