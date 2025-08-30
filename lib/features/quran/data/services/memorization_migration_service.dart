import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/memorization_item.dart';
import '../../domain/entities/memorization_preferences.dart';
import '../datasources/memorization_local_data_source.dart';

/// Service to handle data migration for existing users
class MemorizationMigrationService {
  final MemorizationLocalDataSource _localDataSource;
  final SharedPreferences _sharedPreferences;

  static const String _migrationVersionKey = 'memorization_migration_version';
  static const int _currentMigrationVersion = 1;

  MemorizationMigrationService({
    required MemorizationLocalDataSource localDataSource,
    required SharedPreferences sharedPreferences,
  })  : _localDataSource = localDataSource,
        _sharedPreferences = sharedPreferences;

  /// Migrate data from previous versions
  Future<void> migrateData() async {
    final currentVersion = _sharedPreferences.getInt(_migrationVersionKey) ?? 0;

    if (currentVersion < 1) {
      await _migrateToVersion1();
    }

    // Update migration version
    await _sharedPreferences.setInt(_migrationVersionKey, _currentMigrationVersion);
  }

  /// Migration to version 1
  Future<void> _migrateToVersion1() async {
    // This is the first version, so we don't need to migrate anything
    // In future versions, we would add migration logic here
    
    // Ensure default preferences exist
    try {
      final preferences = await _localDataSource.getPreferences();
      // Preferences already exist, no need to do anything
    } catch (e) {
      // Preferences don't exist, create default ones
      final defaultPreferences = const MemorizationPreferencesModel(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
      );
      await _localDataSource.updatePreferences(defaultPreferences);
    }
  }

  /// Migrate from old data format (if any)
  Future<void> _migrateFromOldFormat() async {
    // Check if there's old data format that needs to be migrated
    // This would be specific to the app's previous implementation
    
    // Example: If there was a different key for storing memorization items
    // final oldData = _sharedPreferences.getString('old_memorization_key');
    // if (oldData != null) {
    //   // Parse old data format and convert to new format
    //   // Save to new storage
    //   // Remove old data
    // }
  }
}