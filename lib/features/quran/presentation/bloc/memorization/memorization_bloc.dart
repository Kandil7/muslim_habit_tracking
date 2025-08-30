import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/memorization_item.dart';
import '../../../domain/entities/memorization_preferences.dart';
import '../../../domain/entities/review_schedule.dart';
import '../../../domain/repositories/memorization_repository.dart';
import '../../../domain/usecases/create_memorization_item.dart';
import '../../../domain/usecases/delete_memorization_item.dart';
import '../../../domain/usecases/get_daily_review_schedule.dart';
import '../../../domain/usecases/get_memorization_items.dart';
import '../../../domain/usecases/get_memorization_preferences.dart';
import '../../../domain/usecases/get_memorization_statistics.dart';
import '../../../domain/usecases/mark_item_as_reviewed.dart';
import '../../../domain/usecases/update_memorization_item.dart';
import '../../../domain/usecases/update_memorization_preferences.dart';

part 'memorization_event.dart';
part 'memorization_state.dart';

/// BLoC for managing memorization state
class MemorizationBloc extends Bloc<MemorizationEvent, MemorizationState> {
  final GetMemorizationItems getMemorizationItems;
  final CreateMemorizationItem createMemorizationItem;
  final UpdateMemorizationItem updateMemorizationItem;
  final DeleteMemorizationItem deleteMemorizationItem;
  final GetDailyReviewSchedule getDailyReviewSchedule;
  final MarkItemAsReviewed markItemAsReviewed;
  final GetMemorizationPreferences getMemorizationPreferences;
  final UpdateMemorizationPreferences updateMemorizationPreferences;
  final GetMemorizationStatistics getMemorizationStatistics;

  MemorizationBloc({
    required this.getMemorizationItems,
    required this.createMemorizationItem,
    required this.updateMemorizationItem,
    required this.deleteMemorizationItem,
    required this.getDailyReviewSchedule,
    required this.markItemAsReviewed,
    required this.getMemorizationPreferences,
    required this.updateMemorizationPreferences,
    required this.getMemorizationStatistics,
  }) : super(MemorizationInitial()) {
    on<LoadMemorizationItems>(_onLoadMemorizationItems);
    on<LoadDailyReviewSchedule>(_onLoadDailyReviewSchedule);
    on<LoadMemorizationPreferences>(_onLoadMemorizationPreferences);
    on<LoadMemorizationStatistics>(_onLoadMemorizationStatistics);
    on<CreateMemorizationItemEvent>(_onCreateMemorizationItem);
    on<UpdateMemorizationItemEvent>(_onUpdateMemorizationItem);
    on<DeleteMemorizationItemEvent>(_onDeleteMemorizationItem);
    on<MarkItemAsReviewedEvent>(_onMarkItemAsReviewed);
    on<UpdatePreferences>(_onUpdatePreferences);
  }

  /// Handle loading memorization items
  Future<void> _onLoadMemorizationItems(
    LoadMemorizationItems event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItems = await getMemorizationItems();
    failureOrItems.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (items) => emit(MemorizationItemsLoaded(items)),
    );
  }

  /// Handle loading daily review schedule
  Future<void> _onLoadDailyReviewSchedule(
    LoadDailyReviewSchedule event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrSchedule = await getDailyReviewSchedule();
    failureOrSchedule.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (schedule) => emit(DailyReviewScheduleLoaded(schedule)),
    );
  }

  /// Handle loading memorization preferences
  Future<void> _onLoadMemorizationPreferences(
    LoadMemorizationPreferences event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrPreferences = await getMemorizationPreferences();
    failureOrPreferences.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (preferences) => emit(MemorizationPreferencesLoaded(preferences)),
    );
  }

  /// Handle loading memorization statistics
  Future<void> _onLoadMemorizationStatistics(
    LoadMemorizationStatistics event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrStatistics = await getMemorizationStatistics();
    failureOrStatistics.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (statistics) => emit(MemorizationStatisticsLoaded(statistics)),
    );
  }

  /// Handle creating a memorization item
  Future<void> _onCreateMemorizationItem(
    CreateMemorizationItemEvent event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItem = await createMemorizationItem(event.item);
    failureOrItem.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (item) => emit(MemorizationOperationSuccess(item)),
    );
  }

  /// Handle updating a memorization item
  Future<void> _onUpdateMemorizationItem(
    UpdateMemorizationItemEvent event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItem = await updateMemorizationItem(event.item);
    failureOrItem.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (item) => emit(MemorizationOperationSuccess(item)),
    );
  }

  /// Handle deleting a memorization item
  Future<void> _onDeleteMemorizationItem(
    DeleteMemorizationItemEvent event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrVoid = await deleteMemorizationItem(event.itemId);
    failureOrVoid.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (_) => emit(const MemorizationOperationSuccess()),
    );
  }

  /// Handle marking an item as reviewed
  Future<void> _onMarkItemAsReviewed(
    MarkItemAsReviewedEvent event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItem = await markItemAsReviewed(event.itemId);
    failureOrItem.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (item) => emit(MemorizationOperationSuccess(item)),
    );
  }

  /// Handle updating preferences
  Future<void> _onUpdatePreferences(
    UpdatePreferences event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrPreferences = await updateMemorizationPreferences(event.preferences);
    failureOrPreferences.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (preferences) => emit(MemorizationPreferencesLoaded(preferences)),
    );
  }
}