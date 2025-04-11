import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Use case for getting all habits
class GetHabits {
  final HabitRepository repository;

  GetHabits(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Habit>>> call() async {
    return await repository.getHabits();
  }
}
