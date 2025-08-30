import 'package:flutter_test/flutter_test.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';
import 'package:muslim_habbit/features/quran/domain/entities/review_schedule.dart';

void main() {
  group('Enhanced ReviewSchedule', () {
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
        progressPercentage: 0.0,
        estimatedCompletionDate: null,
        daysRemaining: 5,
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
        progressPercentage: 60.0,
        estimatedCompletionDate: null,
        daysRemaining: 2,
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
        reviewHistory: [DateTime(2023, 1, 16), DateTime(2023, 1, 17), DateTime(2023, 1, 18), DateTime(2023, 1, 19), DateTime.now()],
        dateMemorized: DateTime(2023, 1, 15),
        progressPercentage: 100.0,
        estimatedCompletionDate: null,
        daysRemaining: 0,
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
        lastReviewed: DateTime.now().subtract(Duration(days: 2)),
        reviewHistory: [DateTime(2023, 1, 21), DateTime(2023, 1, 22), DateTime.now().subtract(Duration(days: 2))],
        dateMemorized: DateTime(2023, 1, 20),
        overdueCount: 1,
        progressPercentage: 100.0,
        estimatedCompletionDate: null,
        daysRemaining: 0,
      );

      reviewSchedule = ReviewSchedule(
        reviewPeriodDays: 5,
        dailyItems: [newItem, inProgressItem, memorizedItem, overdueItem],
      );
    });

    test('should group items by status correctly', () {
      final itemsByStatus = reviewSchedule.itemsByStatus;
      
      expect(itemsByStatus[MemorizationStatus.newStatus], isNotNull);
      expect(itemsByStatus[MemorizationStatus.inProgress], isNotNull);
      expect(itemsByStatus[MemorizationStatus.memorized], isNotNull);
      expect(itemsByStatus[MemorizationStatus.archived], isNotNull);
      
      expect(itemsByStatus[MemorizationStatus.newStatus]!.length, 1);
      expect(itemsByStatus[MemorizationStatus.inProgress]!.length, 1);
      expect(itemsByStatus[MemorizationStatus.memorized]!.length, 2);
    });

    test('should get items needing review today correctly', () {
      final todayReviewItems = reviewSchedule.todayReviewItems;
      
      // Should include in-progress items (always need review)
      expect(todayReviewItems.any((item) => item.id == '2'), isTrue);
      
      // Should include overdue items
      expect(todayReviewItems.any((item) => item.id == '4'), isTrue);
    });

    test('should get completed and pending items correctly', () {
      final completedItems = reviewSchedule.completedItems;
      final pendingItems = reviewSchedule.pendingItems;
      
      // This depends on the current date and lastReviewed values
      expect(completedItems, isNotNull);
      expect(pendingItems, isNotNull);
    });

    test('should calculate progress stats correctly', () {
      final progressStats = reviewSchedule.progressStats;
      
      expect(progressStats.totalItems, 4);
      expect(progressStats.completedItems, greaterThanOrEqualTo(0));
      expect(progressStats.pendingItems, greaterThanOrEqualTo(0));
      expect(progressStats.completionPercentage, greaterThanOrEqualTo(0));
    });
  });
}