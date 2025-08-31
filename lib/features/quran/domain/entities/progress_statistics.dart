import 'package:equatable/equatable.dart';

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