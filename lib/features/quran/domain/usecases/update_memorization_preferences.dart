import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_preferences.dart';
import '../repositories/memorization_repository.dart';

/// Use case to update memorization preferences
class UpdateMemorizationPreferences {
  final MemorizationRepository repository;

  UpdateMemorizationPreferences(this.repository);

  /// Update memorization preferences
  Future<Either<Failure, MemorizationPreferences>> call(
      MemorizationPreferences preferences) async {
    return await repository.updatePreferences(preferences);
  }
}