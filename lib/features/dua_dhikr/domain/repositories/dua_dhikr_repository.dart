import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';

abstract class DuaDhikrRepository {
  Future<Either<Failure, List<Dua>>> getAllDuas();
  Future<Either<Failure, List<Dua>>> getDuasByCategory(String category);
  Future<Either<Failure, List<Dua>>> getFavoriteDuas();
  Future<Either<Failure, Dua>> toggleDuaFavorite(String id);
  Future<Either<Failure, List<Dhikr>>> getAllDhikrs();
  Future<Either<Failure, List<Dhikr>>> getFavoriteDhikrs();
  Future<Either<Failure, Dhikr>> toggleDhikrFavorite(String id);
  Future<Either<Failure, List<String>>> getDuaCategories();
}
