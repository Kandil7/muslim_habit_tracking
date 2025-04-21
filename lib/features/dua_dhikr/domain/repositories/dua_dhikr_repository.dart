import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/dua.dart';
import '../entities/dhikr.dart';

/// Repository interface for duas and dhikrs
abstract class DuaDhikrRepository {
  /// Get all duas
  Future<Either<Failure, List<Dua>>> getAllDuas();

  /// Get duas by category
  Future<Either<Failure, List<Dua>>> getDuasByCategory(String category);

  /// Get favorite duas
  Future<Either<Failure, List<Dua>>> getFavoriteDuas();

  /// Toggle dua favorite status
  Future<Either<Failure, Dua>> toggleDuaFavorite(String id);

  /// Get all dhikrs
  Future<Either<Failure, List<Dhikr>>> getAllDhikrs();

  /// Get favorite dhikrs
  Future<Either<Failure, List<Dhikr>>> getFavoriteDhikrs();

  /// Toggle dhikr favorite status
  Future<Either<Failure, Dhikr>> toggleDhikrFavorite(String id);

  /// Get dua categories
  Future<Either<Failure, List<String>>> getDuaCategories();
}
