import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/memorization_repository.dart';
import '../entities/streak_statistics.dart';

/// Use case to get streak statistics
class GetStreakStatistics {
  final MemorizationRepository repository;

  GetStreakStatistics(this.repository);

  /// Get streak statistics
  Future<Either<Failure, StreakStatistics>> call() async {
    return await repository.getStreakStatistics();
  }
}