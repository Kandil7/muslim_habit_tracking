import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';

void main() {
  group('ReviewSchedule', () {
    late ReviewSchedule reviewSchedule;
    late MemorizationItem newItem;
    late MemorizationItem inProgressItem;
    late MemorizationItem memorizedItem;
    late MemorizationItem overdueItem;

    setUp(() {
      newItem = MemorizationItem(
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

      inProgressItem = MemorizationItem(
        id: '2',
        surahNumber: 3,
        surahName: 'Ali \'Imran',
        startPage: 50,
        endPage: 76,
        dateAdded: DateTime(2023, 1, 5),
        status: MemorizationStatus.inProgress,
        consecutiveReviewDays: 3,
        lastReviewed: DateTime(2023, 1, 10),
        reviewHistory: [DateTime(2023, 1, 8), DateTime(2023, 1, 9), DateTime(2023, 1, 10)],
      );

      memorizedItem = MemorizationItem(
        id: '3',
        surahNumber: 4,
        surahName: 'An-Nisa',
        startPage: 77,
        endPage: 106,
        dateAdded: DateTime(2023, 1, 15),
        status: MemorizationStatus.memorized,
        consecutiveReviewDays: 5,
        lastReviewed: DateTime.now(),
        reviewHistory: [DateTime(2023, 1, 16), DateTime(2023, 1, 17), DateTime(2023, 1, 18), DateTime(2023, 1, 19), DateTime(2023, 1, 20)],
        dateMemorized: DateTime(2023, 1, 15),
      );

      overdueItem = MemorizationItem(
        id: '4',
        surahNumber: 5,
        surahName: 'Al-Ma\'idah',
        startPage: 107,
        endPage: 128,
        dateAdded: DateTime(2023, 1, 20),
        status: MemorizationStatus.memorized,
        consecutiveReviewDays: 5,
        lastReviewed: DateTime.now().subtract(const Duration(days: 2)),
        reviewHistory: [DateTime(2023, 1, 21), DateTime(2023, 1, 22), DateTime(2023, 1, 23)],
        dateMemorized: DateTime(2023, 1, 20),
        overdueCount: 1,
      );

      reviewSchedule = ReviewSchedule(
        reviewPeriodDays: 5,
        dailyItems: [newItem, inProgressItem, memorizedItem, overdueItem],
      );
    });

    test('should calculate daily item count correctly', () {
      expect(reviewSchedule.dailyItemCount, 4);
    });

    test('should calculate in-progress item count correctly', () {
      expect(reviewSchedule.inProgressItemCount, 1);
    });

    test('should calculate memorized item count correctly', () {
      expect(reviewSchedule.memorizedItemCount, 2);
    });

    test('should get overdue items correctly', () {
      expect(reviewSchedule.overdueItems.length, 1);
      expect(reviewSchedule.overdueItems.first.id, '4');
    });

    test('should get overdue item count correctly', () {
      expect(reviewSchedule.overdueItemCount, 1);
    });

    test('should get due today items correctly', () {
      expect(reviewSchedule.dueTodayItems.length, 1);
      expect(reviewSchedule.dueTodayItems.first.id, '3');
    });

    test('should get in-progress items correctly', () {
      expect(reviewSchedule.inProgressItems.length, 1);
      expect(reviewSchedule.inProgressItems.first.id, '2');
    });

    test('should get new items correctly', () {
      expect(reviewSchedule.newItems.length, 1);
      expect(reviewSchedule.newItems.first.id, '1');
    });

    test('should prioritize items correctly', () {
      final prioritizedItems = reviewSchedule.prioritizedItems;
      expect(prioritizedItems.length, 4);
      // In-progress item should have highest priority
      expect(prioritizedItems.first.id, '2');
      // Overdue item should have next highest priority
      expect(prioritizedItems[1].id, '4');
    });

    test('should calculate immediate review count correctly', () {
      expect(reviewSchedule.immediateReviewCount, 4);
    });

    test('should get immediate review items correctly', () {
      final immediateItems = reviewSchedule.immediateReviewItems;
      expect(immediateItems.length, 4);
      // In-progress item should have highest priority
      expect(immediateItems.first.id, '2');
    });

    test('should calculate completion percentage correctly', () {
      // No items have been reviewed today, so completion should be 0%
      expect(reviewSchedule.completionPercentage, 0.0);
    });
  });
}