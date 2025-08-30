import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to mark an item as reviewed
class MarkItemAsReviewed {
  final MemorizationRepository repository;

  MarkItemAsReviewed(this.repository);

  /// Mark an item as reviewed
  Future<Either<Failure, MemorizationItem>> call(String itemId) async {
    return await repository.markItemAsReviewed(itemId);
  }
}