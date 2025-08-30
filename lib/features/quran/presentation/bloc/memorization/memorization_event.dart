part of 'memorization_bloc.dart';

/// Base event class for memorization BLoC
abstract class MemorizationEvent extends Equatable {
  const MemorizationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all memorization items
class LoadMemorizationItems extends MemorizationEvent {}

/// Event to load the daily review schedule
class LoadDailyReviewSchedule extends MemorizationEvent {}

/// Event to load memorization preferences
class LoadMemorizationPreferences extends MemorizationEvent {}

/// Event to load memorization statistics
class LoadMemorizationStatistics extends MemorizationEvent {}

/// Event to create a new memorization item
class CreateMemorizationItemEvent extends MemorizationEvent {
  final MemorizationItem item;

  const CreateMemorizationItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to update an existing memorization item
class UpdateMemorizationItemEvent extends MemorizationEvent {
  final MemorizationItem item;

  const UpdateMemorizationItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to delete a memorization item
class DeleteMemorizationItemEvent extends MemorizationEvent {
  final String itemId;

  const DeleteMemorizationItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Event to mark an item as reviewed
class MarkItemAsReviewedEvent extends MemorizationEvent {
  final String itemId;

  const MarkItemAsReviewedEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Event to update memorization preferences
class UpdatePreferences extends MemorizationEvent {
  final MemorizationPreferences preferences;

  const UpdatePreferences(this.preferences);

  @override
  List<Object?> get props => [preferences];
}