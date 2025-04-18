import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/habit_stats.dart';
import '../repositories/analytics_repository.dart';

/// Use case for getting statistics for all habits
class GetAllHabitStats implements UseCase<List<HabitStats>, NoParams> {
  final AnalyticsRepository repository;

  GetAllHabitStats(this.repository);

  /// Execute the use case
  @override
  Future<Either<Failure, List<HabitStats>>> call(NoParams params) async {
    return await repository.getAllHabitStats();
  }
}
