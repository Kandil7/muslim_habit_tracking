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
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/presentation/bloc/memorization/memorization_bloc.dart';
import 'package:muslim_habbit/core/error/failures.dart';

import 'memorization_bloc_test.mocks.dart';

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
    );
  });

  tearDown(() {
    memorizationBloc.close();
  });

  test('initial state should be MemorizationInitial', () {
    expect(memorizationBloc.state, equals(MemorizationInitial()));
  });

  group('LoadMemorizationItems', () {
    final testItems = [
      MemorizationItem(
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
      'should emit [Loading, ItemsLoaded] when GetMemorizationItems succeeds',
      build: () {
        when(mockGetMemorizationItems())
            .thenAnswer((_) async => Right(testItems));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadMemorizationItems()),
      expect: () => [
        MemorizationLoading(),
        MemorizationItemsLoaded(testItems),
      ],
      verify: (_) {
        verify(mockGetMemorizationItems()).called(1);
      },
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, Error] when GetMemorizationItems fails',
      build: () {
        when(mockGetMemorizationItems())
            .thenAnswer((_) async => const Left(CacheFailure(message: 'Failed')));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadMemorizationItems()),
      expect: () => [
        MemorizationLoading(),
        const MemorizationError('CacheFailure(message: Failed)'),
      ],
      verify: (_) {
        verify(mockGetMemorizationItems()).called(1);
      },
    );
  });

  group('LoadDailyReviewSchedule', () {
    final testSchedule = ReviewSchedule(
      reviewPeriodDays: 5,
      dailyItems: [],
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, ScheduleLoaded] when GetDailyReviewSchedule succeeds',
      build: () {
        when(mockGetDailyReviewSchedule())
            .thenAnswer((_) async => Right(testSchedule));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(LoadDailyReviewSchedule()),
      expect: () => [
        MemorizationLoading(),
        DailyReviewScheduleLoaded(testSchedule),
      ],
      verify: (_) {
        verify(mockGetDailyReviewSchedule()).called(1);
      },
    );
  });

  group('MarkItemAsReviewed', () {
    final testItem = MemorizationItem(
      id: '1',
      surahNumber: 2,
      surahName: 'Al-Baqarah',
      startPage: 2,
      endPage: 49,
      dateAdded: DateTime(2023, 1, 1),
      status: MemorizationStatus.inProgress,
      consecutiveReviewDays: 1,
      lastReviewed: DateTime(2023, 1, 2),
      reviewHistory: [DateTime(2023, 1, 2)],
    );

    blocTest<MemorizationBloc, MemorizationState>(
      'should emit [Loading, OperationSuccess] when MarkItemAsReviewed succeeds',
      build: () {
        when(mockMarkItemAsReviewed(any))
            .thenAnswer((_) async => Right(testItem));
        return memorizationBloc;
      },
      act: (bloc) => bloc.add(MarkItemAsReviewedEvent('1')),
      expect: () => [
        MemorizationLoading(),
        MemorizationOperationSuccess(testItem),
      ],
      verify: (_) {
        verify(mockMarkItemAsReviewed('1')).called(1);
      },
    );
  });
}