import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to unarchive a memorization item
class UnarchiveItem {
  final MemorizationRepository repository;

  UnarchiveItem(this.repository);

  /// Unarchive a memorization item
  Future<Either<Failure, MemorizationItem>> call(String itemId) async {
    return await repository.unarchiveItem(itemId);
  }
}