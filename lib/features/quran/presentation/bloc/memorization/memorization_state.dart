part of 'memorization_bloc.dart';

/// Base state class for memorization
abstract class MemorizationState {}

/// Initial state
class MemorizationInitial extends MemorizationState {}

/// Loading state
class MemorizationLoading extends MemorizationState {}

/// Error state
class MemorizationError extends MemorizationState {
  final String message;

  MemorizationError(this.message);
}

/// State when memorization items are loaded
class MemorizationItemsLoaded extends MemorizationState {
  final List<MemorizationItem> items;

  MemorizationItemsLoaded(this.items);
}

/// State when daily review schedule is loaded
class DailyReviewScheduleLoaded extends MemorizationState {
  final ReviewSchedule schedule;

  DailyReviewScheduleLoaded(this.schedule);
}

/// State when memorization preferences are loaded
class MemorizationPreferencesLoaded extends MemorizationState {
  final MemorizationPreferences preferences;

  MemorizationPreferencesLoaded(this.preferences);
}

/// State when memorization statistics are loaded
class MemorizationStatisticsLoaded extends MemorizationState {
  final MemorizationStatistics statistics;

  MemorizationStatisticsLoaded(this.statistics);
}

/// State when detailed statistics are loaded
class DetailedStatisticsLoaded extends MemorizationState {
  final DetailedMemorizationStatistics detailedStatistics;

  DetailedStatisticsLoaded(this.detailedStatistics);
}

/// State when an operation is successful
class MemorizationOperationSuccess extends MemorizationState {
  final MemorizationItem? item;

  const MemorizationOperationSuccess([this.item]);
}