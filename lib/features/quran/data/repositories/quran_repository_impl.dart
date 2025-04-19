import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/quran_bookmark.dart';
import '../../domain/entities/quran_reading_history.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';
import '../models/quran_bookmark_model.dart';
import '../models/quran_reading_history_model.dart';

/// Implementation of QuranRepository
class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  QuranRepositoryImpl({
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
      final bookmarkModel = QuranBookmarkModel.fromEntity(bookmark);
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
      final bookmarkModel = QuranBookmarkModel.fromEntity(bookmark);
      final result = await localDataSource.updateBookmark(bookmarkModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBookmark(int id) async {
    try {
      await localDataSource.deleteBookmark(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<QuranReadingHistory>>> getReadingHistory() async {
    try {
      final history = await localDataSource.getReadingHistory();
      return Right(history);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuranReadingHistory>> addReadingHistory(
    QuranReadingHistory history,
  ) async {
    try {
      final historyModel = QuranReadingHistoryModel.fromEntity(history);
      final result = await localDataSource.addReadingHistory(historyModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearReadingHistory() async {
    try {
      await localDataSource.clearReadingHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuranReadingHistory?>> getLastReadPosition() async {
    try {
      final lastPosition = await localDataSource.getLastReadPosition();
      return Right(lastPosition);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuranReadingHistory>> updateLastReadPosition(
    QuranReadingHistory history,
  ) async {
    try {
      final historyModel = QuranReadingHistoryModel.fromEntity(history);
      final result = await localDataSource.updateLastReadPosition(historyModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
