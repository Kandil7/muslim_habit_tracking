import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get review history for a memorization item
class GetItemReviewHistory {
  final MemorizationRepository repository;

  GetItemReviewHistory(this.repository);

  /// Get review history for a memorization item
  Future<Either<Failure, List<DateTime>>> call(String itemId) async {
    return await repository.getItemReviewHistory(itemId);
  }
}