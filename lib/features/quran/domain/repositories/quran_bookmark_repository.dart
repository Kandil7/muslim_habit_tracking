import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/quran_bookmark.dart';

/// Repository interface for Quran bookmark operations
abstract class QuranBookmarkRepository {
  /// Get all bookmarks
  Future<Either<Failure, List<QuranBookmark>>> getAllBookmarks();

  /// Add a bookmark
  Future<Either<Failure, QuranBookmark>> addBookmark(QuranBookmark bookmark);

  /// Update a bookmark
  Future<Either<Failure, QuranBookmark>> updateBookmark(QuranBookmark bookmark);

  /// Remove a bookmark
  Future<Either<Failure, void>> removeBookmark(int id);
}
