import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_reading_history.dart';
import '../repositories/quran_reading_history_repository.dart';

/// Parameters for adding a reading history entry
class AddReadingHistoryParams {
  /// Reading history entry to add
  final QuranReadingHistory history;

  /// Constructor
  const AddReadingHistoryParams({required this.history});
}

/// Use case for adding a reading history entry
class AddReadingHistory implements UseCase<QuranReadingHistory, AddReadingHistoryParams> {
  /// Repository instance
  final QuranReadingHistoryRepository repository;

  /// Constructor
  const AddReadingHistory(this.repository);

  @override
  Future<Either<Failure, QuranReadingHistory>> call(AddReadingHistoryParams params) async {
    return await repository.addReadingHistory(params.history);
  }
}
