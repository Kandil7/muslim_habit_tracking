import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/settings/domain/entities/enhanced/user_preferences.dart';

/// Repository interface for enhanced settings
abstract class EnhancedSettingsRepository {
  /// Get user preferences
  Future<Either<Failure, UserPreferences>> getUserPreferences();

  /// Update user preferences
  Future<Either<Failure, UserPreferences>> updateUserPreferences(
      UserPreferences preferences);

  /// Reset settings to default
  Future<Either<Failure, bool>> resetToDefaultSettings();

  /// Export settings
  Future<Either<Failure, String>> exportSettings();

  /// Import settings
  Future<Either<Failure, bool>> importSettings(String settingsData);

  /// Get specific setting value
  Future<Either<Failure, dynamic>> getSetting(String key);

  /// Update specific setting value
  Future<Either<Failure, bool>> updateSetting(String key, dynamic value);
}