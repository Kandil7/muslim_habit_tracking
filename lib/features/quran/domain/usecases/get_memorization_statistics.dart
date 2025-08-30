import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get memorization statistics
class GetMemorizationStatistics {
  final MemorizationRepository repository;

  GetMemorizationStatistics(this.repository);

  /// Get memorization statistics
  Future<Either<Failure, MemorizationStatistics>> call() async {
    return await repository.getMemorizationStatistics();
  }
}