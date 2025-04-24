import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_points.dart';

/// Repository interface for UserPoints feature
abstract class UserPointsRepository {
  /// Get user points
  Future<Either<Failure, UserPoints>> getUserPoints();
  
  /// Add points to the user's total
  Future<Either<Failure, UserPoints>> addPoints(int points, String reason);
  
  /// Spend points from the user's total
  Future<Either<Failure, UserPoints>> spendPoints(int points, String reason);
  
  /// Get points history
  Future<Either<Failure, List<PointsEntry>>> getPointsHistory();
  
  /// Reset user points (for testing or admin purposes)
  Future<Either<Failure, UserPoints>> resetPoints();
}
