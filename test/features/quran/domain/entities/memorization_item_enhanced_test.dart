import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_item.dart';

void main() {
  group('Enhanced MemorizationItem', () {
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
        lastReviewed: DateTime.now(), // Today so it's not overdue
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
        lastReviewed: DateTime.now().subtract(Duration(days: 2)), // 2 days ago so it's overdue
        reviewHistory: [DateTime(2023, 1, 21), DateTime(2023, 1, 22), DateTime.now().subtract(Duration(days: 2))],
        dateMemorized: DateTime(2023, 1, 20),
        overdueCount: 1,
        progressPercentage: 100.0,
        estimatedCompletionDate: null,
        daysRemaining: 0,
      );
    });

    test('should calculate progress percentage correctly', () {
      expect(newItem.calculateProgressPercentage(), 0.0);
      expect(inProgressItem.calculateProgressPercentage(), 60.0);
      expect(memorizedItem.calculateProgressPercentage(), 100.0);
    });

    test('should calculate estimated completion date correctly', () {
      expect(newItem.calculateEstimatedCompletionDate(), isNull);
      
      final estimatedCompletion = inProgressItem.calculateEstimatedCompletionDate();
      expect(estimatedCompletion, isNotNull);
      
      // Should be 2 days from now (5 - 3 = 2)
      final expectedDate = DateTime.now().add(Duration(days: 2));
      expect(estimatedCompletion!.difference(expectedDate).inDays, lessThan(1));
      
      expect(memorizedItem.calculateEstimatedCompletionDate(), memorizedItem.dateMemorized);
    });

    test('should calculate days remaining correctly', () {
      expect(newItem.calculateDaysRemaining(), 5);
      expect(inProgressItem.calculateDaysRemaining(), 2);
      expect(memorizedItem.calculateDaysRemaining(), 0);
    });

    test('should provide correct review status message', () {
      expect(newItem.reviewStatusMessage, contains('New item'));
      expect(inProgressItem.reviewStatusMessage, contains('3/5 days reviewed'));
      expect(memorizedItem.reviewStatusMessage, contains('Memorized'));
      expect(overdueItem.reviewStatusMessage, contains('Overdue'));
    });

    test('should provide correct status color', () {
      expect(newItem.statusColor, equals(Colors.blue));
      expect(inProgressItem.statusColor, equals(Colors.orange));
      expect(memorizedItem.statusColor, equals(Colors.green));
      expect(overdueItem.statusColor, equals(Colors.red));
    });

    test('should copy with new enhanced values correctly', () {
      final updatedItem = newItem.copyWith(
        progressPercentage: 20.0,
        daysRemaining: 4,
      );
      
      expect(updatedItem.progressPercentage, 20.0);
      expect(updatedItem.daysRemaining, 4);
      expect(updatedItem.surahNumber, newItem.surahNumber);
    });
  });
}