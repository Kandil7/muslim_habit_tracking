import '../../domain/entities/prayer_time.dart';

/// Model class for PrayerTime entity
class PrayerTimeModel extends PrayerTime {
  /// Creates a new PrayerTimeModel
  const PrayerTimeModel({
    required super.date,
    required super.fajr,
    required super.sunrise,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
  });

  /// Create a PrayerTimeModel from a JSON map
  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      date: DateTime.parse(json['date']),
      fajr: DateTime.parse(json['fajr']),
      sunrise: DateTime.parse(json['sunrise']),
      dhuhr: DateTime.parse(json['dhuhr']),
      asr: DateTime.parse(json['asr']),
      maghrib: DateTime.parse(json['maghrib']),
      isha: DateTime.parse(json['isha']),
    );
  }

  /// Convert this PrayerTimeModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'fajr': fajr.toIso8601String(),
      'sunrise': sunrise.toIso8601String(),
      'dhuhr': dhuhr.toIso8601String(),
      'asr': asr.toIso8601String(),
      'maghrib': maghrib.toIso8601String(),
      'isha': isha.toIso8601String(),
    };
  }

  /// Create a PrayerTimeModel from a PrayerTime entity
  factory PrayerTimeModel.fromEntity(PrayerTime entity) {
    return PrayerTimeModel(
      date: entity.date,
      fajr: entity.fajr,
      sunrise: entity.sunrise,
      dhuhr: entity.dhuhr,
      asr: entity.asr,
      maghrib: entity.maghrib,
      isha: entity.isha,
    );
  }
}
