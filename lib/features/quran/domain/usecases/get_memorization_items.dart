import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get all memorization items
class GetMemorizationItems {
  final MemorizationRepository repository;

  GetMemorizationItems(this.repository);

  /// Get all memorization items
  Future<Either<Failure, List<MemorizationItem>>> call() async {
    return await repository.getMemorizationItems();
  }
}