import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/memorization_item.dart';
import '../entities/memorization_preferences.dart';
import '../entities/review_schedule.dart';

/// Repository interface for Quran memorization tracking
abstract class MemorizationRepository {
  /// Get all memorization items
  Future<Either<Failure, List<MemorizationItem>>> getMemorizationItems();

  /// Get a memorization item by ID
  Future<Either<Failure, MemorizationItem>> getMemorizationItemById(String id);

  /// Create a new memorization item
  Future<Either<Failure, MemorizationItem>> createMemorizationItem(
      MemorizationItem item);

  /// Update an existing memorization item
  Future<Either<Failure, MemorizationItem>> updateMemorizationItem(
      MemorizationItem item);

  /// Delete a memorization item
  Future<Either<Failure, void>> deleteMemorizationItem(String id);

  /// Get the daily review schedule
  Future<Either<Failure, ReviewSchedule>> getDailyReviewSchedule();

  /// Mark an item as reviewed today
  Future<Either<Failure, MemorizationItem>> markItemAsReviewed(String itemId);

  /// Get user preferences
  Future<Either<Failure, MemorizationPreferences>> getPreferences();

  /// Update user preferences
  Future<Either<Failure, MemorizationPreferences>> updatePreferences(
      MemorizationPreferences preferences);

  /// Get statistics about memorization progress
  Future<Either<Failure, MemorizationStatistics>> getMemorizationStatistics();

  /// Get detailed statistics for charts and graphs
  Future<Either<Failure, DetailedMemorizationStatistics>> getDetailedStatistics();

  /// Get items by status
  Future<Either<Failure, List<MemorizationItem>>> getItemsByStatus(MemorizationStatus status);

  /// Archive an item
  Future<Either<Failure, MemorizationItem>> archiveItem(String itemId);

  /// Unarchive an item
  Future<Either<Failure, MemorizationItem>> unarchiveItem(String itemId);

  /// Get overdue items
  Future<Either<Failure, List<MemorizationItem>>> getOverdueItems();

  /// Reset item progress
  Future<Either<Failure, MemorizationItem>> resetItemProgress(String itemId);

  /// Get items needing review today
  Future<Either<Failure, List<MemorizationItem>>> getItemsNeedingReview();

  /// Get review history for an item
  Future<Either<Failure, List<DateTime>>> getItemReviewHistory(String itemId);

  /// Get items by surah number
  Future<Either<Failure, List<MemorizationItem>>> getItemsBySurah(int surahNumber);

  /// Get items within a date range
  Future<Either<Failure, List<MemorizationItem>>> getItemsByDateRange(DateTime start, DateTime end);

  /// Get streak statistics
  Future<Either<Failure, StreakStatistics>> getStreakStatistics();

  /// Get progress statistics for a specific period
  Future<Either<Failure, ProgressStatistics>> getProgressStatistics(DateTime start, DateTime end);
}

/// Entity representing statistics about memorization progress
class MemorizationStatistics extends Equatable {
  /// Total number of items being memorized
  final int totalItems;

  /// Number of items in each status
  final Map<MemorizationStatus, int> itemsByStatus;

  /// Total number of pages memorized
  final int totalPagesMemorized;

  /// Current review streak (consecutive days of reviews)
  final int currentStreak;

  /// Longest review streak achieved
  final int longestStreak;

  /// Percentage of items that are memorized
  final double memorizationPercentage;

  /// Total number of reviews completed
  final int totalReviews;

  /// Average reviews per day
  final double averageReviewsPerDay;

  /// Number of overdue items
  final int overdueItemsCount;

  /// Constructor
  const MemorizationStatistics({
    required this.totalItems,
    required this.itemsByStatus,
    required this.totalPagesMemorized,
    required this.currentStreak,
    required this.longestStreak,
    required this.memorizationPercentage,
    required this.totalReviews,
    required this.averageReviewsPerDay,
    required this.overdueItemsCount,
  });

  @override
  List<Object?> get props => [
        totalItems,
        itemsByStatus,
        totalPagesMemorized,
        currentStreak,
        longestStreak,
        memorizationPercentage,
        totalReviews,
        averageReviewsPerDay,
        overdueItemsCount,
      ];

  /// Creates a copy of this statistics with specified fields replaced
  MemorizationStatistics copyWith({
    int? totalItems,
    Map<MemorizationStatus, int>? itemsByStatus,
    int? totalPagesMemorized,
    int? currentStreak,
    int? longestStreak,
    double? memorizationPercentage,
    int? totalReviews,
    double? averageReviewsPerDay,
    int? overdueItemsCount,
  }) {
    return MemorizationStatistics(
      totalItems: totalItems ?? this.totalItems,
      itemsByStatus: itemsByStatus ?? this.itemsByStatus,
      totalPagesMemorized: totalPagesMemorized ?? this.totalPagesMemorized,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      memorizationPercentage: memorizationPercentage ?? this.memorizationPercentage,
      totalReviews: totalReviews ?? this.totalReviews,
      averageReviewsPerDay: averageReviewsPerDay ?? this.averageReviewsPerDay,
      overdueItemsCount: overdueItemsCount ?? this.overdueItemsCount,
    );
  }
}

