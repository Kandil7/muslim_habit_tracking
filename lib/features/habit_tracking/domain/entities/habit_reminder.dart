import 'package:equatable/equatable.dart';

/// HabitReminder entity representing a reminder for a habit
class HabitReminder extends Equatable {
  final String id;
  final String habitId;
  final int hour;
  final int minute;
  final List<String> daysOfWeek;
  final bool isEnabled;
  final DateTime createdAt;
  
  const HabitReminder({
    required this.id,
    required this.habitId,
    required this.hour,
    required this.minute,
    required this.daysOfWeek,
    required this.isEnabled,
    required this.createdAt,
  });
  
  @override
  List<Object> get props => [
    id,
    habitId,
    hour,
    minute,
    daysOfWeek,
    isEnabled,
    createdAt,
  ];
  
  /// Create a copy of this HabitReminder with the given fields replaced with the new values
  HabitReminder copyWith({
    String? id,
    String? habitId,
    int? hour,
    int? minute,
    List<String>? daysOfWeek,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return HabitReminder(
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
