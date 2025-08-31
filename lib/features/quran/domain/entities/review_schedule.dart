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

  /// Gets the items grouped by status
  Map<MemorizationStatus, List<MemorizationItem>> get itemsByStatus {
    final Map<MemorizationStatus, List<MemorizationItem>> groupedItems = {};
    
    for (final status in MemorizationStatus.values) {
      groupedItems[status] = dailyItems
          .where((item) => item.status == status)
          .toList();
    }
    
    return groupedItems;
  }

  /// Gets the items that need review today, sorted by priority
  List<MemorizationItem> get todayReviewItems {
    // Get all items that need review today
    final itemsNeedingReview = dailyItems
        .where((item) => item.needsImmediateReview || 
            (item.status == MemorizationStatus.memorized && 
                (item.isOverdue || item.daysUntilNextReview == 0)))
        .toList();
    
    // Sort by priority
    itemsNeedingReview.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    return itemsNeedingReview;
  }

  /// Gets the items that are completed for today
  List<MemorizationItem> get completedItems {
    final today = DateTime.now();
    return dailyItems
        .where((item) => item.lastReviewed != null && 
            DateTime(
              item.lastReviewed!.year,
              item.lastReviewed!.month,
              item.lastReviewed!.day,
            ).isAtSameMomentAs(DateTime(
              today.year,
              today.month,
              today.day,
            )))
        .toList();
  }

  /// Gets the items that are pending review for today
  List<MemorizationItem> get pendingItems {
    return dailyItems
        .where((item) => item.lastReviewed == null || 
            !DateTime(
              item.lastReviewed!.year,
              item.lastReviewed!.month,
              item.lastReviewed!.day,
            ).isAtSameMomentAs(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            )))
        .toList();
  }

  /// Gets the progress statistics for today's review
  ReviewProgressStats get progressStats {
    final total = dailyItems.length;
    final completed = completedItems.length;
    final pending = pendingItems.length;
    
    return ReviewProgressStats(
      totalItems: total,
      completedItems: completed,
      pendingItems: pending,
      completionPercentage: total > 0 ? (completed / total) * 100 : 0,
    );
  }
}

/// Entity representing review progress statistics
class ReviewProgressStats extends Equatable {
  final int totalItems;
  final int completedItems;
  final int pendingItems;
  final double completionPercentage;

  const ReviewProgressStats({
    required this.totalItems,
    required this.completedItems,
    required this.pendingItems,
    required this.completionPercentage,
  });

  @override
  List<Object?> get props => [
    totalItems,
    completedItems,
    pendingItems,
    completionPercentage,
  ];
}