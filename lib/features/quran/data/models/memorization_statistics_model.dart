
/// Data model for MemorizationStatistics that extends the entity with serialization methods
class MemorizationStatisticsModel extends MemorizationStatistics {
  /// Constructor
  const MemorizationStatisticsModel({
    required super.totalItems,
    required super.itemsByStatus,
    required super.totalPagesMemorized,
    required super.currentStreak,
    required super.longestStreak,
    required super.memorizationPercentage,
    required super.totalReviews,
    required super.averageReviewsPerDay,
    required super.overdueItemsCount,
  });

  /// Factory method to create from entity
  factory MemorizationStatisticsModel.fromEntity(MemorizationStatistics entity) {
    return MemorizationStatisticsModel(
      totalItems: entity.totalItems,
      itemsByStatus: entity.itemsByStatus,
      totalPagesMemorized: entity.totalPagesMemorized,
      currentStreak: entity.currentStreak,
      longestStreak: entity.longestStreak,
      memorizationPercentage: entity.memorizationPercentage,
      totalReviews: entity.totalReviews,
      averageReviewsPerDay: entity.averageReviewsPerDay,
      overdueItemsCount: entity.overdueItemsCount,
    );
  }

  /// Factory method to create from JSON
  factory MemorizationStatisticsModel.fromJson(Map<String, dynamic> json) {
    return MemorizationStatisticsModel(
      totalItems: json['totalItems'] as int,
      itemsByStatus: (json['itemsByStatus'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          _statusFromString(key),
          value as int,
        ),
      ),
      totalPagesMemorized: json['totalPagesMemorized'] as int,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      memorizationPercentage: (json['memorizationPercentage'] as num).toDouble(),
      totalReviews: json['totalReviews'] as int,
      averageReviewsPerDay: (json['averageReviewsPerDay'] as num).toDouble(),
      overdueItemsCount: json['overdueItemsCount'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'itemsByStatus': itemsByStatus.map(
        (key, value) => MapEntry(
          _statusToString(key),
          value,
        ),
      ),
      'totalPagesMemorized': totalPagesMemorized,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'memorizationPercentage': memorizationPercentage,
      'totalReviews': totalReviews,
      'averageReviewsPerDay': averageReviewsPerDay,
      'overdueItemsCount': overdueItemsCount,
    };
  }

  /// Convert status to string
  String _statusToString(MemorizationStatus status) {
    switch (status) {
      case MemorizationStatus.newStatus:
        return 'new';
      case MemorizationStatus.inProgress:
        return 'inProgress';
      case MemorizationStatus.memorized:
        return 'memorized';
      case MemorizationStatus.archived:
        return 'archived';
    }
  }

  /// Convert string to status
  static MemorizationStatus _statusFromString(String status) {
    switch (status) {
      case 'new':
        return MemorizationStatus.newStatus;
      case 'inProgress':
        return MemorizationStatus.inProgress;
      case 'memorized':
        return MemorizationStatus.memorized;
      case 'archived':
        return MemorizationStatus.archived;
      default:
        return MemorizationStatus.newStatus;
    }
  }
}