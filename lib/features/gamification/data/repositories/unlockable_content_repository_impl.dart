import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/unlockable_content.dart';
import '../../domain/repositories/unlockable_content_repository.dart';
import '../../domain/repositories/user_points_repository.dart';
import '../datasources/unlockable_content_local_data_source.dart';

/// Implementation of UnlockableContentRepository
class UnlockableContentRepositoryImpl implements UnlockableContentRepository {
  final UnlockableContentLocalDataSource localDataSource;
  final UserPointsRepository userPointsRepository;
  final NetworkInfo networkInfo;

  /// Creates a new UnlockableContentRepositoryImpl
  UnlockableContentRepositoryImpl({
    required this.localDataSource,
    required this.userPointsRepository,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UnlockableContent>>> getAllContent() async {
    try {
      final content = await localDataSource.getAllContent();
      return Right(content);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<UnlockableContent>>> getContentByType(String contentType) async {
    try {
      final content = await localDataSource.getContentByType(contentType);
      return Right(content);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<UnlockableContent>>> getUnlockedContent() async {
    try {
      final content = await localDataSource.getUnlockedContent();
      return Right(content);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UnlockableContent>> getContentById(String id) async {
    try {
      final content = await localDataSource.getContentById(id);
      return Right(content);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UnlockableContent>> unlockContent(String id) async {
    try {
      // Get the content
      final contentResult = await getContentById(id);
      
      return contentResult.fold(
        (failure) => Left(failure),
        (content) async {
          // Check if already unlocked
          if (content.isUnlocked) {
            return Right(content);
          }
          
          // Check if user has enough points
          final canUnlockResult = await canUnlockContent(id, 0);
          
          return canUnlockResult.fold(
            (failure) => Left(failure),
            (canUnlock) async {
              if (!canUnlock) {
                return Left(CacheFailure(message: 'Not enough points to unlock this content'));
              }
              
              // Spend points
              final spendResult = await userPointsRepository.spendPoints(
                content.pointsRequired,
                'Unlocked ${content.name}',
              );
              
              return spendResult.fold(
                (failure) => Left(failure),
                (_) async {
                  // Unlock the content
                  final unlockedContent = await localDataSource.unlockContent(id);
                  return Right(unlockedContent);
                },
              );
            },
          );
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> canUnlockContent(String id, int userPoints) async {
    try {
      // Get the content
      final contentResult = await getContentById(id);
      
      return contentResult.fold(
        (failure) => Left(failure),
        (content) async {
          // If already unlocked, return true
          if (content.isUnlocked) {
            return const Right(true);
          }
          
          // If userPoints is provided, use it
          if (userPoints > 0) {
            return Right(userPoints >= content.pointsRequired);
          }
          
          // Otherwise, get user points from repository
          final userPointsResult = await userPointsRepository.getUserPoints();
          
          return userPointsResult.fold(
            (failure) => Left(failure),
            (points) {
              return Right(points.totalPoints >= content.pointsRequired);
            },
          );
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
