import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get memorization items by status
class GetItemsByStatus {
  final MemorizationRepository repository;

  GetItemsByStatus(this.repository);

  /// Get memorization items by status
  Future<Either<Failure, List<MemorizationItem>>> call(MemorizationStatus status) async {
    return await repository.getItemsByStatus(status);
  }
}