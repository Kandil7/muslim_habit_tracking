import 'package:equatable/equatable.dart';

import '../../domain/entities/habit_stats.dart';

/// States for the analytics feature
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class AnalyticsInitial extends AnalyticsState {}

/// Loading state
class AnalyticsLoading extends AnalyticsState {}

/// State when all habit stats are loaded
class AllHabitStatsLoaded extends AnalyticsState {
  final List<HabitStats> habitStats;
  
  const AllHabitStatsLoaded({required this.habitStats});
  
  @override
  List<Object?> get props => [habitStats];
}

/// State when a single habit's stats are loaded
class HabitStatsLoaded extends AnalyticsState {
  final HabitStats habitStats;
  
  const HabitStatsLoaded({required this.habitStats});
  
  @override
  List<Object?> get props => [habitStats];
}

/// State when habit stats by date range are loaded
class HabitStatsByDateRangeLoaded extends AnalyticsState {
  final List<HabitStats> habitStats;
  final DateTime startDate;
  final DateTime endDate;
  
  const HabitStatsByDateRangeLoaded({
    required this.habitStats,
    required this.startDate,
    required this.endDate,
  });
  
  @override
  List<Object?> get props => [habitStats, startDate, endDate];
}

/// State when overall completion rate is loaded
class OverallCompletionRateLoaded extends AnalyticsState {
  final double completionRate;
  
  const OverallCompletionRateLoaded({required this.completionRate});
  
  @override
  List<Object?> get props => [completionRate];
}

/// State when most consistent habit is loaded
class MostConsistentHabitLoaded extends AnalyticsState {
  final HabitStats habitStats;
  
  const MostConsistentHabitLoaded({required this.habitStats});
  
  @override
  List<Object?> get props => [habitStats];
}

/// State when least consistent habit is loaded
class LeastConsistentHabitLoaded extends AnalyticsState {
  final HabitStats habitStats;
  
  const LeastConsistentHabitLoaded({required this.habitStats});
  
  @override
  List<Object?> get props => [habitStats];
}

/// Error state
class AnalyticsError extends AnalyticsState {
  final String message;
  
  const AnalyticsError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
