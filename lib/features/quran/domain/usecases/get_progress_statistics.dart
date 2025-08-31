import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get progress statistics for a specific period
class GetProgressStatistics {
  final MemorizationRepository repository;

  GetProgressStatistics(this.repository);

  /// Get progress statistics for a specific period
  Future<Either<Failure, ProgressStatistics>> call(DateTime start, DateTime end) async {
    return repository.getProgressStatistics(start, end);
  }
}