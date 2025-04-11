import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/prayer_time_model.dart';

/// Interface for local data source for prayer times
abstract class PrayerTimeLocalDataSource {
  /// Get prayer times for a specific date
  Future<PrayerTimeModel?> getPrayerTimeByDate(DateTime date);
  
  /// Get prayer times for a date range
  Future<List<PrayerTimeModel>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Save prayer times
  Future<void> savePrayerTime(PrayerTimeModel prayerTime);
  
  /// Save multiple prayer times
  Future<void> savePrayerTimes(List<PrayerTimeModel> prayerTimes);
  
  /// Get current calculation method
  Future<String> getCalculationMethod();
  
  /// Update calculation method
  Future<void> updateCalculationMethod(String method);
}

/// Implementation of PrayerTimeLocalDataSource using Hive
class PrayerTimeLocalDataSourceImpl implements PrayerTimeLocalDataSource {
  final Box prayerTimesBox;
  final SharedPreferences sharedPreferences;
  
  PrayerTimeLocalDataSourceImpl({
    required this.prayerTimesBox,
    required this.sharedPreferences,
  });
  
  @override
  Future<PrayerTimeModel?> getPrayerTimeByDate(DateTime date) async {
    try {
      // Create a key for the date (YYYY-MM-DD)
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final prayerTimeJson = prayerTimesBox.get(key);
      if (prayerTimeJson == null) {
        return null;
      }
      
      return PrayerTimeModel.fromJson(json.decode(prayerTimeJson));
    } catch (e) {
      throw CacheException(message: 'Failed to get prayer time from local storage');
    }
  }
  
  @override
  Future<List<PrayerTimeModel>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final List<PrayerTimeModel> result = [];
      
      // Iterate through each day in the range
      for (var date = startDate; date.isBefore(endDate.add(const Duration(days: 1))); date = date.add(const Duration(days: 1))) {
        final prayerTime = await getPrayerTimeByDate(date);
        if (prayerTime != null) {
          result.add(prayerTime);
        }
      }
      
      return result;
    } catch (e) {
      throw CacheException(message: 'Failed to get prayer times from local storage');
    }
  }
  
  @override
  Future<void> savePrayerTime(PrayerTimeModel prayerTime) async {
    try {
      // Create a key for the date (YYYY-MM-DD)
      final key = '${prayerTime.date.year}-${prayerTime.date.month.toString().padLeft(2, '0')}-${prayerTime.date.day.toString().padLeft(2, '0')}';
      
      await prayerTimesBox.put(
        key,
        json.encode(prayerTime.toJson()),
      );
    } catch (e) {
      throw CacheException(message: 'Failed to save prayer time to local storage');
    }
  }
  
  @override
  Future<void> savePrayerTimes(List<PrayerTimeModel> prayerTimes) async {
    try {
      for (final prayerTime in prayerTimes) {
        await savePrayerTime(prayerTime);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to save prayer times to local storage');
    }
  }
  
  @override
  Future<String> getCalculationMethod() async {
    try {
      return sharedPreferences.getString('calculationMethod') ?? 
             AppConstants.defaultCalculationMethod;
    } catch (e) {
      throw CacheException(message: 'Failed to get calculation method from local storage');
    }
  }
  
  @override
  Future<void> updateCalculationMethod(String method) async {
    try {
      await sharedPreferences.setString('calculationMethod', method);
    } catch (e) {
      throw CacheException(message: 'Failed to update calculation method in local storage');
    }
  }
}
