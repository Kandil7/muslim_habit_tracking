import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/habit_log.dart';
import '../repositories/habit_repository.dart';

/// Use case for creating a new habit log
class CreateHabitLog {
  final HabitRepository repository;

  CreateHabitLog(this.repository);

  /// Execute the use case
  Future<Either<Failure, HabitLog>> call(CreateHabitLogParams params) async {
    return await repository.createHabitLog(params.habitLog);
  }
}

/// Parameters for the CreateHabitLog use case
class CreateHabitLogParams extends Equatable {
  final HabitLog habitLog;

  const CreateHabitLogParams({required this.habitLog});

  @override
  List<Object> get props => [habitLog];
}
