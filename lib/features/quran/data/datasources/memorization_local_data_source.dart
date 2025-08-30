import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/memorization_item.dart';
import '../../domain/entities/memorization_preferences.dart';
import '../models/memorization_item_model.dart';
import '../models/memorization_preferences_model.dart';

/// Interface for local data source for memorization tracking
abstract class MemorizationLocalDataSource {
  /// Get all memorization items
  Future<List<MemorizationItemModel>> getMemorizationItems();

  /// Get a memorization item by ID
  Future<MemorizationItemModel> getMemorizationItemById(String id);

  /// Create a new memorization item
  Future<MemorizationItemModel> createMemorizationItem(
      MemorizationItemModel item);

  /// Update an existing memorization item
  Future<MemorizationItemModel> updateMemorizationItem(
      MemorizationItemModel item);

  /// Delete a memorization item
  Future<void> deleteMemorizationItem(String id);

  /// Mark an item as reviewed today
  Future<MemorizationItemModel> markItemAsReviewed(String itemId);

  /// Get user preferences
  Future<MemorizationPreferencesModel> getPreferences();

  /// Update user preferences
  Future<MemorizationPreferencesModel> updatePreferences(
      MemorizationPreferencesModel preferences);

  /// Get statistics about memorization progress
  Future<MemorizationStatisticsModel> getMemorizationStatistics();
}

/// Implementation of MemorizationLocalDataSource using Hive and SharedPreferences
class MemorizationLocalDataSourceImpl implements MemorizationLocalDataSource {
  final Box memorizationBox;
  final SharedPreferences sharedPreferences;
  final Uuid uuid;

  MemorizationLocalDataSourceImpl({
    required this.memorizationBox,
    required this.sharedPreferences,
    required this.uuid,
  });

  // Keys for SharedPreferences
  static const String _preferencesKey = 'memorization_preferences';
  static const String _statisticsKey = 'memorization_statistics';
  static const String _lastReviewDateKey = 'memorization_last_review_date';
  static const String _currentStreakKey = 'memorization_current_streak';
  static const String _longestStreakKey = 'memorization_longest_streak';

  @override
  Future<List<MemorizationItemModel>> getMemorizationItems() async {
    try {
      final itemsJson = memorizationBox.values.toList();
      return itemsJson
          .map((itemJson) => MemorizationItemModel.fromJson(json.decode(itemJson)))
          .toList();
    } catch (e) {
      throw CacheException(
          message: 'Failed to get memorization items from local storage');
    }
  }

  @override
  Future<MemorizationItemModel> getMemorizationItemById(String id) async {
    try {
      final itemJson = memorizationBox.get(id);
      if (itemJson == null) {
        throw CacheException(message: 'Memorization item not found');
      }
      return MemorizationItemModel.fromJson(json.decode(itemJson));
    } catch (e) {
      throw CacheException(
          message: 'Failed to get memorization item from local storage');
    }
  }

  @override
  Future<MemorizationItemModel> createMemorizationItem(
      MemorizationItemModel item) async {
    try {
      final newItem = item.copyWith(id: uuid.v4());
      await memorizationBox.put(newItem.id, json.encode(newItem.toJson()));
      return newItem;
    } catch (e) {
      throw CacheException(
          message: 'Failed to create memorization item in local storage');
    }
  }

  @override
  Future<MemorizationItemModel> updateMemorizationItem(
      MemorizationItemModel item) async {
    try {
      await memorizationBox.put(item.id, json.encode(item.toJson()));
      return item;
    } catch (e) {
      throw CacheException(
          message: 'Failed to update memorization item in local storage');
    }
  }

  @override
  Future<void> deleteMemorizationItem(String id) async {
    try {
      await memorizationBox.delete(id);
    } catch (e) {
      throw CacheException(
          message: 'Failed to delete memorization item from local storage');
    }
  }

