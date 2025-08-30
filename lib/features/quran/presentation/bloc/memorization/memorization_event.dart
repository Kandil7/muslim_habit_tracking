part of 'memorization_bloc.dart';

/// Base event class for memorization
abstract class MemorizationEvent {}

/// Event to load memorization items
class LoadMemorizationItems extends MemorizationEvent {}

/// Event to load daily review schedule
class LoadDailyReviewSchedule extends MemorizationEvent {}

/// Event to load memorization preferences
class LoadMemorizationPreferences extends MemorizationEvent {}

/// Event to load memorization statistics
class LoadMemorizationStatistics extends MemorizationEvent {}

/// Event to load detailed statistics
class LoadDetailedStatistics extends MemorizationEvent {}

/// Event to create a memorization item
class CreateMemorizationItemEvent extends MemorizationEvent {
  final MemorizationItem item;

  CreateMemorizationItemEvent(this.item);
}

/// Event to update a memorization item
class UpdateMemorizationItemEvent extends MemorizationEvent {
  final MemorizationItem item;

  UpdateMemorizationItemEvent(this.item);
}

/// Event to delete a memorization item
class DeleteMemorizationItemEvent extends MemorizationEvent {
  final String itemId;

  DeleteMemorizationItemEvent(this.itemId);
}

/// Event to mark an item as reviewed
class MarkItemAsReviewedEvent extends MemorizationEvent {
  final String itemId;

  MarkItemAsReviewedEvent(this.itemId);
}

/// Event to update preferences
class UpdatePreferences extends MemorizationEvent {
  final MemorizationPreferences preferences;

  UpdatePreferences(this.preferences);
}

/// Event to load items by status
class LoadItemsByStatus extends MemorizationEvent {
  final MemorizationStatus status;

  LoadItemsByStatus(this.status);
}

/// Event to archive an item
class ArchiveItemEvent extends MemorizationEvent {
  final String itemId;

  ArchiveItemEvent(this.itemId);
}

/// Event to unarchive an item
class UnarchiveItemEvent extends MemorizationEvent {
  final String itemId;

  UnarchiveItemEvent(this.itemId);
}

/// Event to load overdue items
class LoadOverdueItems extends MemorizationEvent {}

/// Event to reset item progress
class ResetItemProgressEvent extends MemorizationEvent {
  final String itemId;

  ResetItemProgressEvent(this.itemId);
}

/// Event to load items needing review
class LoadItemsNeedingReview extends MemorizationEvent {}

/// Event to load item review history
class LoadItemReviewHistory extends MemorizationEvent {
  final String itemId;

  LoadItemReviewHistory(this.itemId);
}

/// Event to load items by surah
class LoadItemsBySurah extends MemorizationEvent {
  final int surahNumber;

  LoadItemsBySurah(this.surahNumber);
}

/// Event to load items by date range
class LoadItemsByDateRange extends MemorizationEvent {
  final DateTime start;
  final DateTime end;

  LoadItemsByDateRange(this.start, this.end);
}

/// Event to load streak statistics
class LoadStreakStatistics extends MemorizationEvent {}

/// Event to load progress statistics
class LoadProgressStatistics extends MemorizationEvent {
  final DateTime start;
  final DateTime end;

  LoadProgressStatistics(this.start, this.end);
}