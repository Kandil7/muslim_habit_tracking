import 'package:equatable/equatable.dart';

/// PrayerTime entity representing prayer times for a specific day
class PrayerTime extends Equatable {
  final String id;
  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final String calculationMethod;
  
  const PrayerTime({
    required this.id,
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.calculationMethod,
  });
  
  @override
  List<Object> get props => [
    id,
    date,
    fajr,
    sunrise,
    dhuhr,
    asr,
    maghrib,
    isha,
    calculationMethod,
  ];
  
  /// Create a copy of this PrayerTime with the given fields replaced with the new values
  PrayerTime copyWith({
    String? id,
    DateTime? date,
    DateTime? fajr,
    DateTime? sunrise,
    DateTime? dhuhr,
    DateTime? asr,
    DateTime? maghrib,
    DateTime? isha,
    String? calculationMethod,
  }) {
    return PrayerTime(
      id: id ?? this.id,
      date: date ?? this.date,
      fajr: fajr ?? this.fajr,
      sunrise: sunrise ?? this.sunrise,
      dhuhr: dhuhr ?? this.dhuhr,
      asr: asr ?? this.asr,
      maghrib: maghrib ?? this.maghrib,
      isha: isha ?? this.isha,
      calculationMethod: calculationMethod ?? this.calculationMethod,
    );
  }
  
  /// Get the next prayer time from the current time
  Map<String, DateTime> getNextPrayer(DateTime currentTime) {
    final prayers = {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
    
    String nextPrayerName = 'Fajr';
    DateTime nextPrayerTime = fajr;
    
    // If all prayers have passed for today, return Fajr for tomorrow
    if (currentTime.isAfter(isha)) {
      return {'Fajr': fajr.add(const Duration(days: 1))};
    }
    
    // Find the next prayer
    for (final entry in prayers.entries) {
      if (currentTime.isBefore(entry.value)) {
        nextPrayerName = entry.key;
        nextPrayerTime = entry.value;
        break;
      }
    }
    
    return {nextPrayerName: nextPrayerTime};
  }
  
  /// Get the current prayer time (the last prayer that has occurred)
  String getCurrentPrayer(DateTime currentTime) {
    if (currentTime.isBefore(fajr)) {
      return 'Isha'; // From previous day
    } else if (currentTime.isBefore(sunrise)) {
      return 'Fajr';
    } else if (currentTime.isBefore(dhuhr)) {
      return 'Sunrise';
    } else if (currentTime.isBefore(asr)) {
      return 'Dhuhr';
    } else if (currentTime.isBefore(maghrib)) {
      return 'Asr';
    } else if (currentTime.isBefore(isha)) {
      return 'Maghrib';
    } else {
      return 'Isha';
    }
  }
}
