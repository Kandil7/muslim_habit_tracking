import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/badge.dart';
import '../../domain/repositories/badge_repository.dart';
import '../datasources/badge_local_data_source.dart';
import '../models/badge_model.dart';

/// Implementation of BadgeRepository
class BadgeRepositoryImpl implements BadgeRepository {
  final BadgeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Creates a new BadgeRepositoryImpl
  BadgeRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Badge>>> getAllBadges() async {
    try {
      final badges = await localDataSource.getAllBadges();
      return Right(badges);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Badge>>> getBadgesByCategory(String category) async {
    try {
      final badges = await localDataSource.getBadgesByCategory(category);
      return Right(badges);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Badge>>> getEarnedBadges() async {
    try {
      final badges = await localDataSource.getEarnedBadges();
      return Right(badges);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Badge>> getBadgeById(String id) async {
    try {
      final badge = await localDataSource.getBadgeById(id);
      return Right(badge);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Badge>> awardBadge(String id) async {
    try {
      final badge = await localDataSource.awardBadge(id);
      return Right(badge);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Badge>> updateBadgeProgress(String id, int progress) async {
    try {
      final badge = await localDataSource.updateBadgeProgress(id, progress);
      return Right(badge);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> checkBadgeRequirements(
    String id,
    Map<String, dynamic> userStats,
  ) async {
    try {
      // Get the badge
      final badgeResult = await getBadgeById(id);
      
      return badgeResult.fold(
        (failure) => Left(failure),
        (badge) {
          // Check if the badge is already earned
          if (badge.isEarned) {
            return const Right(false);
          }
          
          // Check each requirement
          bool allRequirementsMet = true;
          int progress = 0;
          int totalRequirements = 0;
          
          for (final entry in badge.requirements.entries) {
            final key = entry.key;
            final requiredValue = entry.value;
            
            // Check if the user has this stat
            if (userStats.containsKey(key)) {
              final userValue = userStats[key];
              
              // Compare values
              if (userValue is int && requiredValue is int) {
                if (userValue >= requiredValue) {
                  progress += 100;
                } else {
                  allRequirementsMet = false;
                  // Calculate progress percentage
                  final requirementProgress = (userValue / requiredValue * 100).round();
                  progress += requirementProgress;
                }
                totalRequirements++;
              } else if (userValue is double && requiredValue is double) {
                if (userValue >= requiredValue) {
                  progress += 100;
                } else {
                  allRequirementsMet = false;
                  // Calculate progress percentage
                  final requirementProgress = (userValue / requiredValue * 100).round();
                  progress += requirementProgress;
                }
                totalRequirements++;
              } else if (userValue is bool && requiredValue is bool) {
                if (userValue == requiredValue) {
                  progress += 100;
                } else {
                  allRequirementsMet = false;
                  progress += 0;
                }
                totalRequirements++;
              } else if (userValue is String && requiredValue is String) {
                if (userValue == requiredValue) {
                  progress += 100;
                } else {
                  allRequirementsMet = false;
                  progress += 0;
                }
                totalRequirements++;
              } else if (userValue is List && requiredValue is int) {
                // For lists, check the length
                if (userValue.length >= requiredValue) {
                  progress += 100;
                } else {
                  allRequirementsMet = false;
                  // Calculate progress percentage
                  final requirementProgress = (userValue.length / requiredValue * 100).round();
                  progress += requirementProgress;
                }
                totalRequirements++;
              }
            } else {
              // If the user doesn't have this stat, the requirement is not met
              allRequirementsMet = false;
              totalRequirements++;
            }
          }
          
          // Calculate average progress
          final averageProgress = totalRequirements > 0 
              ? (progress / totalRequirements).round() 
              : 0;
          
          // Update badge progress
          localDataSource.updateBadgeProgress(id, averageProgress);
          
          // If all requirements are met, award the badge
          if (allRequirementsMet) {
            localDataSource.awardBadge(id);
            return const Right(true);
          }
          
          return const Right(false);
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
