import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/settings/domain/entities/enhanced/user_preferences.dart';
import 'package:muslim_habbit/features/settings/domain/repositories/enhanced_settings_repository.dart';

/// Use case to update user preferences
class UpdateUserPreferences {
  final EnhancedSettingsRepository repository;

  UpdateUserPreferences(this.repository);

  /// Update user preferences
  Future<Either<Failure, UserPreferences>> call(UserPreferences preferences) async {
    return await repository.updateUserPreferences(preferences);
  }
}