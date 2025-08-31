import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to reset progress of a memorization item
class ResetItemProgress {
  final MemorizationRepository repository;

  ResetItemProgress(this.repository);

  /// Reset progress of a memorization item
  Future<Either<Failure, MemorizationItem>> call(String itemId) async {
    return await repository.resetItemProgress(itemId);
  }
}