  @override
  Future<MemorizationItemModel> markItemAsReviewed(String itemId) async {
    try {
      final item = await getMemorizationItemById(itemId);
      
      // Update the item based on its current status
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      MemorizationItemModel updatedItem;
      
      if (item.status == MemorizationStatus.newStatus || 
          item.status == MemorizationStatus.inProgress) {
        // For new or in-progress items, increment consecutive days
        int newConsecutiveDays = item.consecutiveReviewDays + 1;
        
        // If we've reached 5 consecutive days, mark as memorized
        final newStatus = newConsecutiveDays >= 5 
            ? MemorizationStatus.memorized 
            : MemorizationStatus.inProgress;
        
        // Reset to 5 if memorized, otherwise increment
        newConsecutiveDays = newStatus == MemorizationStatus.memorized 
            ? 5 
            : newConsecutiveDays;
        
        updatedItem = item.copyWith(
          status: newStatus,
          consecutiveReviewDays: newConsecutiveDays,
          lastReviewed: today,
          reviewHistory: [...item.reviewHistory, today],
        );
      } else if (item.status == MemorizationStatus.memorized) {
        // For memorized items, just update the last reviewed date
        updatedItem = item.copyWith(
          lastReviewed: today,
          reviewHistory: [...item.reviewHistory, today],
        );
      } else {
        // For archived items, don't change anything
        return item;
      }
      
      await memorizationBox.put(updatedItem.id, json.encode(updatedItem.toJson()));
      
      // Update streak information
      await _updateStreakInformation();
      
      return updatedItem;
    } catch (e) {
      throw CacheException(
          message: 'Failed to mark item as reviewed in local storage');
    }
  }

  /// Update streak information in SharedPreferences
  Future<void> _updateStreakInformation() async {
    try {
      final lastReviewDateStr = sharedPreferences.getString(_lastReviewDateKey);
      final currentStreak = sharedPreferences.getInt(_currentStreakKey) ?? 0;
      
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      int newStreak = currentStreak;
      
      if (lastReviewDateStr == null) {
        // First review ever
        newStreak = 1;
      } else {
        final lastReviewDate = DateTime.parse(lastReviewDateStr);
        final difference = today.difference(lastReviewDate).inDays;
        
        if (difference == 1) {
          // Consecutive day
          newStreak = currentStreak + 1;
        } else if (difference > 1) {
          // Break in streak
          newStreak = 1;
        }
        // If difference is 0 (same day), keep current streak
      }
      
      // Update longest streak if needed
      final longestStreak = sharedPreferences.getInt(_longestStreakKey) ?? 0;
      final newLongestStreak = newStreak > longestStreak ? newStreak : longestStreak;
      
      // Save updated values
      await sharedPreferences.setString(_lastReviewDateKey, today.toIso8601String());
      await sharedPreferences.setInt(_currentStreakKey, newStreak);
      await sharedPreferences.setInt(_longestStreakKey, newLongestStreak);
    } catch (e) {
      // Silently fail streak updates to not break the main functionality
      // In a production app, we might want to log this
    }
  }

  @override
  Future<MemorizationPreferencesModel> getPreferences() async {
    try {
      final prefsJson = sharedPreferences.getString(_preferencesKey);
      if (prefsJson == null) {
        // Return default preferences
        return const MemorizationPreferencesModel(
          reviewPeriod: 5,
          memorizationDirection: MemorizationDirection.fromBaqarah,
        );
      }

      final jsonMap = json.decode(prefsJson);
      return MemorizationPreferencesModel.fromJson(jsonMap);
    } catch (e) {
      // Return default preferences on error
      return const MemorizationPreferencesModel(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
      );
    }
  }

  @override
  Future<MemorizationPreferencesModel> updatePreferences(
      MemorizationPreferencesModel preferences) async {
    try {
      final prefsJson = json.encode(preferences.toJson());
      await sharedPreferences.setString(_preferencesKey, prefsJson);
      return preferences;
    } catch (e) {
      throw CacheException(
          message: 'Failed to update preferences in local storage');
    }
  }

