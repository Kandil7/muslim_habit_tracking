import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get memorization items by surah number
class GetItemsBySurah {
  final MemorizationRepository repository;

  GetItemsBySurah(this.repository);

  /// Get memorization items by surah number
  Future<Either<Failure, List<MemorizationItem>>> call(int surahNumber) async {
    return await repository.getItemsBySurah(surahNumber);
  }
}