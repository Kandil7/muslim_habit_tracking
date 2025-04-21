import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quran_reading_history_repository.dart';

/// Use case for clearing all reading history
class ClearReadingHistory implements UseCase<void, NoParams> {
  /// Repository instance
  final QuranReadingHistoryRepository repository;

  /// Constructor
  const ClearReadingHistory(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearReadingHistory();
  }
}
