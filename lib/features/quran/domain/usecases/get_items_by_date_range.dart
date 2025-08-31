import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get memorization items within a date range
class GetItemsByDateRange {
  final MemorizationRepository repository;

  GetItemsByDateRange(this.repository);

  /// Get memorization items within a date range
  Future<Either<Failure, List<MemorizationItem>>> call(DateTime start, DateTime end) async {
    return await repository.getItemsByDateRange(start, end);
  }
}