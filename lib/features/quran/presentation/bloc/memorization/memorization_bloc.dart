import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/memorization_item.dart';
import '../../../domain/entities/memorization_preferences.dart';
import '../../../domain/entities/review_schedule.dart';
import '../../../domain/entities/streak_statistics.dart' as streak_entity;
import '../../../domain/entities/progress_statistics.dart' as progress_entity;
import '../../../domain/repositories/memorization_repository.dart' as domain;
import '../../../domain/usecases/create_memorization_item.dart';
import '../../../domain/usecases/delete_memorization_item.dart';
import '../../../domain/usecases/get_daily_review_schedule.dart';
import '../../../domain/usecases/get_memorization_items.dart';
import '../../../domain/usecases/get_memorization_preferences.dart';
import '../../../domain/usecases/get_memorization_statistics.dart';
import '../../../domain/usecases/get_detailed_statistics.dart';
import '../../../domain/usecases/mark_item_as_reviewed.dart';
import '../../../domain/usecases/update_memorization_item.dart';
import '../../../domain/usecases/update_memorization_preferences.dart';
import '../../../domain/usecases/get_items_by_status.dart';
import '../../../domain/usecases/archive_item.dart';
import '../../../domain/usecases/unarchive_item.dart';
import '../../../domain/usecases/get_overdue_items.dart';
import '../../../domain/usecases/reset_item_progress.dart';
import '../../../domain/usecases/get_items_needing_review.dart';
import '../../../domain/usecases/get_item_review_history.dart';
import '../../../domain/usecases/get_items_by_surah.dart';
import '../../../domain/usecases/get_items_by_date_range.dart';
import '../../../domain/usecases/get_streak_statistics.dart';
import '../../../domain/usecases/get_progress_statistics.dart';

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
  final GetDetailedStatistics getDetailedStatistics;
  final GetItemsByStatus getItemsByStatus;
  final ArchiveItem archiveItem;
  final UnarchiveItem unarchiveItem;
  final GetOverdueItems getOverdueItems;
  final ResetItemProgress resetItemProgress;
  final GetItemsNeedingReview getItemsNeedingReview;
  final GetItemReviewHistory getItemReviewHistory;
  final GetItemsBySurah getItemsBySurah;
  final GetItemsByDateRange getItemsByDateRange;
  final GetStreakStatistics getStreakStatistics;
  final GetProgressStatistics getProgressStatistics;

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
    required this.getDetailedStatistics,
    required this.getItemsByStatus,
    required this.archiveItem,
    required this.unarchiveItem,
    required this.getOverdueItems,
    required this.resetItemProgress,
    required this.getItemsNeedingReview,
    required this.getItemReviewHistory,
    required this.getItemsBySurah,
    required this.getItemsByDateRange,
    required this.getStreakStatistics,
    required this.getProgressStatistics,
  }) : super(MemorizationInitial()) {
    on<LoadMemorizationItems>(_onLoadMemorizationItems);
    on<LoadDailyReviewSchedule>(_onLoadDailyReviewSchedule);
    on<LoadMemorizationPreferences>(_onLoadMemorizationPreferences);
    on<LoadMemorizationStatistics>(_onLoadMemorizationStatistics);
    on<LoadDetailedStatistics>(_onLoadDetailedStatistics);
    on<CreateMemorizationItemEvent>(_onCreateMemorizationItem);
    on<UpdateMemorizationItemEvent>(_onUpdateMemorizationItem);
    on<DeleteMemorizationItemEvent>(_onDeleteMemorizationItem);
    on<MarkItemAsReviewedEvent>(_onMarkItemAsReviewed);
    on<UpdatePreferences>(_onUpdatePreferences);
    on<LoadItemsByStatus>(_onLoadItemsByStatus);
    on<ArchiveItemEvent>(_onArchiveItem);
    on<UnarchiveItemEvent>(_onUnarchiveItem);
    on<LoadOverdueItems>(_onLoadOverdueItems);
    on<ResetItemProgressEvent>(_onResetItemProgress);
    on<LoadItemsNeedingReview>(_onLoadItemsNeedingReview);
    on<LoadItemReviewHistory>(_onLoadItemReviewHistory);
    on<LoadItemsBySurah>(_onLoadItemsBySurah);
    on<LoadItemsByDateRange>(_onLoadItemsByDateRange);
    on<LoadStreakStatistics>(_onLoadStreakStatistics);
    on<LoadProgressStatistics>(_onLoadProgressStatistics);
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

  /// Handle loading detailed statistics
  Future<void> _onLoadDetailedStatistics(
    LoadDetailedStatistics event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrDetailedStatistics = await getDetailedStatistics();
    failureOrDetailedStatistics.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (detailedStatistics) => emit(DetailedStatisticsLoaded(detailedStatistics)),
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
      (_) => emit(MemorizationOperationSuccess()),
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
      (item) {
        // After marking an item as reviewed, reload the schedule and statistics
        add(LoadDailyReviewSchedule());
        add(LoadMemorizationStatistics());
        emit(MemorizationOperationSuccess(item));
      },
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
      (preferences) {
        // After updating preferences, reload the schedule
        add(LoadDailyReviewSchedule());
        emit(MemorizationPreferencesLoaded(preferences));
      },
    );
  }

  /// Handle loading items by status
  Future<void> _onLoadItemsByStatus(
    LoadItemsByStatus event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItems = await getItemsByStatus(event.status);
    failureOrItems.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (items) => emit(ItemsByStatusLoaded(event.status, items)),
    );
  }

  /// Handle archiving an item
  Future<void> _onArchiveItem(
    ArchiveItemEvent event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItem = await archiveItem(event.itemId);
    failureOrItem.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (item) => emit(MemorizationOperationSuccess(item)),
    );
  }

  /// Handle unarchiving an item
  Future<void> _onUnarchiveItem(
    UnarchiveItemEvent event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItem = await unarchiveItem(event.itemId);
    failureOrItem.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (item) => emit(MemorizationOperationSuccess(item)),
    );
  }

  /// Handle loading overdue items
  Future<void> _onLoadOverdueItems(
    LoadOverdueItems event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItems = await getOverdueItems();
    failureOrItems.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (items) => emit(OverdueItemsLoaded(items)),
    );
  }

  /// Handle resetting item progress
  Future<void> _onResetItemProgress(
    ResetItemProgressEvent event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItem = await resetItemProgress(event.itemId);
    failureOrItem.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (item) => emit(MemorizationOperationSuccess(item)),
    );
  }

  /// Handle loading items needing review
  Future<void> _onLoadItemsNeedingReview(
    LoadItemsNeedingReview event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItems = await getItemsNeedingReview();
    failureOrItems.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (items) => emit(ItemsNeedingReviewLoaded(items)),
    );
  }

  /// Handle loading item review history
  Future<void> _onLoadItemReviewHistory(
    LoadItemReviewHistory event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrReviewHistory = await getItemReviewHistory(event.itemId);
    failureOrReviewHistory.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (reviewHistory) => emit(ItemReviewHistoryLoaded(event.itemId, reviewHistory)),
    );
  }

  /// Handle loading items by surah
  Future<void> _onLoadItemsBySurah(
    LoadItemsBySurah event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItems = await getItemsBySurah(event.surahNumber);
    failureOrItems.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (items) => emit(ItemsBySurahLoaded(event.surahNumber, items)),
    );
  }

  /// Handle loading items by date range
  Future<void> _onLoadItemsByDateRange(
    LoadItemsByDateRange event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrItems = await getItemsByDateRange(event.start, event.end);
    failureOrItems.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (items) => emit(ItemsByDateRangeLoaded(event.start, event.end, items)),
    );
  }

  /// Handle loading streak statistics
  Future<void> _onLoadStreakStatistics(
    LoadStreakStatistics event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrStreakStatistics = await getStreakStatistics();
    failureOrStreakStatistics.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (streakStatistics) => emit(StreakStatisticsLoaded(streak_entity.StreakStatistics(
        currentStreak: streakStatistics.currentStreak,
        longestStreak: streakStatistics.longestStreak,
        streakHistory: streakStatistics.streakHistory,
      ))),
    );
  }

  /// Handle loading progress statistics
  Future<void> _onLoadProgressStatistics(
    LoadProgressStatistics event,
    Emitter<MemorizationState> emit,
  ) async {
    emit(MemorizationLoading());
    final failureOrProgressStatistics = await getProgressStatistics(event.start, event.end);
    failureOrProgressStatistics.fold(
      (failure) => emit(MemorizationError(failure.toString())),
      (progressStatistics) => emit(ProgressStatisticsLoaded(progress_entity.ProgressStatistics(
        startDate: progressStatistics.startDate,
        endDate: progressStatistics.endDate,
        itemsStarted: progressStatistics.itemsStarted,
        itemsCompleted: progressStatistics.itemsCompleted,
        reviewsCount: progressStatistics.reviewsCount,
        averageProgressPerDay: progressStatistics.averageProgressPerDay,
      ))),
    );
  }
}