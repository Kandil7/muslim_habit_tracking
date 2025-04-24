import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/unlockable_content.dart';

/// Repository interface for UnlockableContent feature
abstract class UnlockableContentRepository {
  /// Get all unlockable content
  Future<Either<Failure, List<UnlockableContent>>> getAllContent();
  
  /// Get unlockable content by type
  Future<Either<Failure, List<UnlockableContent>>> getContentByType(String contentType);
  
  /// Get unlocked content
  Future<Either<Failure, List<UnlockableContent>>> getUnlockedContent();
  
  /// Get content by ID
  Future<Either<Failure, UnlockableContent>> getContentById(String id);
  
  /// Unlock content
  Future<Either<Failure, UnlockableContent>> unlockContent(String id);
  
  /// Check if user has enough points to unlock content
  Future<Either<Failure, bool>> canUnlockContent(String id, int userPoints);
}
