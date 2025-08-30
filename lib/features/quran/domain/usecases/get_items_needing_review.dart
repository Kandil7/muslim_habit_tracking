import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get items needing review today
class GetItemsNeedingReview {
  final MemorizationRepository repository;

  GetItemsNeedingReview(this.repository);

  /// Get items needing review today
  Future<Either<Failure, List<MemorizationItem>>> call() async {
    return await repository.getItemsNeedingReview();
  }
}