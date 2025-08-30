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