import 'package:dartz/dartz.dart';

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

  /// Constructor
  const MemorizationStatistics({
    required this.totalItems,
    required this.itemsByStatus,
    required this.totalPagesMemorized,
    required this.currentStreak,
    required this.longestStreak,
    required this.memorizationPercentage,
  });

  @override
  List<Object?> get props => [
        totalItems,
        itemsByStatus,
        totalPagesMemorized,
        currentStreak,
        longestStreak,
        memorizationPercentage,
      ];

  /// Creates a copy of this statistics with specified fields replaced
  MemorizationStatistics copyWith({
    int? totalItems,
    Map<MemorizationStatus, int>? itemsByStatus,
    int? totalPagesMemorized,
    int? currentStreak,
    int? longestStreak,
    double? memorizationPercentage,
  }) {
    return MemorizationStatistics(
      totalItems: totalItems ?? this.totalItems,
      itemsByStatus: itemsByStatus ?? this.itemsByStatus,
      totalPagesMemorized: totalPagesMemorized ?? this.totalPagesMemorized,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      memorizationPercentage: memorizationPercentage ?? this.memorizationPercentage,
    );
  }
}