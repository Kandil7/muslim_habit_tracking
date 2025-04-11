import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/habit_log.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_data_source.dart';
import '../models/habit_model.dart';
import '../models/habit_log_model.dart';

/// Implementation of HabitRepository
class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  
  HabitRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, List<Habit>>> getHabits() async {
    try {
      final habits = await localDataSource.getHabits();
      return Right(habits);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, Habit>> getHabitById(String id) async {
    try {
      final habit = await localDataSource.getHabitById(id);
      return Right(habit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, Habit>> createHabit(Habit habit) async {
    try {
      final habitModel = HabitModel.fromEntity(habit);
      final createdHabit = await localDataSource.createHabit(habitModel);
      return Right(createdHabit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, Habit>> updateHabit(Habit habit) async {
    try {
      final habitModel = HabitModel.fromEntity(habit);
      final updatedHabit = await localDataSource.updateHabit(habitModel);
      return Right(updatedHabit);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteHabit(String id) async {
    try {
      await localDataSource.deleteHabit(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<HabitLog>>> getHabitLogs(String habitId) async {
    try {
      final logs = await localDataSource.getHabitLogs(habitId);
      return Right(logs);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<HabitLog>>> getHabitLogsByDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final logs = await localDataSource.getHabitLogsByDateRange(
        habitId,
        startDate,
        endDate,
      );
      return Right(logs);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, HabitLog>> createHabitLog(HabitLog habitLog) async {
    try {
      final habitLogModel = HabitLogModel.fromEntity(habitLog);
      final createdLog = await localDataSource.createHabitLog(habitLogModel);
      return Right(createdLog);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, HabitLog>> updateHabitLog(HabitLog habitLog) async {
    try {
      final habitLogModel = HabitLogModel.fromEntity(habitLog);
      final updatedLog = await localDataSource.updateHabitLog(habitLogModel);
      return Right(updatedLog);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteHabitLog(String id) async {
    try {
      await localDataSource.deleteHabitLog(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
