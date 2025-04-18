import 'package:equatable/equatable.dart';

/// Base class for all Analytics events
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to get all habit statistics
class GetAllHabitStatsEvent extends AnalyticsEvent {
  const GetAllHabitStatsEvent();
}

/// Event to get statistics for a specific habit
class GetHabitStatsEvent extends AnalyticsEvent {
  final String habitId;

  const GetHabitStatsEvent({required this.habitId});

  @override
  List<Object?> get props => [habitId];
}

/// Event to get statistics for habits within a date range
class GetHabitStatsByDateRangeEvent extends AnalyticsEvent {
  final DateTime startDate;
  final DateTime endDate;

  const GetHabitStatsByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event to get overall completion rate for all habits
class GetOverallCompletionRateEvent extends AnalyticsEvent {
  const GetOverallCompletionRateEvent();
}

/// Event to get the most consistent habit
class GetMostConsistentHabitEvent extends AnalyticsEvent {
  const GetMostConsistentHabitEvent();
}

/// Event to get the least consistent habit
class GetLeastConsistentHabitEvent extends AnalyticsEvent {
  const GetLeastConsistentHabitEvent();
}
