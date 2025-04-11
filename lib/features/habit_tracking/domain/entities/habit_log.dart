import 'package:equatable/equatable.dart';

/// HabitLog entity representing a log entry for a habit
class HabitLog extends Equatable {
  final String id;
  final String habitId;
  final DateTime date;
  final int value;
  final String notes;
  final DateTime createdAt;
  
  const HabitLog({
    required this.id,
    required this.habitId,
    required this.date,
    required this.value,
    required this.notes,
    required this.createdAt,
  });
  
  @override
  List<Object> get props => [
    id,
    habitId,
    date,
    value,
    notes,
    createdAt,
  ];
  
  /// Create a copy of this HabitLog with the given fields replaced with the new values
  HabitLog copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    int? value,
    String? notes,
    DateTime? createdAt,
  }) {
    return HabitLog(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      value: value ?? this.value,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
