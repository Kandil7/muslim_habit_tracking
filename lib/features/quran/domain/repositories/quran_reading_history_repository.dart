import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/quran_reading_history.dart';

/// Repository interface for Quran reading history operations
abstract class QuranReadingHistoryRepository {
  /// Get all reading history entries
  Future<Either<Failure, List<QuranReadingHistory>>> getReadingHistory();

  /// Add a reading history entry
  Future<Either<Failure, QuranReadingHistory>> addReadingHistory(
    QuranReadingHistory history,
  );

  /// Clear all reading history
  Future<Either<Failure, void>> clearReadingHistory();

  /// Get the last read position
  Future<Either<Failure, QuranReadingHistory?>> getLastReadPosition();

  /// Update the last read position
  Future<Either<Failure, QuranReadingHistory>> updateLastReadPosition(
    QuranReadingHistory history,
  );
}
