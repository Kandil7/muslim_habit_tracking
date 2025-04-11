import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/dua.dart';
import '../../domain/entities/dhikr.dart';
import '../../domain/repositories/dua_dhikr_repository.dart';
import '../datasources/dua_dhikr_local_data_source.dart';

/// Implementation of DuaDhikrRepository
class DuaDhikrRepositoryImpl implements DuaDhikrRepository {
  final DuaDhikrLocalDataSource localDataSource;
  
  DuaDhikrRepositoryImpl({
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, List<Dua>>> getAllDuas() async {
    try {
      final duas = await localDataSource.getAllDuas();
      return Right(duas);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
  
  @override
  Future<Either<Failure, List<Dua>>> getDuasByCategory(String category) async {
    try {
      final duas = await localDataSource.getDuasByCategory(category);
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
      final dhikrs = await localDataSource.getAllDhikrs();
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
      final categories = await localDataSource.getDuaCategories();
      return Right(categories);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
