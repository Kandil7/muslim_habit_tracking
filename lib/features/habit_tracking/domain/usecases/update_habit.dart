import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Use case for updating an existing habit
class UpdateHabit {
  final HabitRepository repository;

  UpdateHabit(this.repository);

  /// Execute the use case
  Future<Either<Failure, Habit>> call(UpdateHabitParams params) async {
    return await repository.updateHabit(params.habit);
  }
}

/// Parameters for the UpdateHabit use case
class UpdateHabitParams extends Equatable {
  final Habit habit;

  const UpdateHabitParams({required this.habit});

  @override
  List<Object> get props => [habit];
}
