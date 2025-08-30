import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get overdue memorization items
class GetOverdueItems {
  final MemorizationRepository repository;

  GetOverdueItems(this.repository);

  /// Get overdue memorization items
  Future<Either<Failure, List<MemorizationItem>>> call() async {
    return await repository.getOverdueItems();
  }
}