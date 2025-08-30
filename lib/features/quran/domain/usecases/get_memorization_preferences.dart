import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_preferences.dart';
import '../repositories/memorization_repository.dart';

/// Use case to get memorization preferences
class GetMemorizationPreferences {
  final MemorizationRepository repository;

  GetMemorizationPreferences(this.repository);

  /// Get memorization preferences
  Future<Either<Failure, MemorizationPreferences>> call() async {
    return await repository.getPreferences();
  }
}