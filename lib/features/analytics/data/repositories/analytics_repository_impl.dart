import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/habit_stats.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_data_source.dart';

/// Implementation of AnalyticsRepository
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsDataSource dataSource;

  AnalyticsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<HabitStats>>> getAllHabitStats() async {
    try {
      final habitStats = await dataSource.getAllHabitStats();
      return Right(habitStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, HabitStats>> getHabitStats(String habitId) async {
    try {
      final habitStats = await dataSource.getHabitStats(habitId);
      return Right(habitStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<HabitStats>>> getHabitStatsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final habitStats = await dataSource.getHabitStatsByDateRange(
        startDate,
        endDate,
      );
      return Right(habitStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, double>> getOverallCompletionRate() async {
    try {
      final completionRate = await dataSource.getOverallCompletionRate();
      return Right(completionRate);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, HabitStats>> getMostConsistentHabit() async {
    try {
      final habitStats = await dataSource.getMostConsistentHabit();
      return Right(habitStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, HabitStats>> getLeastConsistentHabit() async {
    try {
      final habitStats = await dataSource.getLeastConsistentHabit();
      return Right(habitStats);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> exportAnalyticsData(String format) async {
    try {
      final filePath = await dataSource.exportAnalyticsData(format);
      return Right(filePath);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> setHabitGoal(
    String habitId,
    int? targetStreak,
    double? targetCompletionRate,
  ) async {
    try {
      final result = await dataSource.setHabitGoal(
        habitId,
        targetStreak,
        targetCompletionRate,
      );
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
