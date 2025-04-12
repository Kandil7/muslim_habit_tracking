import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/prayer_time_model.dart';
import '../services/prayer_calculation_service.dart';

/// Interface for remote data source for prayer times
abstract class PrayerTimeRemoteDataSource {
  /// Get prayer times for a specific date
  Future<PrayerTimeModel> getPrayerTimeByDate(
    DateTime date,
    double latitude,
    double longitude,
    String calculationMethod,
  );

  /// Get prayer times for a date range
  Future<List<PrayerTimeModel>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
    double latitude,
    double longitude,
    String calculationMethod,
  );

  /// Get available calculation methods
  Future<Map<String, String>> getAvailableCalculationMethods();
}

/// Implementation of PrayerTimeRemoteDataSource using adhan_dart
class PrayerTimeRemoteDataSourceImpl implements PrayerTimeRemoteDataSource {
  final Uuid uuid;
  late final PrayerCalculationService _prayerCalculationService;

  PrayerTimeRemoteDataSourceImpl({
    required this.uuid,
  }) {
    _prayerCalculationService = PrayerCalculationService(uuid: uuid);
  }

  @override
  Future<PrayerTimeModel> getPrayerTimeByDate(
    DateTime date,
    double latitude,
    double longitude,
    String calculationMethod,
  ) async {
    try {
      return _prayerCalculationService.calculatePrayerTimes(
        date: date,
        latitude: latitude,
        longitude: longitude,
        calculationMethod: calculationMethod,
      );
    } catch (e) {
      throw ServerException(message: 'Failed to calculate prayer times: ${e.toString()}');
    }
  }

  @override
  Future<List<PrayerTimeModel>> getPrayerTimesByDateRange(
    DateTime startDate,
    DateTime endDate,
    double latitude,
    double longitude,
    String calculationMethod,
  ) async {
    try {
      return _prayerCalculationService.calculatePrayerTimesRange(
        startDate: startDate,
        endDate: endDate,
        latitude: latitude,
        longitude: longitude,
        calculationMethod: calculationMethod,
      );
    } catch (e) {
      throw ServerException(message: 'Failed to calculate prayer times: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, String>> getAvailableCalculationMethods() async {
    try {
      return _prayerCalculationService.getAvailableCalculationMethods();
    } catch (e) {
      throw ServerException(message: 'Failed to get calculation methods: ${e.toString()}');
    }
  }
}
