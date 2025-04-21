import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_reading_history.dart';
import '../repositories/quran_reading_history_repository.dart';

/// Parameters for updating the last read position
class UpdateLastReadPositionParams {
  /// Reading history entry to update
  final QuranReadingHistory history;

  /// Constructor
  const UpdateLastReadPositionParams({required this.history});
}

/// Use case for updating the last read position
class UpdateLastReadPosition implements UseCase<QuranReadingHistory, UpdateLastReadPositionParams> {
  /// Repository instance
  final QuranReadingHistoryRepository repository;

  /// Constructor
  const UpdateLastReadPosition(this.repository);

  @override
  Future<Either<Failure, QuranReadingHistory>> call(UpdateLastReadPositionParams params) async {
    return await repository.updateLastReadPosition(params.history);
  }
}
