import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/badge_model.dart';
import 'predefined_badges.dart';

/// Interface for the local data source for Badge feature
abstract class BadgeLocalDataSource {
  /// Get all badges
  Future<List<BadgeModel>> getAllBadges();
  
  /// Get badges by category
  Future<List<BadgeModel>> getBadgesByCategory(String category);
  
  /// Get earned badges
  Future<List<BadgeModel>> getEarnedBadges();
  
  /// Get badge by ID
  Future<BadgeModel> getBadgeById(String id);
  
  /// Award a badge to the user
  Future<BadgeModel> awardBadge(String id);
  
  /// Update badge progress
  Future<BadgeModel> updateBadgeProgress(String id, int progress);
}

/// Implementation of BadgeLocalDataSource using Hive
class BadgeLocalDataSourceImpl implements BadgeLocalDataSource {
  final Box<HiveBadge> badgeBox;
  
  /// Creates a new BadgeLocalDataSourceImpl
  BadgeLocalDataSourceImpl({required this.badgeBox}) {
    _initializeBadges();
  }
  
  /// Initialize predefined badges if the box is empty
  Future<void> _initializeBadges() async {
    if (badgeBox.isEmpty) {
      for (final badge in PredefinedBadges.badges) {
        await badgeBox.put(badge.id, badge.toHiveObject());
      }
    }
  }
  
  @override
  Future<List<BadgeModel>> getAllBadges() async {
    try {
      return badgeBox.values
          .map((hiveBadge) => BadgeModel.fromHiveObject(hiveBadge))
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get badges from local storage: $e');
    }
  }
  
  @override
  Future<List<BadgeModel>> getBadgesByCategory(String category) async {
    try {
      return badgeBox.values
          .where((hiveBadge) => hiveBadge.category == category)
          .map((hiveBadge) => BadgeModel.fromHiveObject(hiveBadge))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get badges by category from local storage: $e',
      );
    }
  }
  
  @override
  Future<List<BadgeModel>> getEarnedBadges() async {
    try {
      return badgeBox.values
          .where((hiveBadge) => hiveBadge.isEarned)
          .map((hiveBadge) => BadgeModel.fromHiveObject(hiveBadge))
          .toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get earned badges from local storage: $e',
      );
    }
  }
  
  @override
  Future<BadgeModel> getBadgeById(String id) async {
    try {
      final hiveBadge = badgeBox.get(id);
      if (hiveBadge == null) {
        throw CacheException(message: 'Badge with ID $id not found');
      }
      return BadgeModel.fromHiveObject(hiveBadge);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get badge by ID from local storage: $e',
      );
    }
  }
  
  @override
  Future<BadgeModel> awardBadge(String id) async {
    try {
      final hiveBadge = badgeBox.get(id);
      if (hiveBadge == null) {
        throw CacheException(message: 'Badge with ID $id not found');
      }
      
      // Update badge
      hiveBadge.isEarned = true;
      hiveBadge.earnedDate = DateTime.now();
      hiveBadge.progress = 100;
      
      // Save to Hive
      await hiveBadge.save();
      
      return BadgeModel.fromHiveObject(hiveBadge);
    } catch (e) {
      throw CacheException(
        message: 'Failed to award badge in local storage: $e',
      );
    }
  }
  
  @override
  Future<BadgeModel> updateBadgeProgress(String id, int progress) async {
    try {
      final hiveBadge = badgeBox.get(id);
      if (hiveBadge == null) {
        throw CacheException(message: 'Badge with ID $id not found');
      }
      
      // Update progress
      hiveBadge.progress = progress;
      
      // If progress is 100%, award the badge
      if (progress >= 100 && !hiveBadge.isEarned) {
        hiveBadge.isEarned = true;
        hiveBadge.earnedDate = DateTime.now();
      }
      
      // Save to Hive
      await hiveBadge.save();
      
      return BadgeModel.fromHiveObject(hiveBadge);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update badge progress in local storage: $e',
      );
    }
  }
}
