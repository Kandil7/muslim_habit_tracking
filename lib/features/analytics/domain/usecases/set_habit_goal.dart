import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/analytics_repository.dart';

/// Parameters for the SetHabitGoal use case
class SetHabitGoalParams {
  /// The habit ID
  final String habitId;
  
  /// The target streak (optional)
  final int? targetStreak;
  
  /// The target completion rate (optional)
  final double? targetCompletionRate;

  /// Constructor
  const SetHabitGoalParams({
    required this.habitId,
    this.targetStreak,
    this.targetCompletionRate,
  });
}

/// Use case for setting a goal for a habit
class SetHabitGoal implements UseCase<bool, SetHabitGoalParams> {
  final AnalyticsRepository repository;

  /// Constructor
  const SetHabitGoal(this.repository);

  @override
  Future<Either<Failure, bool>> call(SetHabitGoalParams params) async {
    return await repository.setHabitGoal(
      params.habitId,
      params.targetStreak,
      params.targetCompletionRate,
    );
  }
}
