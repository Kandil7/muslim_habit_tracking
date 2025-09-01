import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/settings/domain/repositories/enhanced_settings_repository.dart';

/// Use case to reset settings to default
class ResetToDefaultSettings {
  final EnhancedSettingsRepository repository;

  ResetToDefaultSettings(this.repository);

  /// Reset settings to default
  Future<Either<Failure, bool>> call() async {
    return await repository.resetToDefaultSettings();
  }
}