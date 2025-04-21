import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/habit_repository.dart';

/// Use case for deleting a habit
class DeleteHabit {
  final HabitRepository repository;

  DeleteHabit(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(DeleteHabitParams params) async {
    return await repository.deleteHabit(params.id);
  }
}

/// Parameters for the DeleteHabit use case
class DeleteHabitParams extends Equatable {
  final String id;

  const DeleteHabitParams({required this.id});

  @override
  List<Object> get props => [id];
}
