import 'package:equatable/equatable.dart';
import '../../domain/entities/habit_stats.dart';

/// Base class for all Analytics states
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

/// Initial state for the Analytics feature
class AnalyticsInitial extends AnalyticsState {}

/// State when analytics data is being loaded
class AnalyticsLoading extends AnalyticsState {}

/// State when an error occurs
class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when all habit statistics have been loaded
class AllHabitStatsLoaded extends AnalyticsState {
  final List<HabitStats> habitStats;

  const AllHabitStatsLoaded({required this.habitStats});

  @override
  List<Object?> get props => [habitStats];
}

/// State when statistics for a specific habit have been loaded
class HabitStatsLoaded extends AnalyticsState {
  final HabitStats habitStats;

  const HabitStatsLoaded({required this.habitStats});

  @override
  List<Object?> get props => [habitStats];
}

/// State when statistics for habits within a date range have been loaded
class HabitStatsByDateRangeLoaded extends AnalyticsState {
  final List<HabitStats> habitStats;

  const HabitStatsByDateRangeLoaded({required this.habitStats});

  @override
  List<Object?> get props => [habitStats];
}

/// State when overall completion rate has been loaded
class OverallCompletionRateLoaded extends AnalyticsState {
  final double completionRate;

  const OverallCompletionRateLoaded({required this.completionRate});

  @override
  List<Object?> get props => [completionRate];
}

/// State when the most consistent habit has been loaded
class MostConsistentHabitLoaded extends AnalyticsState {
  final HabitStats habitStats;

  const MostConsistentHabitLoaded({required this.habitStats});

  @override
  List<Object?> get props => [habitStats];
}

/// State when the least consistent habit has been loaded
class LeastConsistentHabitLoaded extends AnalyticsState {
  final HabitStats habitStats;

  const LeastConsistentHabitLoaded({required this.habitStats});

  @override
  List<Object?> get props => [habitStats];
}
