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
  final domain.MemorizationStatistics statistics;

  MemorizationStatisticsLoaded(this.statistics);
}

/// State when detailed statistics are loaded
class DetailedStatisticsLoaded extends MemorizationState {
  final domain.DetailedMemorizationStatistics detailedStatistics;

  DetailedStatisticsLoaded(this.detailedStatistics);
}

/// State when an operation is successful
class MemorizationOperationSuccess extends MemorizationState {
  final MemorizationItem? item;

  MemorizationOperationSuccess([this.item]);
}

/// State when items by status are loaded
class ItemsByStatusLoaded extends MemorizationState {
  final MemorizationStatus status;
  final List<MemorizationItem> items;

  ItemsByStatusLoaded(this.status, this.items);
}

/// State when overdue items are loaded
class OverdueItemsLoaded extends MemorizationState {
  final List<MemorizationItem> items;

  OverdueItemsLoaded(this.items);
}

/// State when items needing review are loaded
class ItemsNeedingReviewLoaded extends MemorizationState {
  final List<MemorizationItem> items;

  ItemsNeedingReviewLoaded(this.items);
}

/// State when item review history is loaded
class ItemReviewHistoryLoaded extends MemorizationState {
  final String itemId;
  final List<DateTime> reviewHistory;

  ItemReviewHistoryLoaded(this.itemId, this.reviewHistory);
}

/// State when items by surah are loaded
class ItemsBySurahLoaded extends MemorizationState {
  final int surahNumber;
  final List<MemorizationItem> items;

  ItemsBySurahLoaded(this.surahNumber, this.items);
}

/// State when items by date range are loaded
class ItemsByDateRangeLoaded extends MemorizationState {
  final DateTime start;
  final DateTime end;
  final List<MemorizationItem> items;

  ItemsByDateRangeLoaded(this.start, this.end, this.items);
}

/// State when streak statistics are loaded
class StreakStatisticsLoaded extends MemorizationState {
  final streak_entity.StreakStatistics streakStatistics;

  StreakStatisticsLoaded(this.streakStatistics);
}

/// State when progress statistics are loaded
class ProgressStatisticsLoaded extends MemorizationState {
  final progress_entity.ProgressStatistics progressStatistics;

  ProgressStatisticsLoaded(this.progressStatistics);
}