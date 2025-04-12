import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/cache_manager.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/prayer_time_repository.dart';
import '../datasources/prayer_time_local_data_source.dart';
import '../datasources/prayer_time_remote_data_source.dart';
import '../models/prayer_time_model.dart';
import '../services/location_service.dart';

/// Implementation of PrayerTimeRepository
class PrayerTimeRepositoryImpl implements PrayerTimeRepository {
  final PrayerTimeRemoteDataSource remoteDataSource;
  final PrayerTimeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final LocationService locationService;
  final CacheManager cacheManager;

  PrayerTimeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.locationService,
    required this.cacheManager,
  });

  @override
  Future<Either<Failure, PrayerTime>> getPrayerTimeByDate(DateTime date) async {
    try {
      // Generate cache key
      final cacheKey = 'prayer_time_${date.year}_${date.month}_${date.day}';

      // Try to get from memory cache first
      final cachedPrayerTime = await cacheManager.getFromCache<Map<String, dynamic>>(cacheKey);
      if (cachedPrayerTime != null) {
        return Right(PrayerTimeModel.fromJson(cachedPrayerTime));
      }

      // Try to get from local storage
      final localPrayerTime = await localDataSource.getPrayerTimeByDate(date);

      if (localPrayerTime != null) {
        // Save to memory cache for faster access next time
        await cacheManager.saveToCache(cacheKey, (localPrayerTime as PrayerTimeModel).toJson());
        return Right(localPrayerTime);
      }

      // If not available locally and online, fetch from API
      if (await networkInfo.isConnected) {
        try {
          final calculationMethod = await localDataSource.getCalculationMethod();

          // Get location using LocationService with default fallback
          final location = await locationService.getSavedLocation(useDefaultIfNotFound: true);

          final remotePrayerTime = await remoteDataSource.getPrayerTimeByDate(
            date,
            location['latitude']!,
            location['longitude']!,
            calculationMethod,
          );

          // Save to local storage
          await localDataSource.savePrayerTime(remotePrayerTime);

          // Save to memory cache
          final cacheKey = 'prayer_time_${date.year}_${date.month}_${date.day}';
          await cacheManager.saveToCache(cacheKey, (remotePrayerTime as PrayerTimeModel).toJson());

          return Right(remotePrayerTime);
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        return Left(ServerFailure(message: 'No internet connection'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Try to get from local storage first
      final localPrayerTimes = await localDataSource.getPrayerTimesByDateRange(
        startDate,
        endDate,
      );

      // If we have all the dates in the range, return them
      if (localPrayerTimes.length == endDate.difference(startDate).inDays + 1) {
        return Right(localPrayerTimes);
      }

      // If not all available locally and online, fetch from API
      if (await networkInfo.isConnected) {
        try {
          final calculationMethod = await localDataSource.getCalculationMethod();

          // Get location using LocationService with default fallback
          final location = await locationService.getSavedLocation(useDefaultIfNotFound: true);

          final remotePrayerTimes = await remoteDataSource.getPrayerTimesByDateRange(
            startDate,
            endDate,
            location['latitude']!,
            location['longitude']!,
            calculationMethod,
          );

          // Save to local storage
          await localDataSource.savePrayerTimes(remotePrayerTimes);

          return Right(remotePrayerTimes);
        } on ServerException catch (e) {
          return Left(ServerFailure(message: e.message));
        }
      } else {
        // Return what we have locally, even if incomplete
        return Right(localPrayerTimes);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateCalculationMethod(String method) async {
    try {
      await localDataSource.updateCalculationMethod(method);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> getCalculationMethod() async {
    try {
      final method = await localDataSource.getCalculationMethod();
      return Right(method);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> getAvailableCalculationMethods() async {
    if (await networkInfo.isConnected) {
      try {
        final methods = await remoteDataSource.getAvailableCalculationMethods();
        return Right(methods);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      // Return a default set of methods if offline
      return Right({
        '1': 'University of Islamic Sciences, Karachi',
        '2': 'Islamic Society of North America',
        '3': 'Muslim World League',
        '4': 'Umm Al-Qura University, Makkah',
        '5': 'Egyptian General Authority of Survey',
        '7': 'Institute of Geophysics, University of Tehran',
        '8': 'Gulf Region',
        '9': 'Kuwait',
        '10': 'Qatar',
        '11': 'Majlis Ugama Islam Singapura, Singapore',
        '12': 'Union Organization Islamic de France',
        '13': 'Diyanet İşleri Başkanlığı, Turkey',
        '14': 'Spiritual Administration of Muslims of Russia',
        '15': 'Moonsighting Committee Worldwide',
      });
    }
  }
}
