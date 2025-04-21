import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/quran_reading_history.dart';
import '../../domain/repositories/quran_reading_history_repository.dart';
import '../datasources/quran_local_data_source.dart';
import '../models/quran_reading_history_model.dart';

/// Implementation of QuranReadingHistoryRepository
class QuranReadingHistoryRepositoryImpl implements QuranReadingHistoryRepository {
  final QuranLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Constructor
  QuranReadingHistoryRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

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
      final historyModel = QuranReadingHistoryModel(
        id: history.id,
        pageNumber: history.pageNumber,
        timestamp: history.timestamp,
      );
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
      final historyModel = QuranReadingHistoryModel(
        id: history.id,
        pageNumber: history.pageNumber,
        timestamp: history.timestamp,
      );
      final result = await localDataSource.updateLastReadPosition(historyModel);
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
