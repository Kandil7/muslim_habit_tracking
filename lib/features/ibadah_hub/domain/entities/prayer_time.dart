import 'package:equatable/equatable.dart';

/// Entity representing prayer times
class PrayerTime extends Equatable {
  final String id;
  final PrayerType prayerType;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final bool isCompleted;
  final int reminderMinutes; // minutes before prayer for reminder
  final bool hasPreReminder; // 15 mins before Adhan
  final DateTime createdAt;
  final DateTime updatedAt;

  const PrayerTime({
    required this.id,
    required this.prayerType,
    required this.scheduledTime,
    this.actualTime,
    required this.isCompleted,
    required this.reminderMinutes,
    required this.hasPreReminder,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        prayerType,
        scheduledTime,
        actualTime,
        isCompleted,
        reminderMinutes,
        hasPreReminder,
        createdAt,
        updatedAt,
      ];

  PrayerTime copyWith({
    String? id,
    PrayerType? prayerType,
    DateTime? scheduledTime,
    DateTime? actualTime,
    bool? isCompleted,
    int? reminderMinutes,
    bool? hasPreReminder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrayerTime(
      id: id ?? this.id,
      prayerType: prayerType ?? this.prayerType,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      actualTime: actualTime ?? this.actualTime,
      isCompleted: isCompleted ?? this.isCompleted,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      hasPreReminder: hasPreReminder ?? this.hasPreReminder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum for prayer types
enum PrayerType {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha,
}

/// Extension to get prayer name
extension PrayerTypeName on PrayerType {
  String get name {
    switch (this) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
    }
  }
}