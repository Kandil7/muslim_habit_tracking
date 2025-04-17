import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/bookmark.dart';
import '../entities/quran.dart';
import '../entities/reading_history.dart';

/// Repository interface for Quran
abstract class QuranRepository {
  /// Get all surahs
  Future<Either<Failure, List<Quran>>> getAllSurahs();
  
  /// Get surah by ID
  Future<Either<Failure, Quran>> getSurahById(int id);
  
  /// Get bookmarked surahs
  Future<Either<Failure, List<QuranBookmark>>> getBookmarks();
  
  /// Add bookmark
  Future<Either<Failure, QuranBookmark>> addBookmark(QuranBookmark bookmark);
  
  /// Remove bookmark
  Future<Either<Failure, bool>> removeBookmark(String bookmarkId);
  
  /// Get reading history
  Future<Either<Failure, List<QuranReadingHistory>>> getReadingHistory();
  
  /// Add reading history
  Future<Either<Failure, QuranReadingHistory>> addReadingHistory(QuranReadingHistory history);
  
  /// Clear reading history
  Future<Either<Failure, bool>> clearReadingHistory();
  
  /// Get last read position
  Future<Either<Failure, QuranReadingHistory?>> getLastReadPosition();
  
  /// Update last read position
  Future<Either<Failure, bool>> updateLastReadPosition(QuranReadingHistory history);
}
