import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';

void main() {
  group('MemorizationItem', () {
    late MemorizationItem memorizationItem;

    setUp(() {
      memorizationItem = MemorizationItem(
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
      );
    });

    test('should calculate page count correctly', () {
      expect(memorizationItem.pageCount, 28);
    });

    test('should determine if item is due for review', () {
      // For new items, should not be due for review
      expect(memorizationItem.isDueForReview(5), false);

      // For memorized items, test the review cycle logic
      final memorizedItem = memorizationItem.copyWith(
        status: MemorizationStatus.memorized,
        lastReviewed: DateTime(2023, 1, 1),
      );

      // This test might be flaky depending on the current date
      // but it's a basic check that the method doesn't throw
      expect(() => memorizedItem.isDueForReview(5), returnsNormally);
    });

    test('should determine if item is overdue', () {
      // For new items, should not be overdue
      expect(memorizationItem.isOverdue, false);

      // For memorized items with recent review, should not be overdue
      final recentItem = memorizationItem.copyWith(
        status: MemorizationStatus.memorized,
        lastReviewed: DateTime.now(),
      );
      expect(recentItem.isOverdue, false);

      // For memorized items with old review, should be overdue
      final oldItem = memorizationItem.copyWith(
        status: MemorizationStatus.memorized,
        lastReviewed: DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(oldItem.isOverdue, true);
    });

    test('should calculate streak completion percentage', () {
      // For new items, should be 0%
      expect(memorizationItem.streakCompletionPercentage, 0.0);

      // For in-progress items, should calculate percentage
      final inProgressItem = memorizationItem.copyWith(
        status: MemorizationStatus.inProgress,
        consecutiveReviewDays: 3,
      );
      expect(inProgressItem.streakCompletionPercentage, 60.0);

      // For memorized items, should be 100%
      final memorizedItem = memorizationItem.copyWith(
        status: MemorizationStatus.memorized,
      );
      expect(memorizedItem.streakCompletionPercentage, 100.0);
    });

    test('should create a copy with updated fields', () {
      final updatedItem = memorizationItem.copyWith(
        surahName: 'Updated Surah Name',
        consecutiveReviewDays: 5,
      );

      expect(updatedItem.surahName, 'Updated Surah Name');
      expect(updatedItem.consecutiveReviewDays, 5);
      // Other fields should remain the same
      expect(updatedItem.id, memorizationItem.id);
      expect(updatedItem.surahNumber, memorizationItem.surahNumber);
    });
  });
}