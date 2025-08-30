import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';

// Mock use cases
class MockGetMemorizationItems extends Mock implements GetMemorizationItems {}

class MockCreateMemorizationItem extends Mock implements CreateMemorizationItem {}

class MockUpdateMemorizationItem extends Mock implements UpdateMemorizationItem {}

class MockDeleteMemorizationItem extends Mock implements DeleteMemorizationItem {}

class MockGetDailyReviewSchedule extends Mock implements GetDailyReviewSchedule {}

class MockMarkItemAsReviewed extends Mock implements MarkItemAsReviewed {}

class MockGetMemorizationPreferences extends Mock implements GetMemorizationPreferences {}

class MockUpdateMemorizationPreferences extends Mock
    implements UpdateMemorizationPreferences {}

class MockGetMemorizationStatistics extends Mock implements GetMemorizationStatistics {}

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
          const MemorizationItem(
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

        when(mockGetMemorizationItems())
            .thenAnswer((_) async => Right(items));

        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadMemorizationItems()),
      expect: () => [
        MemorizationLoading(),
        const MemorizationItemsLoaded([
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

        when(mockGetDailyReviewSchedule())
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
        const preferences = MemorizationPreferences(
          reviewPeriod: 5,
          memorizationDirection: MemorizationDirection.fromBaqarah,
        );

        when(mockGetMemorizationPreferences())
            .thenAnswer((_) async => Right(preferences));

        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadMemorizationPreferences()),
      expect: () => [
        MemorizationLoading(),
        const MemorizationPreferencesLoaded(
          MemorizationPreferences(
            reviewPeriod: 5,
            memorizationDirection: MemorizationDirection.fromBaqarah,
          ),
        ),
      ],
    );
  });
}