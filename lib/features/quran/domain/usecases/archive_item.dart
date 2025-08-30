import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to archive a memorization item
class ArchiveItem {
  final MemorizationRepository repository;

  ArchiveItem(this.repository);

  /// Archive a memorization item
  Future<Either<Failure, MemorizationItem>> call(String itemId) async {
    return await repository.archiveItem(itemId);
  }
}