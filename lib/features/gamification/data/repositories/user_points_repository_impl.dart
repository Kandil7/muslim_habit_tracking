import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_points.dart';
import '../../domain/repositories/user_points_repository.dart';
import '../datasources/user_points_local_data_source.dart';

/// Implementation of UserPointsRepository
class UserPointsRepositoryImpl implements UserPointsRepository {
  final UserPointsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Creates a new UserPointsRepositoryImpl
  UserPointsRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserPoints>> getUserPoints() async {
    try {
      final userPoints = await localDataSource.getUserPoints();
      return Right(userPoints);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserPoints>> addPoints(int points, String reason) async {
    try {
      final userPoints = await localDataSource.addPoints(points, reason);
      return Right(userPoints);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserPoints>> spendPoints(int points, String reason) async {
    try {
      final userPoints = await localDataSource.spendPoints(points, reason);
      return Right(userPoints);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PointsEntry>>> getPointsHistory() async {
    try {
      final userPoints = await localDataSource.getUserPoints();
      return Right(userPoints.history);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserPoints>> resetPoints() async {
    try {
      final userPoints = await localDataSource.resetPoints();
      return Right(userPoints);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
