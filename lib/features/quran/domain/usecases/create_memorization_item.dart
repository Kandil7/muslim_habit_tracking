import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to create a new memorization item
class CreateMemorizationItem {
  final MemorizationRepository repository;

  CreateMemorizationItem(this.repository);

  /// Create a new memorization item
  Future<Either<Failure, MemorizationItem>> call(
      MemorizationItem item) async {
    return await repository.createMemorizationItem(item);
  }
}