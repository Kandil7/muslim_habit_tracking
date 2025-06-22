import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/error/exceptions.dart';
import 'package:muslim_habbit/core/error/failures.dart';
import 'package:muslim_habbit/features/dua_dhikr/data/datasources/dua_dhikr_local_data_source.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/repositories/dua_dhikr_repository.dart';

class DuaDhikrRepositoryImpl implements DuaDhikrRepository {
  final DuaDhikrLocalDataSource localDataSource;

  DuaDhikrRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Dua>>> getAllDuas() async {
    try {
      final duaModels = await localDataSource.getAllDuas();
      return Right(duaModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dua>>> getDuasByCategory(String category) async {
    try {
      final duaModels = await localDataSource.getDuasByCategory(category);
      return Right(duaModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dua>>> getFavoriteDuas() async {
    try {
      final duaModels = await localDataSource.getFavoriteDuas();
      return Right(duaModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Dua>> toggleDuaFavorite(String id) async {
    try {
      final duaModel = await localDataSource.toggleDuaFavorite(id);
      return Right(duaModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dhikr>>> getAllDhikrs() async {
    try {
      final dhikrModels = await localDataSource.getAllDhikrs();
      return Right(dhikrModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Dhikr>>> getFavoriteDhikrs() async {
    try {
      final dhikrModels = await localDataSource.getFavoriteDhikrs();
      return Right(dhikrModels.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Dhikr>> toggleDhikrFavorite(String id) async {
    try {
      final dhikrModel = await localDataSource.toggleDhikrFavorite(id);
      return Right(dhikrModel.toEntity());
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
