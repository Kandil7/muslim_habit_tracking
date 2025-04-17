import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/hadith.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../datasources/hadith_local_data_source.dart';

/// Implementation of the HadithRepository
class HadithRepositoryImpl implements HadithRepository {
  final HadithLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Creates a new HadithRepositoryImpl instance
  HadithRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Hadith>>> getAllHadiths() async {
    try {
      final hadiths = await localDataSource.getAllHadiths();
      return Right(hadiths);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Hadith>> getHadithById(String id) async {
    try {
      final hadith = await localDataSource.getHadithById(id);
      return Right(hadith);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Hadith>> getHadithOfTheDay() async {
    try {
      final hadith = await localDataSource.getHadithOfTheDay();
      return Right(hadith);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getHadithsBySource(String source) async {
    try {
      final hadiths = await localDataSource.getHadithsBySource(source);
      return Right(hadiths);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getHadithsByTag(String tag) async {
    try {
      final hadiths = await localDataSource.getHadithsByTag(tag);
      return Right(hadiths);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getBookmarkedHadiths() async {
    try {
      final hadiths = await localDataSource.getBookmarkedHadiths();
      return Right(hadiths);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Hadith>> toggleHadithBookmark(String id) async {
    try {
      final hadith = await localDataSource.toggleHadithBookmark(id);
      return Right(hadith);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
