import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/analytics_repository.dart';

/// Use case for getting the overall completion rate for all habits
class GetOverallCompletionRate implements UseCase<double, NoParams> {
  final AnalyticsRepository repository;

  GetOverallCompletionRate(this.repository);

  /// Execute the use case
  @override
  Future<Either<Failure, double>> call(NoParams params) async {
    return await repository.getOverallCompletionRate();
  }
}
