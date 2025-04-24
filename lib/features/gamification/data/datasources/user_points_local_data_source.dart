import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_points_model.dart';

/// Interface for the local data source for UserPoints feature
abstract class UserPointsLocalDataSource {
  /// Get user points
  Future<UserPointsModel> getUserPoints();
  
  /// Add points to the user's total
  Future<UserPointsModel> addPoints(int points, String reason);
  
  /// Spend points from the user's total
  Future<UserPointsModel> spendPoints(int points, String reason);
  
  /// Reset user points (for testing or admin purposes)
  Future<UserPointsModel> resetPoints();
}

/// Implementation of UserPointsLocalDataSource using Hive
class UserPointsLocalDataSourceImpl implements UserPointsLocalDataSource {
  final Box<HiveUserPoints> userPointsBox;
  static const String userPointsKey = 'user_points';
  
  /// Creates a new UserPointsLocalDataSourceImpl
  UserPointsLocalDataSourceImpl({required this.userPointsBox}) {
    _initializeUserPoints();
  }
  
  /// Initialize user points if not already present
  Future<void> _initializeUserPoints() async {
    if (!userPointsBox.containsKey(userPointsKey)) {
      await userPointsBox.put(
        userPointsKey,
        HiveUserPoints(
          totalPoints: 0,
          level: 1,
          pointsToNextLevel: 100,
          history: [],
        ),
      );
    }
  }
  
  @override
  Future<UserPointsModel> getUserPoints() async {
    try {
      final hiveUserPoints = userPointsBox.get(userPointsKey);
      if (hiveUserPoints == null) {
        throw CacheException(message: 'User points not found');
      }
      return UserPointsModel.fromHiveObject(hiveUserPoints);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get user points from local storage: $e',
      );
    }
  }
  
  @override
  Future<UserPointsModel> addPoints(int points, String reason) async {
    try {
      final userPoints = await getUserPoints();
      final updatedUserPoints = userPoints.addPoints(points, reason);
      
      // Save to Hive
      await userPointsBox.put(
        userPointsKey,
        updatedUserPoints.toHiveObject(),
      );
      
      return updatedUserPoints;
    } catch (e) {
      throw CacheException(
        message: 'Failed to add points in local storage: $e',
      );
    }
  }
  
  @override
  Future<UserPointsModel> spendPoints(int points, String reason) async {
    try {
      final userPoints = await getUserPoints();
      
      // Check if user has enough points
      if (userPoints.totalPoints < points) {
        throw CacheException(message: 'Not enough points');
      }
      
      // Spend points (add negative points)
      final updatedUserPoints = userPoints.addPoints(-points, reason);
      
      // Save to Hive
      await userPointsBox.put(
        userPointsKey,
        updatedUserPoints.toHiveObject(),
      );
      
      return updatedUserPoints;
    } catch (e) {
      throw CacheException(
        message: 'Failed to spend points in local storage: $e',
      );
    }
  }
  
  @override
  Future<UserPointsModel> resetPoints() async {
    try {
      // Create new user points
      final newUserPoints = UserPointsModel();
      
      // Save to Hive
      await userPointsBox.put(
        userPointsKey,
        newUserPoints.toHiveObject(),
      );
      
      return newUserPoints;
    } catch (e) {
      throw CacheException(
        message: 'Failed to reset points in local storage: $e',
      );
    }
  }
}
