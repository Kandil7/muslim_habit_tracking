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
class CreateMemorizationItem extends MemorizationEvent {
  final MemorizationItem item;

  const CreateMemorizationItem(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to update an existing memorization item
class UpdateMemorizationItem extends MemorizationEvent {
  final MemorizationItem item;

  const UpdateMemorizationItem(this.item);

  @override
  List<Object?> get props => [item];
}

/// Event to delete a memorization item
class DeleteMemorizationItem extends MemorizationEvent {
  final String itemId;

  const DeleteMemorizationItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

/// Event to mark an item as reviewed
class MarkItemAsReviewed extends MemorizationEvent {
  final String itemId;

  const MarkItemAsReviewed(this.itemId);

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