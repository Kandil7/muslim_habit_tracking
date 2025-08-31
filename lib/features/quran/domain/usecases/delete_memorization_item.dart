import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/memorization_repository.dart';

/// Use case to delete a memorization item
class DeleteMemorizationItem {
  final MemorizationRepository repository;

  DeleteMemorizationItem(this.repository);

  /// Delete a memorization item by ID
  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteMemorizationItem(id);
  }
}