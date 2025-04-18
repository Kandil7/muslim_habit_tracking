import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/habit_stats.dart';
import '../repositories/analytics_repository.dart';

/// Use case for getting the most consistent habit
class GetMostConsistentHabit implements UseCase<HabitStats, NoParams> {
  final AnalyticsRepository repository;

  GetMostConsistentHabit(this.repository);

  /// Execute the use case
  @override
  Future<Either<Failure, HabitStats>> call(NoParams params) async {
    return await repository.getMostConsistentHabit();
  }
}
