import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/entities/memorization_item.dart';
import '../../domain/entities/memorization_preferences.dart';
import '../datasources/memorization_local_data_source.dart';

/// Service for handling data migration for memorization tracking
class MemorizationMigrationService {
  final MemorizationLocalDataSource localDataSource;
  final SharedPreferences sharedPreferences;

  MemorizationMigrationService({
    required this.localDataSource,
    required this.sharedPreferences,
  });

  /// Migrate data from old format to new format
  Future<void> migrateData() async {
    try {
      // Check if migration has already been performed
      final hasMigrated = sharedPreferences.getBool('memorization_migrated') ?? false;
      if (hasMigrated) return;

      // Perform migration steps here
      // This is a placeholder for actual migration logic
      // In a real implementation, this would:
      // 1. Check for existing data in old format
      // 2. Convert it to the new format
      // 3. Save it using the new data source
      // 4. Mark migration as complete

      // For now, we'll just mark migration as complete
      await sharedPreferences.setBool('memorization_migrated', true);
    } catch (e) {
      throw CacheException(message: 'Failed to migrate memorization data: $e');
    }
  }

  /// Migrate from v1 to v2 format (example)
  Future<void> migrateFromV1ToV2() async {
    try {
      // Check if v1 data exists
      final v1Data = sharedPreferences.getString('memorization_items_v1');
      if (v1Data == null) return;

      // Parse v1 data
      final List<dynamic> itemsJson = json.decode(v1Data);
      
      // Convert to v2 format
      for (final itemJson in itemsJson) {
        final item = _convertV1ItemToV2(itemJson as Map<String, dynamic>);
        await localDataSource.createMemorizationItem(item);
      }

      // Remove old data
      await sharedPreferences.remove('memorization_items_v1');
      
      // Mark migration as complete
      await sharedPreferences.setBool('memorization_migrated_v2', true);
    } catch (e) {
      throw CacheException(message: 'Failed to migrate from v1 to v2: $e');
    }
  }

  /// Convert v1 item format to v2
  MemorizationItem _convertV1ItemToV2(Map<String, dynamic> itemJson) {
    return MemorizationItem(
      id: itemJson['id'] as String,
      surahNumber: itemJson['surahNumber'] as int,
      surahName: itemJson['surahName'] as String,
      startPage: itemJson['startPage'] as int,
      endPage: itemJson['endPage'] as int,
      dateAdded: DateTime.parse(itemJson['dateAdded'] as String),
      status: _convertV1StatusToV2(itemJson['status'] as String),
      consecutiveReviewDays: itemJson['consecutiveReviewDays'] as int,
      lastReviewed: itemJson['lastReviewed'] == null
          ? null
          : DateTime.parse(itemJson['lastReviewed'] as String),
      reviewHistory: (itemJson['reviewHistory'] as List<dynamic>)
          .map((date) => DateTime.parse(date as String))
          .toList(),
    );
  }

  /// Convert v1 status to v2
  MemorizationStatus _convertV1StatusToV2(String status) {
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