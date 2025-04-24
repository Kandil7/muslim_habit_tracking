import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/prayer_time.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../datasources/aladhan_api_service.dart';
import '../models/prayer_time_model.dart';

/// Implementation of PrayerTimesRepository
class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  final AlAdhanApiService apiService;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  /// Creates a new PrayerTimesRepositoryImpl
  PrayerTimesRepositoryImpl({
    required this.apiService,
    required this.networkInfo,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesByCity({
    required String city,
    required String country,
    required int month,
    required int year,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final prayerTimes = await apiService.getPrayerTimesByCity(
          city: city,
          country: country,
          month: month,
          year: year,
        );
        
        // Cache the prayer times
        await _cachePrayerTimes(prayerTimes);
        
        return Right(prayerTimes);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      // Try to get cached prayer times
      final cachedPrayerTimes = _getCachedPrayerTimes();
      if (cachedPrayerTimes.isNotEmpty) {
        return Right(cachedPrayerTimes);
      }
      
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<PrayerTime>>> getPrayerTimesByCoordinates({
    required double latitude,
    required double longitude,
    required int month,
    required int year,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final prayerTimes = await apiService.getPrayerTimesByCoordinates(
          latitude: latitude,
          longitude: longitude,
          month: month,
          year: year,
        );
        
        // Cache the prayer times
        await _cachePrayerTimes(prayerTimes);
        
        return Right(prayerTimes);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      // Try to get cached prayer times
      final cachedPrayerTimes = _getCachedPrayerTimes();
      if (cachedPrayerTimes.isNotEmpty) {
        return Right(cachedPrayerTimes);
      }
      
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, PrayerTime>> getPrayerTimesForToday() async {
    final now = DateTime.now();
    return getPrayerTimesForDate(now);
  }

  @override
  Future<Either<Failure, PrayerTime>> getPrayerTimesForDate(DateTime date) async {
    // Try to get from cache first
    final cachedPrayerTimes = _getCachedPrayerTimes();
    final prayerTimeForDate = cachedPrayerTimes.where((pt) {
      return pt.date.year == date.year &&
          pt.date.month == date.month &&
          pt.date.day == date.day;
    }).toList();
    
    if (prayerTimeForDate.isNotEmpty) {
      return Right(prayerTimeForDate.first);
    }
    
    // If not in cache, fetch from API
    final locationResult = await getUserLocation();
    
    return locationResult.fold(
      (failure) => Left(failure),
      (location) async {
        if (location.containsKey('city') && location.containsKey('country')) {
          final result = await getPrayerTimesByCity(
            city: location['city'],
            country: location['country'],
            month: date.month,
            year: date.year,
          );
          
          return result.fold(
            (failure) => Left(failure),
            (prayerTimes) {
              final prayerTimeForDate = prayerTimes.where((pt) {
                return pt.date.year == date.year &&
                    pt.date.month == date.month &&
                    pt.date.day == date.day;
              }).toList();
              
              if (prayerTimeForDate.isNotEmpty) {
                return Right(prayerTimeForDate.first);
              }
              
              return Left(CacheFailure(message: 'Prayer time not found for the specified date'));
            },
          );
        } else if (location.containsKey('latitude') && location.containsKey('longitude')) {
          final result = await getPrayerTimesByCoordinates(
            latitude: location['latitude'],
            longitude: location['longitude'],
            month: date.month,
            year: date.year,
          );
          
          return result.fold(
            (failure) => Left(failure),
            (prayerTimes) {
              final prayerTimeForDate = prayerTimes.where((pt) {
                return pt.date.year == date.year &&
                    pt.date.month == date.month &&
                    pt.date.day == date.day;
              }).toList();
              
              if (prayerTimeForDate.isNotEmpty) {
                return Right(prayerTimeForDate.first);
              }
              
              return Left(CacheFailure(message: 'Prayer time not found for the specified date'));
            },
          );
        } else {
          return Left(CacheFailure(message: 'User location not found'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> saveUserLocation({
    String? city,
    String? country,
    double? latitude,
    double? longitude,
  }) async {
    try {
      if (city != null && country != null) {
        await sharedPreferences.setString('user_location_city', city);
        await sharedPreferences.setString('user_location_country', country);
        await sharedPreferences.remove('user_location_latitude');
        await sharedPreferences.remove('user_location_longitude');
      } else if (latitude != null && longitude != null) {
        await sharedPreferences.setDouble('user_location_latitude', latitude);
        await sharedPreferences.setDouble('user_location_longitude', longitude);
        await sharedPreferences.remove('user_location_city');
        await sharedPreferences.remove('user_location_country');
      } else {
        return Left(CacheFailure(message: 'Invalid location data'));
      }
      
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to save user location: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserLocation() async {
    try {
      final city = sharedPreferences.getString('user_location_city');
      final country = sharedPreferences.getString('user_location_country');
      final latitude = sharedPreferences.getDouble('user_location_latitude');
      final longitude = sharedPreferences.getDouble('user_location_longitude');
      
      if (city != null && country != null) {
        return Right({
          'city': city,
          'country': country,
        });
      } else if (latitude != null && longitude != null) {
        return Right({
          'latitude': latitude,
          'longitude': longitude,
        });
      }
      
      return Left(CacheFailure(message: 'User location not found'));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get user location: $e'));
    }
  }
  
  /// Cache prayer times in shared preferences
  Future<void> _cachePrayerTimes(List<PrayerTimeModel> prayerTimes) async {
    final prayerTimesJson = prayerTimes.map((pt) => pt.toJson()).toList();
    await sharedPreferences.setString(
      'cached_prayer_times',
      prayerTimesJson.toString(),
    );
  }
  
  /// Get cached prayer times from shared preferences
  List<PrayerTimeModel> _getCachedPrayerTimes() {
    final cachedPrayerTimesString = sharedPreferences.getString('cached_prayer_times');
    if (cachedPrayerTimesString != null) {
      try {
        final List<dynamic> prayerTimesJson = cachedPrayerTimesString as List<dynamic>;
        return prayerTimesJson
            .map((json) => PrayerTimeModel.fromJson(json))
            .toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}
