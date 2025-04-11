import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/cache_manager.dart';
import '../../domain/entities/dua.dart';
import '../../domain/entities/dhikr.dart';
import '../../domain/repositories/dua_dhikr_repository.dart';
import '../datasources/dua_dhikr_local_data_source.dart';

/// Implementation of DuaDhikrRepository
class DuaDhikrRepositoryImpl implements DuaDhikrRepository {
  final DuaDhikrLocalDataSource localDataSource;
  final CacheManager cacheManager;

  DuaDhikrRepositoryImpl({
    required this.localDataSource,
    required this.cacheManager,
  });

  @override
  Future<Either<Failure, List<Dua>>> getAllDuas() async {
    try {
      // Try to get from memory cache first
      final cachedDuas = await cacheManager.getFromCache<List<dynamic>>('all_duas');
      if (cachedDuas != null) {
        return Right(cachedDuas.map((dua) => Dua.fromJson(dua)).toList());
      }

      // Get from local data source
      final duas = await localDataSource.getAllDuas();

      // Save to memory cache
      await cacheManager.saveToCache('all_duas', duas.map((dua) => dua.toJson()).toList());

      return Right(duas);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dua>>> getDuasByCategory(String category) async {
    try {
      // Try to get from memory cache first
      final cacheKey = 'duas_category_$category';
      final cachedDuas = await cacheManager.getFromCache<List<dynamic>>(cacheKey);
      if (cachedDuas != null) {
        return Right(cachedDuas.map((dua) => Dua.fromJson(dua)).toList());
      }

      // Get from local data source
      final duas = await localDataSource.getDuasByCategory(category);

      // Save to memory cache
      await cacheManager.saveToCache(cacheKey, duas.map((dua) => dua.toJson()).toList());

      return Right(duas);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dua>>> getFavoriteDuas() async {
    try {
      final duas = await localDataSource.getFavoriteDuas();
      return Right(duas);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Dua>> toggleDuaFavorite(String id) async {
    try {
      final dua = await localDataSource.toggleDuaFavorite(id);
      return Right(dua);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dhikr>>> getAllDhikrs() async {
    try {
      // Try to get from memory cache first
      final cachedDhikrs = await cacheManager.getFromCache<List<dynamic>>('all_dhikrs');
      if (cachedDhikrs != null) {
        return Right(cachedDhikrs.map((dhikr) => Dhikr.fromJson(dhikr)).toList());
      }

      // Get from local data source
      final dhikrs = await localDataSource.getAllDhikrs();

      // Save to memory cache
      await cacheManager.saveToCache('all_dhikrs', dhikrs.map((dhikr) => dhikr.toJson()).toList());

      return Right(dhikrs);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dhikr>>> getFavoriteDhikrs() async {
    try {
      final dhikrs = await localDataSource.getFavoriteDhikrs();
      return Right(dhikrs);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Dhikr>> toggleDhikrFavorite(String id) async {
    try {
      final dhikr = await localDataSource.toggleDhikrFavorite(id);
      return Right(dhikr);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getDuaCategories() async {
    try {
      // Try to get from memory cache first
      final cachedCategories = await cacheManager.getFromCache<List<dynamic>>('dua_categories');
      if (cachedCategories != null) {
        return Right(cachedCategories.map((category) => category.toString()).toList());
      }

      // Get from local data source
      final categories = await localDataSource.getDuaCategories();

      // Save to memory cache
      await cacheManager.saveToCache('dua_categories', categories);

      return Right(categories);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
