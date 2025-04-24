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

  // Monthly and yearly data
  final Map<String, double> monthlyCompletionRates;
  final Map<String, double> yearlyCompletionRates;

  // Goal tracking
  final int? targetStreak;
  final double? targetCompletionRate;
  final bool hasReachedGoal;

  const HabitStats({
    required this.habitId,
    required this.habitName,
    required this.completionCount,
    required this.totalDays,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
    required this.weekdayCompletion,
    this.monthlyCompletionRates = const {},
    this.yearlyCompletionRates = const {},
    this.targetStreak,
    this.targetCompletionRate,
    this.hasReachedGoal = false,
  });

  /// Create a copy of this HabitStats with the given fields replaced with new values
  HabitStats copyWith({
    String? habitId,
    String? habitName,
    int? completionCount,
    int? totalDays,
    double? completionRate,
    int? currentStreak,
    int? longestStreak,
    Map<String, int>? weekdayCompletion,
    Map<String, double>? monthlyCompletionRates,
    Map<String, double>? yearlyCompletionRates,
    int? targetStreak,
    double? targetCompletionRate,
    bool? hasReachedGoal,
  }) {
    return HabitStats(
      habitId: habitId ?? this.habitId,
      habitName: habitName ?? this.habitName,
      completionCount: completionCount ?? this.completionCount,
      totalDays: totalDays ?? this.totalDays,
      completionRate: completionRate ?? this.completionRate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      weekdayCompletion: weekdayCompletion ?? this.weekdayCompletion,
      monthlyCompletionRates:
          monthlyCompletionRates ?? this.monthlyCompletionRates,
      yearlyCompletionRates:
          yearlyCompletionRates ?? this.yearlyCompletionRates,
      targetStreak: targetStreak ?? this.targetStreak,
      targetCompletionRate: targetCompletionRate ?? this.targetCompletionRate,
      hasReachedGoal: hasReachedGoal ?? this.hasReachedGoal,
    );
  }

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
    monthlyCompletionRates,
    yearlyCompletionRates,
    targetStreak ?? 0,
    targetCompletionRate ?? 0.0,
    hasReachedGoal,
  ];
}
