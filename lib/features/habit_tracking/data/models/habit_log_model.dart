import '../../domain/entities/habit_log.dart';

/// Model class for HabitLog entity
class HabitLogModel extends HabitLog {
  const HabitLogModel({
    required super.id,
    required super.habitId,
    required super.date,
    required super.value,
    required super.notes,
    required super.createdAt,
  });

  /// Create a HabitLogModel from a JSON map
  factory HabitLogModel.fromJson(Map<String, dynamic> json) {
    return HabitLogModel(
      id: json['id'],
      habitId: json['habitId'],
      date: DateTime.parse(json['date']),
      value: json['value'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Convert this HabitLogModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date.toIso8601String(),
      'value': value,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a HabitLogModel from a HabitLog entity
  factory HabitLogModel.fromEntity(HabitLog habitLog) {
    return HabitLogModel(
      id: habitLog.id,
      habitId: habitLog.habitId,
      date: habitLog.date,
      value: habitLog.value,
      notes: habitLog.notes,
      createdAt: habitLog.createdAt,
    );
  }

  /// Create a copy of this HabitLogModel with the given fields replaced with the new values
  @override
  HabitLogModel copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    int? value,
    String? notes,
    DateTime? createdAt,
  }) {
    return HabitLogModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      value: value ?? this.value,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
