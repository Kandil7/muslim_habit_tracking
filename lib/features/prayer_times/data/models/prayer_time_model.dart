import 'dart:convert';

import '../../domain/entities/prayer_time.dart';

/// Model class for PrayerTime entity
class PrayerTimeModel extends PrayerTime {
  const PrayerTimeModel({
    required super.id,
    required super.date,
    required super.fajr,
    required super.sunrise,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
    required super.calculationMethod,
  });
  
  /// Create a PrayerTimeModel from a JSON map
  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      fajr: DateTime.parse(json['fajr']),
      sunrise: DateTime.parse(json['sunrise']),
      dhuhr: DateTime.parse(json['dhuhr']),
      asr: DateTime.parse(json['asr']),
      maghrib: DateTime.parse(json['maghrib']),
      isha: DateTime.parse(json['isha']),
      calculationMethod: json['calculationMethod'],
    );
  }
  
  /// Convert this PrayerTimeModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'fajr': fajr.toIso8601String(),
      'sunrise': sunrise.toIso8601String(),
      'dhuhr': dhuhr.toIso8601String(),
      'asr': asr.toIso8601String(),
      'maghrib': maghrib.toIso8601String(),
      'isha': isha.toIso8601String(),
      'calculationMethod': calculationMethod,
    };
  }
  
  /// Create a PrayerTimeModel from a PrayerTime entity
  factory PrayerTimeModel.fromEntity(PrayerTime prayerTime) {
    return PrayerTimeModel(
      id: prayerTime.id,
      date: prayerTime.date,
      fajr: prayerTime.fajr,
      sunrise: prayerTime.sunrise,
      dhuhr: prayerTime.dhuhr,
      asr: prayerTime.asr,
      maghrib: prayerTime.maghrib,
      isha: prayerTime.isha,
      calculationMethod: prayerTime.calculationMethod,
    );
  }
  
  /// Create a copy of this PrayerTimeModel with the given fields replaced with the new values
  @override
  PrayerTimeModel copyWith({
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
    return PrayerTimeModel(
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
  
  /// Create a PrayerTimeModel from the Aladhan API response
  factory PrayerTimeModel.fromAladhanApi(Map<String, dynamic> json, String id, String calculationMethod) {
    final date = DateTime.parse(json['date']['gregorian']['date']);
    final timings = json['timings'];
    
    // Convert prayer time strings to DateTime objects
    DateTime convertToDateTime(String timeString, DateTime date) {
      // Remove the timezone part (e.g., "(EET)")
      final time = timeString.split(' ')[0];
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      return DateTime(
        date.year,
        date.month,
        date.day,
        hour,
        minute,
      );
    }
    
    return PrayerTimeModel(
      id: id,
      date: date,
      fajr: convertToDateTime(timings['Fajr'], date),
      sunrise: convertToDateTime(timings['Sunrise'], date),
      dhuhr: convertToDateTime(timings['Dhuhr'], date),
      asr: convertToDateTime(timings['Asr'], date),
      maghrib: convertToDateTime(timings['Maghrib'], date),
      isha: convertToDateTime(timings['Isha'], date),
      calculationMethod: calculationMethod,
    );
  }
}