/// Entity representing detailed statistics for charts and graphs
class DetailedMemorizationStatistics extends Equatable {
  /// Progress over time (date -> number of items memorized)
  final Map<DateTime, int> progressOverTime;

  /// Review frequency by day of week
  final Map<int, int> reviewFrequencyByDay;

  /// Average streak length
  final double averageStreakLength;

  /// Success rate (percentage of items that reached memorized status)
  final double successRate;

  /// Number of items that were archived
  final int archivedItemsCount;

  /// Review consistency percentage
  final double reviewConsistency;

  /// Average pages memorized per day
  final double averagePagesPerDay;

  /// Constructor
  const DetailedMemorizationStatistics({
    required this.progressOverTime,
    required this.reviewFrequencyByDay,
    required this.averageStreakLength,
    required this.successRate,
    required this.archivedItemsCount,
    required this.reviewConsistency,
    required this.averagePagesPerDay,
  });

  @override
  List<Object?> get props => [
        progressOverTime,
        reviewFrequencyByDay,
        averageStreakLength,
        successRate,
        archivedItemsCount,
        reviewConsistency,
        averagePagesPerDay,
      ];

  /// Creates a copy of this detailed statistics with specified fields replaced
  DetailedMemorizationStatistics copyWith({
    Map<DateTime, int>? progressOverTime,
    Map<int, int>? reviewFrequencyByDay,
    double? averageStreakLength,
    double? successRate,
    int? archivedItemsCount,
    double? reviewConsistency,
    double? averagePagesPerDay,
  }) {
    return DetailedMemorizationStatistics(
      progressOverTime: progressOverTime ?? this.progressOverTime,
      reviewFrequencyByDay: reviewFrequencyByDay ?? this.reviewFrequencyByDay,
      averageStreakLength: averageStreakLength ?? this.averageStreakLength,
      successRate: successRate ?? this.successRate,
      archivedItemsCount: archivedItemsCount ?? this.archivedItemsCount,
      reviewConsistency: reviewConsistency ?? this.reviewConsistency,
      averagePagesPerDay: averagePagesPerDay ?? this.averagePagesPerDay,
    );
  }
}

/// Entity representing streak statistics
class StreakStatistics extends Equatable {
  /// Current review streak (consecutive days of reviews)
  final int currentStreak;

  /// Longest review streak achieved
  final int longestStreak;

  /// Streak history (date -> streak length)
  final Map<DateTime, int> streakHistory;

  /// Constructor
  const StreakStatistics({
    required this.currentStreak,
    required this.longestStreak,
    required this.streakHistory,
  });

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
        streakHistory,
      ];

  /// Creates a copy of this streak statistics with specified fields replaced
  StreakStatistics copyWith({
    int? currentStreak,
    int? longestStreak,
    Map<DateTime, int>? streakHistory,
  }) {
    return StreakStatistics(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      streakHistory: streakHistory ?? this.streakHistory,
    );
  }
}

/// Entity representing progress statistics for a specific period
class ProgressStatistics extends Equatable {
  /// Start date of the period
  final DateTime startDate;

  /// End date of the period
  final DateTime endDate;

  /// Number of items started during the period
  final int itemsStarted;

  /// Number of items completed (memorized) during the period
  final int itemsCompleted;

  /// Number of reviews during the period
  final int reviewsCount;

  /// Average progress per day during the period
  final double averageProgressPerDay;

  /// Constructor
  const ProgressStatistics({
    required this.startDate,
    required this.endDate,
    required this.itemsStarted,
    required this.itemsCompleted,
    required this.reviewsCount,
    required this.averageProgressPerDay,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        itemsStarted,
        itemsCompleted,
        reviewsCount,
        averageProgressPerDay,
      ];

  /// Creates a copy of this progress statistics with specified fields replaced
  ProgressStatistics copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? itemsStarted,
    int? itemsCompleted,
    int? reviewsCount,
    double? averageProgressPerDay,
  }) {
    return ProgressStatistics(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      itemsStarted: itemsStarted ?? this.itemsStarted,
      itemsCompleted: itemsCompleted ?? this.itemsCompleted,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      averageProgressPerDay: averageProgressPerDay ?? this.averageProgressPerDay,
    );
  }
}