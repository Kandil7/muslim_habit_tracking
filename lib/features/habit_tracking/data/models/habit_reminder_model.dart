import '../../domain/entities/habit_reminder.dart';

/// Model class for HabitReminder entity
class HabitReminderModel extends HabitReminder {
  const HabitReminderModel({
    required super.id,
    required super.habitId,
    required super.hour,
    required super.minute,
    required super.daysOfWeek,
    required super.isEnabled,
    required super.createdAt,
  });
  
  /// Create a HabitReminderModel from a JSON map
  factory HabitReminderModel.fromJson(Map<String, dynamic> json) {
    return HabitReminderModel(
      id: json['id'],
      habitId: json['habitId'],
      hour: json['hour'],
      minute: json['minute'],
      daysOfWeek: List<String>.from(json['daysOfWeek']),
      isEnabled: json['isEnabled'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  /// Convert this HabitReminderModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'hour': hour,
      'minute': minute,
      'daysOfWeek': daysOfWeek,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// Create a HabitReminderModel from a HabitReminder entity
  factory HabitReminderModel.fromEntity(HabitReminder reminder) {
    return HabitReminderModel(
      id: reminder.id,
      habitId: reminder.habitId,
      hour: reminder.hour,
      minute: reminder.minute,
      daysOfWeek: reminder.daysOfWeek,
      isEnabled: reminder.isEnabled,
      createdAt: reminder.createdAt,
    );
  }
  
  /// Create a copy of this HabitReminderModel with the given fields replaced with the new values
  @override
  HabitReminderModel copyWith({
    String? id,
    String? habitId,
    int? hour,
    int? minute,
    List<String>? daysOfWeek,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return HabitReminderModel(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
