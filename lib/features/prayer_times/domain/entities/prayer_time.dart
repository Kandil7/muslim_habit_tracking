import 'package:equatable/equatable.dart';

/// PrayerTime entity representing prayer times for a specific date
class PrayerTime extends Equatable {
  /// Date for these prayer times
  final DateTime date;
  
  /// Fajr prayer time
  final DateTime fajr;
  
  /// Sunrise time
  final DateTime sunrise;
  
  /// Dhuhr prayer time
  final DateTime dhuhr;
  
  /// Asr prayer time
  final DateTime asr;
  
  /// Maghrib prayer time
  final DateTime maghrib;
  
  /// Isha prayer time
  final DateTime isha;

  /// Creates a new PrayerTime
  const PrayerTime({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  @override
  List<Object> get props => [
    date,
    fajr,
    sunrise,
    dhuhr,
    asr,
    maghrib,
    isha,
  ];
  
  /// Get the next prayer time from the current time
  Map<String, DateTime> getNextPrayer() {
    final now = DateTime.now();
    
    if (now.isBefore(fajr)) {
      return {'Fajr': fajr};
    } else if (now.isBefore(sunrise)) {
      return {'Sunrise': sunrise};
    } else if (now.isBefore(dhuhr)) {
      return {'Dhuhr': dhuhr};
    } else if (now.isBefore(asr)) {
      return {'Asr': asr};
    } else if (now.isBefore(maghrib)) {
      return {'Maghrib': maghrib};
    } else if (now.isBefore(isha)) {
      return {'Isha': isha};
    } else {
      // After Isha, next prayer is Fajr of the next day
      return {'Fajr (Tomorrow)': fajr.add(const Duration(days: 1))};
    }
  }
  
  /// Get the current prayer time
  Map<String, DateTime>? getCurrentPrayer() {
    final now = DateTime.now();
    
    if (now.isAfter(fajr) && now.isBefore(sunrise)) {
      return {'Fajr': fajr};
    } else if (now.isAfter(dhuhr) && now.isBefore(asr)) {
      return {'Dhuhr': dhuhr};
    } else if (now.isAfter(asr) && now.isBefore(maghrib)) {
      return {'Asr': asr};
    } else if (now.isAfter(maghrib) && now.isBefore(isha)) {
      return {'Maghrib': maghrib};
    } else if (now.isAfter(isha)) {
      return {'Isha': isha};
    }
    
    return null;
  }
  
  /// Get all prayer times as a map
  Map<String, DateTime> getAllPrayers() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }
}
