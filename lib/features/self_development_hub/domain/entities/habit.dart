import 'package:equatable/equatable.dart';

/// Entity representing a habit
class Habit extends Equatable {
  final String id;
  final String name;
  final String description;
  final HabitArea area; // Self, Ibadah, Skills
  final int targetFrequency; // Times per day/week
  final HabitFrequency frequencyType; // Daily, Weekly
  final int currentStreak;
  final int longestStreak;
  final Map<DateTime, bool> completionHistory; // Date -> Completed
  final DateTime startDate;
  final HabitStatus status;
  final List<String> tags;
  final String? reminderTime; // HH:MM format
  final int difficulty; // 1-5 scale
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.area,
    required this.targetFrequency,
    required this.frequencyType,
    required this.currentStreak,
    required this.longestStreak,
    required this.completionHistory,
    required this.startDate,
    required this.status,
    required this.tags,
    this.reminderTime,
    required this.difficulty,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        area,
        targetFrequency,
        frequencyType,
        currentStreak,
        longestStreak,
        completionHistory,
        startDate,
        status,
        tags,
        reminderTime,
        difficulty,
        isFavorite,
        createdAt,
        updatedAt,
      ];

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    HabitArea? area,
    int? targetFrequency,
    HabitFrequency? frequencyType,
    int? currentStreak,
    int? longestStreak,
    Map<DateTime, bool>? completionHistory,
    DateTime? startDate,
    HabitStatus? status,
    List<String>? tags,
    String? reminderTime,
    int? difficulty,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      area: area ?? this.area,
      targetFrequency: targetFrequency ?? this.targetFrequency,
      frequencyType: frequencyType ?? this.frequencyType,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      completionHistory: completionHistory ?? this.completionHistory,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      reminderTime: reminderTime ?? this.reminderTime,
      difficulty: difficulty ?? this.difficulty,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if habit was completed today
  bool get isCompletedToday {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    return completionHistory[todayKey] ?? false;
  }

  /// Get completion rate for the current period
  double get completionRate {
    if (completionHistory.isEmpty) return 0.0;
    
    final totalDays = completionHistory.length;
    final completedDays = completionHistory.values.where((completed) => completed).length;
    
    return (completedDays / totalDays) * 100;
  }
}

/// Enum for habit areas
enum HabitArea {
  self,
  ibadah,
  skills,
}

/// Enum for habit frequencies
enum HabitFrequency {
  daily,
  weekly,
}

/// Enum for habit statuses
enum HabitStatus {
  active,
  inactive,
  archived,
}