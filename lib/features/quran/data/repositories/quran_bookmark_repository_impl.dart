import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/repositories/quran_bookmark_repository.dart';
import '../datasources/quran_local_data_source.dart';
import '../models/quran_bookmark_model.dart';

/// Implementation of QuranBookmarkRepository
class QuranBookmarkRepositoryImpl implements QuranBookmarkRepository {
  final QuranLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Constructor
  QuranBookmarkRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<QuranBookmark>>> getAllBookmarks() async {
    try {
      final bookmarks = await localDataSource.getAllBookmarks();
      return Right(bookmarks);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuranBookmark>> addBookmark(
    QuranBookmark bookmark,
  ) async {
    try {
      final bookmarkModel = QuranBookmarkModel(
        id: bookmark.id,
        page: bookmark.page,
        surahName: bookmark.surahName,
        ayahNumber: bookmark.ayahNumber,
        title: bookmark.title,
        timestamp: bookmark.timestamp,
      );
      final result = await localDataSource.addBookmark(bookmarkModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuranBookmark>> updateBookmark(
    QuranBookmark bookmark,
  ) async {
    try {
      final bookmarkModel = QuranBookmarkModel(
        id: bookmark.id,
        page: bookmark.page,
        surahName: bookmark.surahName,
        ayahNumber: bookmark.ayahNumber,
        title: bookmark.title,
        timestamp: bookmark.timestamp,
      );
      final result = await localDataSource.updateBookmark(bookmarkModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark(int id) async {
    try {
      await localDataSource.removeBookmark(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
