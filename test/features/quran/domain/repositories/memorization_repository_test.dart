import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';
import 'package:muslim_habbit/features/quran/domain/repositories/memorization_repository.dart';

// Generate mocks
@GenerateMocks([MemorizationRepository])
import 'memorization_repository_test.mocks.dart';

void main() {
  group('MemorizationRepository', () {
    late MockMemorizationRepository mockRepository;

    setUp(() {
      mockRepository = MockMemorizationRepository();
    });

    test('should get memorization items', () async {
      // Arrange
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

      when(mockRepository.getMemorizationItems())
          .thenAnswer((_) async => Right(items));

      // Act
      final result = await mockRepository.getMemorizationItems();

      // Assert
      expect(result, Right(items));
      verify(mockRepository.getMemorizationItems()).called(1);
    });

    test('should get daily review schedule', () async {
      // Arrange
      final schedule = ReviewSchedule(
        reviewPeriodDays: 5,
        dailyItems: [],
      );

      when(mockRepository.getDailyReviewSchedule())
          .thenAnswer((_) async => Right(schedule));

      // Act
      final result = await mockRepository.getDailyReviewSchedule();

      // Assert
      expect(result, Right(schedule));
      verify(mockRepository.getDailyReviewSchedule()).called(1);
    });

    test('should get memorization preferences', () async {
      // Arrange
      final preferences = MemorizationPreferences(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
      );

      when(mockRepository.getPreferences())
          .thenAnswer((_) async => Right(preferences));

      // Act
      final result = await mockRepository.getPreferences();

      // Assert
      expect(result, Right(preferences));
      verify(mockRepository.getPreferences()).called(1);
    });
  });
}