import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/create_memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/delete_memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_daily_review_schedule.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_memorization_items.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_memorization_statistics.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/mark_item_as_reviewed.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/update_memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/update_memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/domain/usecases/get_detailed_statistics.dart';
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
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

// Generate mocks
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
import 'memorization_bloc_test.mocks.dart';

void main() {
  group('MemorizationBloc', () {
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
      );
    });

    tearDown(() {
      memorizationBloc.close();
    });

    test('initial state should be MemorizationInitial', () {
      expect(memorizationBloc.state, equals(MemorizationInitial()));
    });

    blocTest<MemorizationBloc, MemorizationState>(
      'emits [MemorizationLoading, MemorizationItemsLoaded] when LoadMemorizationItems is added',
      build: () {
        final items = [
          MemorizationItem(
            id: '1',
            surahNumber: 2,
            surahName: 'Al-Baqarah',
            startPage: 22,
            endPage: 49,
            dateAdded: DateTime(2023, 1, 1),
            status: MemorizationStatus.newStatus,
            consecutiveReviewDays: 0,
            lastReviewed: null,
            reviewHistory: [],
          )
        ];

        when(mockGetMemorizationItems.call())
            .thenAnswer((_) async => Right(items));

        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadMemorizationItems()),
      expect: () => [
        MemorizationLoading(),
        MemorizationItemsLoaded([
          MemorizationItem(
            id: '1',
            surahNumber: 2,
            surahName: 'Al-Baqarah',
            startPage: 22,
            endPage: 49,
            dateAdded: DateTime(2023, 1, 1),
            status: MemorizationStatus.newStatus,
            consecutiveReviewDays: 0,
            lastReviewed: null,
            reviewHistory: [],
          )
        ]),
      ],
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'emits [MemorizationLoading, DailyReviewScheduleLoaded] when LoadDailyReviewSchedule is added',
      build: () {
        final schedule = ReviewSchedule(
          reviewPeriodDays: 5,
          dailyItems: [],
        );

        when(mockGetDailyReviewSchedule.call())
            .thenAnswer((_) async => Right(schedule));

        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadDailyReviewSchedule()),
      expect: () => [
        MemorizationLoading(),
        DailyReviewScheduleLoaded(
          ReviewSchedule(
            reviewPeriodDays: 5,
            dailyItems: [],
          ),
        ),
      ],
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'emits [MemorizationLoading, MemorizationPreferencesLoaded] when LoadMemorizationPreferences is added',
      build: () {
        final preferences = MemorizationPreferences(
          reviewPeriod: 5,
          memorizationDirection: MemorizationDirection.fromBaqarah,
        );

        when(mockGetMemorizationPreferences.call())
            .thenAnswer((_) async => Right(preferences));

        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadMemorizationPreferences()),
      expect: () => [
        MemorizationLoading(),
        MemorizationPreferencesLoaded(
          MemorizationPreferences(
            reviewPeriod: 5,
            memorizationDirection: MemorizationDirection.fromBaqarah,
          ),
        ),
      ],
    );
  });
}