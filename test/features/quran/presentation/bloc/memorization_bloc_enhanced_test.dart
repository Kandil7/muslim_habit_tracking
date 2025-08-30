import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/create_memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/delete_memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_daily_review_schedule.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_memorization_items.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_memorization_statistics.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_detailed_statistics.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/mark_item_as_reviewed.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/update_memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/update_memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_items_by_status.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/archive_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/unarchive_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_overdue_items.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/reset_item_progress.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_items_needing_review.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_item_review_history.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_items_by_surah.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_items_by_date_range.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_streak_statistics.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_progress_statistics.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/core/error/failures.dart';

import 'memorization_bloc_enhanced_test.mocks.dart';

@GenerateMocks([
  GetMemorizationItems,
  CreateMemorizationItem,
  UpdateMemorizationItem,
  DeleteMemorizationItem,
  GetDailyReviewSchedule,
  MarkItemAsReviewed,
  GetMemorizationPreferences,
  UpdateMemorizationPreferences,
  GetMemorizationStatistics,
  GetDetailedStatistics,
  GetItemsByStatus,
  ArchiveItem,
  UnarchiveItem,
  GetOverdueItems,
  ResetItemProgress,
  GetItemsNeedingReview,
  GetItemReviewHistory,
  GetItemsBySurah,
  GetItemsByDateRange,
  GetStreakStatistics,
  GetProgressStatistics,
])
void main() {
  late MockGetMemorizationItems mockGetMemorizationItems;
  late MockCreateMemorizationItem mockCreateMemorizationItem;
  late MockUpdateMemorizationItem mockUpdateMemorizationItem;
  late MockDeleteMemorizationItem mockDeleteMemorizationItem;
  late MockGetDailyReviewSchedule mockGetDailyReviewSchedule;
  late MockMarkItemAsReviewed mockMarkItemAsReviewed;
  late MockGetMemorizationPreferences mockGetMemorizationPreferences;
  late MockUpdateMemorizationPreferences mockUpdateMemorizationPreferences;
  late MockGetMemorizationStatistics mockGetMemorizationStatistics;
  late MockGetDetailedStatistics mockGetDetailedStatistics;
  late MockGetItemsByStatus mockGetItemsByStatus;
  late MockArchiveItem mockArchiveItem;
  late MockUnarchiveItem mockUnarchiveItem;
  late MockGetOverdueItems mockGetOverdueItems;
  late MockResetItemProgress mockResetItemProgress;
  late MockGetItemsNeedingReview mockGetItemsNeedingReview;
  late MockGetItemReviewHistory mockGetItemReviewHistory;
  late MockGetItemsBySurah mockGetItemsBySurah;
  late MockGetItemsByDateRange mockGetItemsByDateRange;
  late MockGetStreakStatistics mockGetStreakStatistics;
  late MockGetProgressStatistics mockGetProgressStatistics;

  late MemorizationBloc memorizationBloc;

  setUp(() {
    mockGetMemorizationItems = MockGetMemorizationItems();
    mockCreateMemorizationItem = MockCreateMemorizationItem();
    mockUpdateMemorizationItem = MockUpdateMemorizationItem();
    mockDeleteMemorizationItem = MockDeleteMemorizationItem();
    mockGetDailyReviewSchedule = MockGetDailyReviewSchedule();
    mockMarkItemAsReviewed = MockMarkItemAsReviewed();
    mockGetMemorizationPreferences = MockGetMemorizationPreferences();
    mockUpdateMemorizationPreferences = MockUpdateMemorizationPreferences();
    mockGetMemorizationStatistics = MockGetMemorizationStatistics();
    mockGetDetailedStatistics = MockGetDetailedStatistics();
    mockGetItemsByStatus = MockGetItemsByStatus();
    mockArchiveItem = MockArchiveItem();
    mockUnarchiveItem = MockUnarchiveItem();
    mockGetOverdueItems = MockGetOverdueItems();
    mockResetItemProgress = MockResetItemProgress();
    mockGetItemsNeedingReview = MockGetItemsNeedingReview();
    mockGetItemReviewHistory = MockGetItemReviewHistory();
    mockGetItemsBySurah = MockGetItemsBySurah();
    mockGetItemsByDateRange = MockGetItemsByDateRange();
    mockGetStreakStatistics = MockGetStreakStatistics();
    mockGetProgressStatistics = MockGetProgressStatistics();

    memorizationBloc = MemorizationBloc(
      getMemorizationItems: mockGetMemorizationItems,
      createMemorizationItem: mockCreateMemorizationItem,
      updateMemorizationItem: mockUpdateMemorizationItem,
      deleteMemorizationItem: mockDeleteMemorizationItem,
      getDailyReviewSchedule: mockGetDailyReviewSchedule,
      markItemAsReviewed: mockMarkItemAsReviewed,
      getMemorizationPreferences: mockGetMemorizationPreferences,
      updateMemorizationPreferences: mockUpdateMemorizationPreferences,
      getMemorizationStatistics: mockGetMemorizationStatistics,
      getDetailedStatistics: mockGetDetailedStatistics,
      getItemsByStatus: mockGetItemsByStatus,
      archiveItem: mockArchiveItem,
      unarchiveItem: mockUnarchiveItem,
      getOverdueItems: mockGetOverdueItems,
      resetItemProgress: mockResetItemProgress,
      getItemsNeedingReview: mockGetItemsNeedingReview,
      getItemReviewHistory: mockGetItemReviewHistory,
      getItemsBySurah: mockGetItemsBySurah,
      getItemsByDateRange: mockGetItemsByDateRange,
      getStreakStatistics: mockGetStreakStatistics,
      getProgressStatistics: mockGetProgressStatistics,
    );
  });

  tearDown(() {
    memorizationBloc.close();
  });

  test('initial state should be MemorizationInitial', () {
    expect(memorizationBloc.state, equals(MemorizationInitial()));
  });

  group('LoadItemsByStatus', () {
    final testItems = [
      const MemorizationItem(
        id: '1',
        surahNumber: 2,
        surahName: 'Al-Baqarah',
        startPage: 2,
        endPage: 49,
        dateAdded: DateTime(2023, 1, 1),
        status: MemorizationStatus.newStatus,
        consecutiveReviewDays: 0,
        lastReviewed: null,
        reviewHistory: [],
      )
    ];

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, ItemsByStatusLoaded] when GetItemsByStatus succeeds',
      build: () {
        when(mockGetItemsByStatus(any))
            .thenAnswer((_) async => const Right(testItems));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadItemsByStatus(MemorizationStatus.newStatus)),
      expect: () => [
        MemorizationLoading(),
        ItemsByStatusLoaded(MemorizationStatus.newStatus, testItems),
      ],
      verify: (_) {
        verify(mockGetItemsByStatus(MemorizationStatus.newStatus)).called(1);
      },
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, Error] when GetItemsByStatus fails',
      build: () {
        when(mockGetItemsByStatus(any))
            .thenAnswer((_) async => const Left(CacheFailure(message: 'Failed')));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadItemsByStatus(MemorizationStatus.newStatus)),
      expect: () => [
        MemorizationLoading(),
        const MemorizationError('CacheFailure(message: Failed)'),
      ],
      verify: (_) {
        verify(mockGetItemsByStatus(MemorizationStatus.newStatus)).called(1);
      },
    );
  });

  group('ArchiveItemEvent', () {
    final testItem = const MemorizationItem(
      id: '1',
      surahNumber: 2,
      surahName: 'Al-Baqarah',
      startPage: 2,
      endPage: 49,
      dateAdded: DateTime(2023, 1, 1),
      status: MemorizationStatus.archived,
      consecutiveReviewDays: 0,
      lastReviewed: null,
      reviewHistory: [],
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, OperationSuccess] when ArchiveItem succeeds',
      build: () {
        when(mockArchiveItem(any))
            .thenAnswer((_) async => const Right(testItem));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(ArchiveItemEvent('1')),
      expect: () => [
        MemorizationLoading(),
        const MemorizationOperationSuccess(testItem),
      ],
      verify: (_) {
        verify(mockArchiveItem('1')).called(1);
      },
    );
  });

  group('UnarchiveItemEvent', () {
    final testItem = const MemorizationItem(
      id: '1',
      surahNumber: 2,
      surahName: 'Al-Baqarah',
      startPage: 2,
      endPage: 49,
      dateAdded: DateTime(2023, 1, 1),
      status: MemorizationStatus.newStatus,
      consecutiveReviewDays: 0,
      lastReviewed: null,
      reviewHistory: [],
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, OperationSuccess] when UnarchiveItem succeeds',
      build: () {
        when(mockUnarchiveItem(any))
            .thenAnswer((_) async => const Right(testItem));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(UnarchiveItemEvent('1')),
      expect: () => [
        MemorizationLoading(),
        const MemorizationOperationSuccess(testItem),
      ],
      verify: (_) {
        verify(mockUnarchiveItem('1')).called(1);
      },
    );
  });

  group('LoadOverdueItems', () {
    final testItems = [
      const MemorizationItem(
        id: '1',
        surahNumber: 2,
        surahName: 'Al-Baqarah',
        startPage: 2,
        endPage: 49,
        dateAdded: DateTime(2023, 1, 1),
        status: MemorizationStatus.memorized,
        consecutiveReviewDays: 5,
        lastReviewed: DateTime(2023, 1, 1),
        reviewHistory: [DateTime(2023, 1, 1)],
        overdueCount: 1,
      )
    ];

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, OverdueItemsLoaded] when GetOverdueItems succeeds',
      build: () {
        when(mockGetOverdueItems())
            .thenAnswer((_) async => const Right(testItems));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadOverdueItems()),
      expect: () => [
        MemorizationLoading(),
        OverdueItemsLoaded(testItems),
      ],
      verify: (_) {
        verify(mockGetOverdueItems()).called(1);
      },
    );
  });
}