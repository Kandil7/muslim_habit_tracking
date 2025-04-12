import 'package:adhan/adhan.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/prayer_time.dart';
import '../models/prayer_time_model.dart';

/// Service for calculating prayer times using adhan_dart
class PrayerCalculationService {
  final Uuid uuid;

  PrayerCalculationService({required this.uuid});

  /// Calculate prayer times for a specific date
  PrayerTimeModel calculatePrayerTimes({
    required DateTime date,
    required double latitude,
    required double longitude,
    required String calculationMethod,
  }) {
    // try {
      // Create coordinates
      final coordinates = Coordinates(latitude, longitude);

      // Create date components
      final dateComponents = DateComponents(date.year, date.month, date.day);

      // Get calculation method
      final method = _getCalculationMethod(calculationMethod);

      // Create parameters with appropriate adjustments for different methods
      final params = CalculationParameters(
        method: method,
        madhab: Madhab.shafi,
        fajrAngle: 19.5
      );

      // Adjust parameters based on calculation method
      if (calculationMethod == 'Jafari') {
        // Jafari specific adjustments
        params.fajrAngle = 16.0;
        params.ishaAngle = 14.0;
        params.methodAdjustments = PrayerAdjustments(
          fajr: 0,
          sunrise: 0,
          dhuhr: 0,
          asr: 0,
          maghrib: 0,
          isha: 0,
        );
      }

      // Calculate prayer times
      final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

      // Create prayer time model
      return PrayerTimeModel(
        id: uuid.v4(),
        date: date,
        fajr: prayerTimes.fajr.toLocal(),
        sunrise: prayerTimes.sunrise.toLocal(),
        dhuhr: prayerTimes.dhuhr.toLocal(),
        asr: prayerTimes.asr.toLocal(),
        maghrib: prayerTimes.maghrib.toLocal(),
        isha: prayerTimes.isha.toLocal(),
        calculationMethod: calculationMethod,
      );
    // } catch (e) {
    //   // If there's an error, use default prayer times
    //   print('Error calculating prayer times: $e');
    //   return _getDefaultPrayerTimes(date, calculationMethod);
    // }
  }

  /// Get default prayer times when calculation fails
  PrayerTimeModel _getDefaultPrayerTimes(DateTime date, String calculationMethod) {
    // Create a default prayer time model with standard times
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return PrayerTimeModel(
      id: uuid.v4(),
      date: date,
      fajr: DateTime(today.year, today.month, today.day, 5, 0),
      sunrise: DateTime(today.year, today.month, today.day, 6, 30),
      dhuhr: DateTime(today.year, today.month, today.day, 12, 0),
      asr: DateTime(today.year, today.month, today.day, 15, 30),
      maghrib: DateTime(today.year, today.month, today.day, 18, 0),
      isha: DateTime(today.year, today.month, today.day, 19, 30),
      calculationMethod: calculationMethod,
    );
  }

  /// Calculate prayer times for a date range
  List<PrayerTimeModel> calculatePrayerTimesRange({
    required DateTime startDate,
    required DateTime endDate,
    required double latitude,
    required double longitude,
    required String calculationMethod,
  }) {
    final List<PrayerTimeModel> result = [];

    // Iterate through each day in the range
    for (var date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final prayerTime = calculatePrayerTimes(
        date: DateTime(date.year, date.month, date.day),
        latitude: latitude,
        longitude: longitude,
        calculationMethod: calculationMethod,
      );
      result.add(prayerTime);
    }

    return result;
  }

  /// Get calculation method from string
  CalculationMethod _getCalculationMethod(String method) {
    switch (method) {
      case 'MWL':
        return CalculationMethod.muslim_world_league;
      case 'ISNA':
        return CalculationMethod.north_america;
      case 'Egypt':
        return CalculationMethod.egyptian;
      case 'Makkah':
        return CalculationMethod.umm_al_qura;
      case 'Karachi':
        return CalculationMethod.karachi;
      case 'Tehran':
        return CalculationMethod.tehran;
      case 'Jafari':
        // For Jafari/Shia method, we'll use other_shia from the adhan package
        return CalculationMethod.other;
      default:
        return CalculationMethod.muslim_world_league;
    }
  }

  /// Get available calculation methods
  Map<String, String> getAvailableCalculationMethods() {
    return {
      'MWL': 'Muslim World League',
      'ISNA': 'Islamic Society of North America',
      'Egypt': 'Egyptian General Authority of Survey',
      'Makkah': 'Umm Al-Qura University, Makkah',
      'Karachi': 'University of Islamic Sciences, Karachi',
      'Tehran': 'Institute of Geophysics, University of Tehran',
      'Jafari': 'Shia Ithna-Ashari, Leva Institute, Qum',
    };
  }
}
