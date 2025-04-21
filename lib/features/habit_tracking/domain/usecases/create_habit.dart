import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

/// Use case for creating a new habit
class CreateHabit {
  final HabitRepository repository;

  CreateHabit(this.repository);

  /// Execute the use case
  Future<Either<Failure, Habit>> call(CreateHabitParams params) async {
    return await repository.createHabit(params.habit);
  }
}

/// Parameters for the CreateHabit use case
class CreateHabitParams extends Equatable {
  final Habit habit;

  const CreateHabitParams({required this.habit});

  @override
  List<Object> get props => [habit];
}