  @override
  Future<MemorizationStatisticsModel> getMemorizationStatistics() async {
    try {
      final items = await getMemorizationItems();
      
      // Calculate items by status
      final itemsByStatus = <MemorizationStatus, int>{};
      for (final status in MemorizationStatus.values) {
        itemsByStatus[status] = 0;
      }
      
      int totalPagesMemorized = 0;
      
      for (final item in items) {
        itemsByStatus[item.status] = (itemsByStatus[item.status] ?? 0) + 1;
        
        if (item.status == MemorizationStatus.memorized) {
          totalPagesMemorized += item.pageCount;
        }
      }
      
      // Get streak information
      final currentStreak = sharedPreferences.getInt(_currentStreakKey) ?? 0;
      final longestStreak = sharedPreferences.getInt(_longestStreakKey) ?? 0;
      
      // Calculate memorization percentage
      final totalItems = items.length;
      final memorizedItems = itemsByStatus[MemorizationStatus.memorized] ?? 0;
      final memorizationPercentage = totalItems > 0 
          ? (memorizedItems / totalItems) * 100 
          : 0.0;
      
      return MemorizationStatisticsModel(
        totalItems: totalItems,
        itemsByStatus: itemsByStatus,
        totalPagesMemorized: totalPagesMemorized,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        memorizationPercentage: memorizationPercentage,
      );
    } catch (e) {
      throw CacheException(
          message: 'Failed to get memorization statistics from local storage');
    }
  }
}

/// Data model for MemorizationStatistics that extends the entity with serialization methods
class MemorizationStatisticsModel extends MemorizationStatistics {
  /// Constructor
  const MemorizationStatisticsModel({
    required super.totalItems,
    required super.itemsByStatus,
    required super.totalPagesMemorized,
    required super.currentStreak,
    required super.longestStreak,
    required super.memorizationPercentage,
  }) : super();

  /// Factory method to create from entity
  factory MemorizationStatisticsModel.fromEntity(MemorizationStatistics entity) {
    return MemorizationStatisticsModel(
      totalItems: entity.totalItems,
      itemsByStatus: entity.itemsByStatus,
      totalPagesMemorized: entity.totalPagesMemorized,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      memorizationPercentage: entity.memorizationPercentage,
    );
  }

  /// Factory method to create from JSON
  factory MemorizationStatisticsModel.fromJson(Map<String, dynamic> json) {
    return MemorizationStatisticsModel(
      totalItems: json['totalItems'] as int,
      itemsByStatus: (json['itemsByStatus'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          _statusFromString(key),
          value as int,
        ),
      ),
      totalPagesMemorized: json['totalPagesMemorized'] as int,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      memorizationPercentage: (json['memorizationPercentage'] as num).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'itemsByStatus': itemsByStatus.map(
        (key, value) => MapEntry(
          _statusToString(key),
          value,
        ),
      ),
      'totalPagesMemorized': totalPagesMemorized,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'memorizationPercentage': memorizationPercentage,
    };
  }

  /// Convert status to string
  String _statusToString(MemorizationStatus status) {
    switch (status) {
      case MemorizationStatus.newStatus:
        return 'new';
      case MemorizationStatus.inProgress:
        return 'inProgress';
      case MemorizationStatus.memorized:
        return 'memorized';
      case MemorizationStatus.archived:
        return 'archived';
    }
  }

  /// Convert string to status
  static MemorizationStatus _statusFromString(String status) {
    switch (status) {
      case 'new':
        return MemorizationStatus.newStatus;
      case 'inProgress':
        return MemorizationStatus.inProgress;
      case 'memorized':
        return MemorizationStatus.memorized;
      case 'archived':
        return MemorizationStatus.archived;
      default:
        return MemorizationStatus.newStatus;
    }
  }
}