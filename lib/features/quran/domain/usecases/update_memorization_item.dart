import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to update an existing memorization item
class UpdateMemorizationItem {
  final MemorizationRepository repository;

  UpdateMemorizationItem(this.repository);

  /// Update an existing memorization item
  Future<Either<Failure, MemorizationItem>> call(
      MemorizationItem item) async {
    return await repository.updateMemorizationItem(item);
  }
}