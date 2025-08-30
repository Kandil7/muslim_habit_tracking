import 'package:equatable/equatable.dart';

import 'memorization_item.dart';

/// Entity representing a review schedule for memorization items
class ReviewSchedule extends Equatable {
  /// User-selected review period in days (5, 6, or 7)
  final int reviewPeriodDays;

  /// Items scheduled for review today
  final List<MemorizationItem> dailyItems;

  /// Constructor
  const ReviewSchedule({
    required this.reviewPeriodDays,
    required this.dailyItems,
  });

  @override
  List<Object?> get props => [reviewPeriodDays, dailyItems];

  /// Calculates the total number of items scheduled for today
  int get dailyItemCount => dailyItems.length;

  /// Calculates the number of in-progress items in today's schedule
  int get inProgressItemCount => dailyItems
      .where((item) => item.status == MemorizationStatus.inProgress)
      .length;

  /// Calculates the number of memorized items in today's schedule
  int get memorizedItemCount => dailyItems
      .where((item) => item.status == MemorizationStatus.memorized)
      .length;

  /// Gets the items that are overdue for review
  List<MemorizationItem> get overdueItems => dailyItems
      .where((item) => item.isOverdue)
      .toList();

  /// Gets the number of overdue items
  int get overdueItemCount => overdueItems.length;

  /// Gets the items that are due today but not overdue
  List<MemorizationItem> get dueTodayItems => dailyItems
      .where((item) => !item.isOverdue && item.status == MemorizationStatus.memorized)
      .toList();

  /// Gets the items that are in progress
  List<MemorizationItem> get inProgressItems => dailyItems
      .where((item) => item.status == MemorizationStatus.inProgress)
      .toList();

  /// Gets the items that are new
  List<MemorizationItem> get newItems => dailyItems
      .where((item) => item.status == MemorizationStatus.newStatus)
      .toList();

  /// Gets the items sorted by priority (highest priority first)
  List<MemorizationItem> get prioritizedItems {
    final sortedItems = List<MemorizationItem>.from(dailyItems);
    sortedItems.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    return sortedItems;
  }

  /// Gets the number of items that need immediate review
  int get immediateReviewCount => dailyItems
      .where((item) => item.needsImmediateReview)
      .length;

  /// Gets items that need immediate review, sorted by priority
  List<MemorizationItem> get immediateReviewItems {
    final items = dailyItems
        .where((item) => item.needsImmediateReview)
        .toList();
    items.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    return items;
  }

  /// Gets the completion percentage for today's review
  double get completionPercentage {
    if (dailyItems.isEmpty) return 100.0;
    
    final reviewedCount = dailyItems
        .where((item) => item.lastReviewed != null && 
            DateTime(
              item.lastReviewed!.year,
              item.lastReviewed!.month,
              item.lastReviewed!.day,
            ).isAtSameMomentAs(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            )))
        .length;
    
    return (reviewedCount / dailyItems.length) * 100;
  }
}