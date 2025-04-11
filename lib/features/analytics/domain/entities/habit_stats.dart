import 'package:equatable/equatable.dart';

/// HabitStats entity representing statistics for a habit
class HabitStats extends Equatable {
  final String habitId;
  final String habitName;
  final int completionCount;
  final int totalDays;
  final double completionRate;
  final int currentStreak;
  final int longestStreak;
  final Map<String, int> weekdayCompletion;
  
  const HabitStats({
    required this.habitId,
    required this.habitName,
    required this.completionCount,
    required this.totalDays,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.weekdayCompletion,
  });
  
  @override
  List<Object> get props => [
    habitId,
    habitName,
    completionCount,
    totalDays,
    completionRate,
    currentStreak,
    longestStreak,
    weekdayCompletion,
  ];
}
