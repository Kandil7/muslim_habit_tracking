import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:muslim_habbit/core/network/network_info.dart';
import 'package:muslim_habbit/features/quran/data/repositories/memorization_repository_impl.dart';
import 'package:muslim_habbit/features/quran/data/datasources/memorization_local_data_source.dart';
import 'package:muslim_habbit/features/quran/data/models/memorization_item_model.dart';
import 'package:muslim_habbit/features/quran/data/models/memorization_preferences_model.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';
import 'package:muslim_habbit/core/error/exceptions.dart';
import 'package:muslim_habbit/core/error/failures.dart';

import 'memorization_repository_impl_test.mocks.dart';

@GenerateMocks([MemorizationLocalDataSource, NetworkInfo])
void main() {
  late MemorizationRepositoryImpl repository;
  late MockMemorizationLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockMemorizationLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MemorizationRepositoryImpl(
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getMemorizationItems', () {
    final testItems = [
      MemorizationItemModel(
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

    test('should return items when call to local data source is successful', () async {
      // Arrange
      when(mockLocalDataSource.getMemorizationItems())
          .thenAnswer((_) async => testItems);

      // Act
      final result = await repository.getMemorizationItems();

      // Assert
      expect(result, Right(testItems));
      verify(mockLocalDataSource.getMemorizationItems());
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when call to local data source fails', () async {
      // Arrange
      when(mockLocalDataSource.getMemorizationItems())
          .thenThrow(CacheException(message: 'Failed to get items'));

      // Act
      final result = await repository.getMemorizationItems();

      // Assert
      expect(result, const Left(CacheFailure(message: 'Failed to get items')));
      verify(mockLocalDataSource.getMemorizationItems());
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('getDailyReviewSchedule', () {
    final testPreferences = MemorizationPreferencesModel(
      reviewPeriod: 5,
      memorizationDirection: MemorizationDirection.fromBaqarah,
    );

    final testItems = [
      MemorizationItemModel(
        id: '1',
        surahNumber: 2,
        surahName: 'Al-Baqarah',
        startPage: 2,
        endPage: 49,
        dateAdded: DateTime(2023, 1, 1),
        status: MemorizationStatus.inProgress,
        consecutiveReviewDays: 3,
        lastReviewed: DateTime(2023, 1, 10),
        reviewHistory: [DateTime(2023, 1, 8), DateTime(2023, 1, 9), DateTime(2023, 1, 10)],
      )
    ];

    test('should return review schedule when call to local data source is successful', () async {
      // Arrange
      when(mockLocalDataSource.getMemorizationItems())
          .thenAnswer((_) async => testItems);
      when(mockLocalDataSource.getPreferences())
          .thenAnswer((_) async => testPreferences);

      // Act
      final result = await repository.getDailyReviewSchedule();

      // Assert
      verify(mockLocalDataSource.getMemorizationItems());
      verify(mockLocalDataSource.getPreferences());
      verifyNoMoreInteractions(mockLocalDataSource);
      
      // Check that we get a Right result
      expect(result, isA<Right<Failure, ReviewSchedule>>());
    });

    test('should return CacheFailure when getting items fails', () async {
      // Arrange
      when(mockLocalDataSource.getMemorizationItems())
          .thenThrow(CacheException(message: 'Failed to get items'));

      // Act
      final result = await repository.getDailyReviewSchedule();

      // Assert
      expect(result, const Left(CacheFailure(message: 'Failed to get items')));
      verify(mockLocalDataSource.getMemorizationItems());
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when getting preferences fails', () async {
      // Arrange
      when(mockLocalDataSource.getMemorizationItems())
          .thenAnswer((_) async => []);
      when(mockLocalDataSource.getPreferences())
          .thenThrow(CacheException(message: 'Failed to get preferences'));

      // Act
      final result = await repository.getDailyReviewSchedule();

      // Assert
      expect(result, const Left(CacheFailure(message: 'Failed to get preferences')));
      verify(mockLocalDataSource.getMemorizationItems());
      verify(mockLocalDataSource.getPreferences());
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });

  group('markItemAsReviewed', () {
    final testItem = MemorizationItemModel(
      id: '1',
      surahNumber: 2,
      surahName: 'Al-Baqarah',
      startPage: 2,
      endPage: 49,
      dateAdded: DateTime(2023, 1, 1),
      status: MemorizationStatus.inProgress,
      consecutiveReviewDays: 3,
      lastReviewed: DateTime(2023, 1, 10),
      reviewHistory: [DateTime(2023, 1, 8), DateTime(2023, 1, 9), DateTime(2023, 1, 10)],
    );

    test('should return updated item when call to local data source is successful', () async {
      // Arrange
      when(mockLocalDataSource.markItemAsReviewed(any))
          .thenAnswer((_) async => testItem);

      // Act
      final result = await repository.markItemAsReviewed('1');

      // Assert
      expect(result, Right(testItem));
      verify(mockLocalDataSource.markItemAsReviewed('1'));
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return CacheFailure when call to local data source fails', () async {
      // Arrange
      when(mockLocalDataSource.markItemAsReviewed(any))
          .thenThrow(CacheException(message: 'Failed to mark item as reviewed'));

      // Act
      final result = await repository.markItemAsReviewed('1');

      // Assert
      expect(result, const Left(CacheFailure(message: 'Failed to mark item as reviewed')));
      verify(mockLocalDataSource.markItemAsReviewed('1'));
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });
}