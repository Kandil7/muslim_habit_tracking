import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_points.dart';
import '../repositories/user_points_repository.dart';

/// Use case to get user points
class GetUserPoints implements UseCase<UserPoints, NoParams> {
  final UserPointsRepository repository;

  /// Creates a new GetUserPoints use case
  GetUserPoints(this.repository);

  @override
  Future<Either<Failure, UserPoints>> call(NoParams params) {
    return repository.getUserPoints();
  }
}
