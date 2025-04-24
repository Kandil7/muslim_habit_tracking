import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_points.dart';
import '../repositories/user_points_repository.dart';

/// Use case to add points to the user's total
class AddPoints implements UseCase<UserPoints, AddPointsParams> {
  final UserPointsRepository repository;

  /// Creates a new AddPoints use case
  AddPoints(this.repository);

  @override
  Future<Either<Failure, UserPoints>> call(AddPointsParams params) {
    return repository.addPoints(params.points, params.reason);
  }
}

/// Parameters for AddPoints use case
class AddPointsParams extends Equatable {
  final int points;
  final String reason;

  /// Creates new AddPointsParams
  const AddPointsParams({
    required this.points,
    required this.reason,
  });

  @override
  List<Object> get props => [points, reason];
}
