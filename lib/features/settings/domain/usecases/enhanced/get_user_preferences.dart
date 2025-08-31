import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/settings/domain/entities/enhanced/user_preferences.dart';
import 'package:muslim_habbit/features/settings/domain/repositories/enhanced_settings_repository.dart';

/// Use case to get user preferences
class GetUserPreferences {
  final EnhancedSettingsRepository repository;

  GetUserPreferences(this.repository);

  /// Get user preferences
  Future<Either<Failure, UserPreferences>> call() async {
    return await repository.getUserPreferences();
  }
}