import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/entities/quran.dart';
import '../../domain/entities/reading_history.dart';
import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_data_source.dart';
import '../models/bookmark_model.dart';
import '../models/reading_history_model.dart';

/// Implementation of QuranRepository
class QuranRepositoryImpl implements QuranRepository {
  final QuranLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  QuranRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Quran>>> getAllSurahs() async {
    try {
      final surahs = await localDataSource.getAllSurahs();
      return Right(surahs);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Quran>> getSurahById(int id) async {
    try {
      final surah = await localDataSource.getSurahById(id);
      return Right(surah);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<QuranBookmark>>> getBookmarks() async {
    try {
      final bookmarks = await localDataSource.getBookmarks();
      return Right(bookmarks);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuranBookmark>> addBookmark(QuranBookmark bookmark) async {
    try {
      final bookmarkModel = QuranBookmarkModel.fromEntity(bookmark);
      final result = await localDataSource.addBookmark(bookmarkModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> removeBookmark(String bookmarkId) async {
    try {
      final result = await localDataSource.removeBookmark(bookmarkId);
      return Right(result);
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
  Future<Either<Failure, QuranReadingHistory>> addReadingHistory(QuranReadingHistory history) async {
    try {
      final historyModel = QuranReadingHistoryModel.fromEntity(history);
      final result = await localDataSource.addReadingHistory(historyModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> clearReadingHistory() async {
    try {
      final result = await localDataSource.clearReadingHistory();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, QuranReadingHistory?>> getLastReadPosition() async {
    try {
      final position = await localDataSource.getLastReadPosition();
      return Right(position);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> updateLastReadPosition(QuranReadingHistory history) async {
    try {
      final historyModel = QuranReadingHistoryModel.fromEntity(history);
      final result = await localDataSource.updateLastReadPosition(historyModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
