import 'package:muslim_habbit/features/ibadah_hub/domain/entities/prayer_time.dart';

/// Data model for PrayerTime that extends the entity with serialization methods
class PrayerTimeModel extends PrayerTime {
  const PrayerTimeModel({
    required super.id,
    required super.prayerType,
    required super.scheduledTime,
    super.actualTime,
    required super.isCompleted,
    required super.reminderMinutes,
    required super.hasPreReminder,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Factory method to create from entity
  factory PrayerTimeModel.fromEntity(PrayerTime entity) {
    return PrayerTimeModel(
      id: entity.id,
      prayerType: entity.prayerType,
      scheduledTime: entity.scheduledTime,
      actualTime: entity.actualTime,
      isCompleted: entity.isCompleted,
      reminderMinutes: entity.reminderMinutes,
      hasPreReminder: entity.hasPreReminder,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Factory method to create from JSON
  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      id: json['id'] as String,
      prayerType: _prayerTypeFromString(json['prayerType'] as String),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      actualTime: json['actualTime'] != null ? DateTime.parse(json['actualTime'] as String) : null,
      isCompleted: json['isCompleted'] as bool,
      reminderMinutes: json['reminderMinutes'] as int,
      hasPreReminder: json['hasPreReminder'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prayerType': _prayerTypeToString(prayerType),
      'scheduledTime': scheduledTime.toIso8601String(),
      'actualTime': actualTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'reminderMinutes': reminderMinutes,
      'hasPreReminder': hasPreReminder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert prayer type to string
  String _prayerTypeToString(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return 'fajr';
      case PrayerType.dhuhr:
        return 'dhuhr';
      case PrayerType.asr:
        return 'asr';
      case PrayerType.maghrib:
        return 'maghrib';
      case PrayerType.isha:
        return 'isha';
    }
  }

  /// Convert string to prayer type
  static PrayerType _prayerTypeFromString(String type) {
    switch (type) {
      case 'fajr':
        return PrayerType.fajr;
      case 'dhuhr':
        return PrayerType.dhuhr;
      case 'asr':
        return PrayerType.asr;
      case 'maghrib':
        return PrayerType.maghrib;
      case 'isha':
        return PrayerType.isha;
      default:
        return PrayerType.fajr;
    }
  }
}