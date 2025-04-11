import 'dart:convert';

import '../../domain/entities/habit_stats.dart';

/// Model class for HabitStats entity
class HabitStatsModel extends HabitStats {
  const HabitStatsModel({
    required super.habitId,
    required super.habitName,
    required super.completionCount,
    required super.totalDays,
    required super.completionRate,
    required super.currentStreak,
    required super.longestStreak,
    required super.weekdayCompletion,
  });
  
  /// Create a HabitStatsModel from a JSON map
  factory HabitStatsModel.fromJson(Map<String, dynamic> json) {
    return HabitStatsModel(
      habitId: json['habitId'],
      habitName: json['habitName'],
      completionCount: json['completionCount'],
      totalDays: json['totalDays'],
      completionRate: json['completionRate'],
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      weekdayCompletion: Map<String, int>.from(json['weekdayCompletion']),
    );
  }
  
  /// Convert this HabitStatsModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'habitName': habitName,
      'completionCount': completionCount,
      'totalDays': totalDays,
      'completionRate': completionRate,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'weekdayCompletion': weekdayCompletion,
    };
  }
  
  /// Create a HabitStatsModel from a HabitStats entity
  factory HabitStatsModel.fromEntity(HabitStats habitStats) {
    return HabitStatsModel(
      habitId: habitStats.habitId,
      habitName: habitStats.habitName,
      completionCount: habitStats.completionCount,
      totalDays: habitStats.totalDays,
      completionRate: habitStats.completionRate,
      currentStreak: habitStats.currentStreak,
      longestStreak: habitStats.longestStreak,
      weekdayCompletion: habitStats.weekdayCompletion,
    );
  }
}
