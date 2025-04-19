import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/quran_bookmark.dart';
import '../entities/quran_reading_history.dart';

/// Repository interface for Quran feature
abstract class QuranRepository {
  /// Get all bookmarks
  Future<Either<Failure, List<QuranBookmark>>> getAllBookmarks();

  /// Add a bookmark
  Future<Either<Failure, QuranBookmark>> addBookmark(QuranBookmark bookmark);

  /// Update a bookmark
  Future<Either<Failure, QuranBookmark>> updateBookmark(QuranBookmark bookmark);

  /// Delete a bookmark
  Future<Either<Failure, void>> deleteBookmark(int id);

  /// Get all reading history entries
  Future<Either<Failure, List<QuranReadingHistory>>> getReadingHistory();

  /// Add a reading history entry
  Future<Either<Failure, QuranReadingHistory>> addReadingHistory(
    QuranReadingHistory history,
  );

  /// Clear reading history
  Future<Either<Failure, void>> clearReadingHistory();

  /// Get the last read position
  Future<Either<Failure, QuranReadingHistory?>> getLastReadPosition();

  /// Update the last read position
  Future<Either<Failure, QuranReadingHistory>> updateLastReadPosition(
    QuranReadingHistory history,
  );
}
