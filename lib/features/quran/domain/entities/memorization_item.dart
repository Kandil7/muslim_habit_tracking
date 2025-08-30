import 'package:equatable/equatable.dart';

/// Status of a memorization item
enum MemorizationStatus {
  /// Newly added item that has not been reviewed yet
  newStatus,

  /// Item being actively memorized (0-4 consecutive review days)
  inProgress,

  /// Item that has been successfully memorized (5+ consecutive review days)
  memorized,

  /// Memorized item that has been paused or archived
  archived
}

/// Entity representing a Quran memorization item (surah or part)
class MemorizationItem extends Equatable {
  /// Unique identifier for the memorization item
  final String id;

  /// Surah number (1-114) or 0 for non-surah parts
  final int surahNumber;

  /// Name of the surah or part
  final String surahName;

  /// Starting page number in the Quran
  final int startPage;

  /// Ending page number in the Quran
  final int endPage;

  /// Date when the item was added for memorization
  final DateTime dateAdded;

  /// Current status of memorization
  final MemorizationStatus status;

  /// Number of consecutive days the item has been reviewed
  /// Ranges from 0-5 for tracking progress to "Memorized" status
  final int consecutiveReviewDays;

  /// Timestamp of the last review
  final DateTime? lastReviewed;

  /// History of all review timestamps
  final List<DateTime> reviewHistory;

  /// Number of times this item has been marked as overdue
  final int overdueCount;

  /// Date when this item was first marked as memorized
  final DateTime? dateMemorized;

  /// Constructor
  const MemorizationItem({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.startPage,
    required this.endPage,
    required this.dateAdded,
    required this.status,
    required this.consecutiveReviewDays,
    required this.lastReviewed,
    required this.reviewHistory,
    this.overdueCount = 0,
    this.dateMemorized,
  });

  @override
  List<Object?> get props => [
        id,
        surahNumber,
        surahName,
        startPage,
        endPage,
        dateAdded,
        status,
        consecutiveReviewDays,
        lastReviewed,
        reviewHistory,
        overdueCount,
        dateMemorized,
      ];

  /// Creates a copy of this item with specified fields replaced
  MemorizationItem copyWith({
    String? id,
    int? surahNumber,
    String? surahName,
    int? startPage,
    int? endPage,
    DateTime? dateAdded,
    MemorizationStatus? status,
    int? consecutiveReviewDays,
    DateTime? lastReviewed,
    List<DateTime>? reviewHistory,
    int? overdueCount,
    DateTime? dateMemorized,
  }) {
    return MemorizationItem(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      startPage: startPage ?? this.startPage,
      endPage: endPage ?? this.endPage,
      dateAdded: dateAdded ?? this.dateAdded,
      status: status ?? this.status,
      consecutiveReviewDays: consecutiveReviewDays ?? this.consecutiveReviewDays,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      reviewHistory: reviewHistory ?? this.reviewHistory,
      overdueCount: overdueCount ?? this.overdueCount,
      dateMemorized: dateMemorized ?? this.dateMemorized,
    );
  }

  /// Calculates the total number of pages in this memorization item
  int get pageCount => endPage - startPage + 1;

  /// Determines if this item is due for review today
  bool isDueForReview(int reviewPeriod) {
    if (status != MemorizationStatus.memorized) return false;
    if (lastReviewed == null) return true;

    // Calculate which group this item belongs to
    final itemGroup = id.hashCode % reviewPeriod;

    // Calculate which group should be reviewed today
    final dayInCycle = DateTime.now().weekday % reviewPeriod;

    return itemGroup == dayInCycle;
  }

  /// Checks if this item is overdue for review
  bool get isOverdue {
    if (status != MemorizationStatus.memorized || lastReviewed == null) return false;
    final now = DateTime.now();
    final lastReviewDate = DateTime(
      lastReviewed!.year,
      lastReviewed!.month,
      lastReviewed!.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(lastReviewDate).inDays > 1;
  }

  /// Gets the streak completion percentage (0-100)
  double get streakCompletionPercentage {
    if (status == MemorizationStatus.memorized) return 100.0;
    return (consecutiveReviewDays / 5) * 100;
  }

  /// Gets the number of days until this item is due for review again
  int get daysUntilNextReview {
    if (status != MemorizationStatus.memorized || lastReviewed == null) return 0;
    
    final now = DateTime.now();
    final lastReviewDate = DateTime(
      lastReviewed!.year,
      lastReviewed!.month,
      lastReviewed!.day,
    );
    
    // Calculate days since last review
    final daysSinceLastReview = now.difference(lastReviewDate).inDays;
    
    // If already overdue, return 0
    if (daysSinceLastReview > 1) return 0;
    
    // Otherwise, return days until next review (1 day for consecutive days)
    return 1;
  }

  /// Checks if this item needs immediate review (due today or overdue)
  bool get needsImmediateReview {
    if (status == MemorizationStatus.newStatus || status == MemorizationStatus.inProgress) {
      return true; // In-progress items always need review
    }
    
    if (status == MemorizationStatus.memorized) {
      // For memorized items, check if due or overdue
      return isOverdue || daysUntilNextReview == 0;
    }
    
    return false;
  }

  /// Gets the priority score for this item (higher means higher priority)
  int get priorityScore {
    // In-progress items have highest priority, especially older ones
    if (status == MemorizationStatus.inProgress) {
      // Priority based on consecutive days (items closer to memorization have higher priority)
      // and date added (older items have higher priority)
      final daysSinceAdded = DateTime.now().difference(dateAdded).inDays;
      return 1000 + (5 - consecutiveReviewDays) * 100 + daysSinceAdded;
    }
    
    // Memorized items that are overdue have high priority
    if (status == MemorizationStatus.memorized && isOverdue) {
      return 500 + overdueCount * 50;
    }
    
    // Memorized items due today have medium priority
    if (status == MemorizationStatus.memorized && daysUntilNextReview == 0) {
      return 300;
    }
    
    // New items have low priority
    if (status == MemorizationStatus.newStatus) {
      return 100;
    }
    
    // Archived items have lowest priority
    return 0;
  }
}