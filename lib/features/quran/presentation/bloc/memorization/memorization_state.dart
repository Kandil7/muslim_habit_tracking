part of 'memorization_bloc.dart';

/// Base state class for memorization BLoC
abstract class MemorizationState extends Equatable {
  const MemorizationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MemorizationInitial extends MemorizationState {}

/// Loading state
class MemorizationLoading extends MemorizationState {}

/// Loaded state with memorization items
class MemorizationItemsLoaded extends MemorizationState {
  final List<MemorizationItem> items;

  const MemorizationItemsLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Loaded state with daily review schedule
class DailyReviewScheduleLoaded extends MemorizationState {
  final ReviewSchedule schedule;

  const DailyReviewScheduleLoaded(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

/// Loaded state with memorization preferences
class MemorizationPreferencesLoaded extends MemorizationState {
  final MemorizationPreferences preferences;

  const MemorizationPreferencesLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Loaded state with memorization statistics
class MemorizationStatisticsLoaded extends MemorizationState {
  final MemorizationStatistics statistics;

  const MemorizationStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

/// Success state after creating/updating/deleting an item
class MemorizationOperationSuccess extends MemorizationState {
  final MemorizationItem? item;

  const MemorizationOperationSuccess([this.item]);

  @override
  List<Object?> get props => [item];
}

/// Error state
class MemorizationError extends MemorizationState {
  final String message;

  const MemorizationError(this.message);

  @override
  List<Object?> get props => [message];
}