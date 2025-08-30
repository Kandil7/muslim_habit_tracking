import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';

void main() {
  group('MemorizationItem', () {
    late MemorizationItem newItem;
    late MemorizationItem inProgressItem;
    late MemorizationItem memorizedItem;

    setUp(() {
      newItem = const MemorizationItem(
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

      inProgressItem = const MemorizationItem(
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

      memorizedItem = const MemorizationItem(
        id: '3',
        surahNumber: 4,
        surahName: 'An-Nisa',
        startPage: 77,
        endPage: 106,
        dateAdded: DateTime(2023, 1, 15),
        status: MemorizationStatus.memorized,
        consecutiveReviewDays: 5,
        lastReviewed: DateTime(2023, 1, 20),
        reviewHistory: [DateTime(2023, 1, 16), DateTime(2023, 1, 17), DateTime(2023, 1, 18), DateTime(2023, 1, 19), DateTime(2023, 1, 20)],
        dateMemorized: DateTime(2023, 1, 15),
      );
    });

    test('should calculate page count correctly', () {
      expect(newItem.pageCount, 48);
      expect(inProgressItem.pageCount, 27);
      expect(memorizedItem.pageCount, 30);
    });

    test('should determine if item is due for review correctly', () {
      // New items should not be due for review
      expect(newItem.isDueForReview(5), false);
      
      // In-progress items should not be due for review
      expect(inProgressItem.isDueForReview(5), false);
      
      // Memorized items should be due based on review period
      expect(memorizedItem.isDueForReview(5), true);
    });

    test('should determine if item is overdue correctly', () {
      // New items should not be overdue
      expect(newItem.isOverdue, false);
      
      // In-progress items should not be overdue
      expect(inProgressItem.isOverdue, false);
      
      // Create an overdue memorized item
      final overdueItem = memorizedItem.copyWith(
        lastReviewed: DateTime.now().subtract(const Duration(days: 2)),
      );
      expect(overdueItem.isOverdue, true);
    });

    test('should calculate streak completion percentage correctly', () {
      expect(newItem.streakCompletionPercentage, 0.0);
      expect(inProgressItem.streakCompletionPercentage, 60.0);
      expect(memorizedItem.streakCompletionPercentage, 100.0);
    });

    test('should calculate days until next review correctly', () {
      expect(newItem.daysUntilNextReview, 0);
      expect(inProgressItem.daysUntilNextReview, 0);
      expect(memorizedItem.daysUntilNextReview, 1);
    });

    test('should determine if item needs immediate review correctly', () {
      expect(newItem.needsImmediateReview, true);
      expect(inProgressItem.needsImmediateReview, true);
      expect(memorizedItem.needsImmediateReview, true);
    });

    test('should calculate priority score correctly', () {
      expect(newItem.priorityScore, 100);
      expect(inProgressItem.priorityScore, 1203);
      expect(memorizedItem.priorityScore, 300);
    });

    test('should copy with new values correctly', () {
      final updatedItem = newItem.copyWith(
        status: MemorizationStatus.inProgress,
        consecutiveReviewDays: 1,
      );
      
      expect(updatedItem.status, MemorizationStatus.inProgress);
      expect(updatedItem.consecutiveReviewDays, 1);
      expect(updatedItem.surahNumber, newItem.surahNumber);
    });
  });
}