import 'package:equatable/equatable.dart';

/// Events for the analytics feature
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to get all habit stats
class GetAllHabitStatsEvent extends AnalyticsEvent {}

/// Event to get stats for a specific habit
class GetHabitStatsEvent extends AnalyticsEvent {
  final String habitId;
  
  const GetHabitStatsEvent({required this.habitId});
  
  @override
  List<Object?> get props => [habitId];
}

/// Event to get stats for habits within a date range
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

/// Event to get overall completion rate
class GetOverallCompletionRateEvent extends AnalyticsEvent {}

/// Event to get the most consistent habit
class GetMostConsistentHabitEvent extends AnalyticsEvent {}

/// Event to get the least consistent habit
class GetLeastConsistentHabitEvent extends AnalyticsEvent {}
