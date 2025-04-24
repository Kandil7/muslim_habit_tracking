import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/badge.dart';

/// Repository interface for Badge feature
abstract class BadgeRepository {
  /// Get all badges
  Future<Either<Failure, List<Badge>>> getAllBadges();
  
  /// Get badges by category
  Future<Either<Failure, List<Badge>>> getBadgesByCategory(String category);
  
  /// Get earned badges
  Future<Either<Failure, List<Badge>>> getEarnedBadges();
  
  /// Get badge by ID
  Future<Either<Failure, Badge>> getBadgeById(String id);
  
  /// Award a badge to the user
  Future<Either<Failure, Badge>> awardBadge(String id);
  
  /// Update badge progress
  Future<Either<Failure, Badge>> updateBadgeProgress(String id, int progress);
  
  /// Check if a badge should be awarded based on requirements
  Future<Either<Failure, bool>> checkBadgeRequirements(String id, Map<String, dynamic> userStats);
}
