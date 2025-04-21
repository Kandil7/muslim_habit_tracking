import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_reading_history.dart';
import '../repositories/quran_reading_history_repository.dart';

/// Use case for getting the last read position
class GetLastReadPosition implements UseCase<QuranReadingHistory?, NoParams> {
  /// Repository instance
  final QuranReadingHistoryRepository repository;

  /// Constructor
  const GetLastReadPosition(this.repository);

  @override
  Future<Either<Failure, QuranReadingHistory?>> call(NoParams params) async {
    return await repository.getLastReadPosition();
  }
}
