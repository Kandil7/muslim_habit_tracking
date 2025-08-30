import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get detailed statistics for charts and graphs
class GetDetailedStatistics {
  final MemorizationRepository repository;

  GetDetailedStatistics(this.repository);

  /// Get detailed statistics for charts and graphs
  Future<Either<Failure, DetailedMemorizationStatistics>> call() async {
    return await repository.getDetailedStatistics();
  }
}