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

  /// Constructor
  const DetailedMemorizationStatistics({
    required this.progressOverTime,
    required this.reviewFrequencyByDay,
    required this.averageStreakLength,
    required this.successRate,
    required this.archivedItemsCount,
  });

  @override
  List<Object?> get props => [
        progressOverTime,
        reviewFrequencyByDay,
        averageStreakLength,
        successRate,
        archivedItemsCount,
      ];

  /// Creates a copy of this detailed statistics with specified fields replaced
  DetailedMemorizationStatistics copyWith({
    Map<DateTime, int>? progressOverTime,
    Map<int, int>? reviewFrequencyByDay,
    double? averageStreakLength,
    double? successRate,
    int? archivedItemsCount,
  }) {
    return DetailedMemorizationStatistics(
      progressOverTime: progressOverTime ?? this.progressOverTime,
      reviewFrequencyByDay: reviewFrequencyByDay ?? this.reviewFrequencyByDay,
      averageStreakLength: averageStreakLength ?? this.averageStreakLength,
      successRate: successRate ?? this.successRate,
      archivedItemsCount: archivedItemsCount ?? this.archivedItemsCount,
    );
  }
}