


/// Data model for DetailedMemorizationStatistics that extends the entity with serialization methods
class DetailedMemorizationStatisticsModel extends DetailedMemorizationStatistics {
  /// Constructor
  const DetailedMemorizationStatisticsModel({
    required super.progressOverTime,
    required super.reviewFrequencyByDay,
    required super.averageStreakLength,
    required super.successRate,
    required super.archivedItemsCount,
    required super.reviewConsistency,
    required super.averagePagesPerDay,
  });

  /// Factory method to create from entity
  factory DetailedMemorizationStatisticsModel.fromEntity(DetailedMemorizationStatistics entity) {
    return DetailedMemorizationStatisticsModel(
      progressOverTime: entity.progressOverTime,
      reviewFrequencyByDay: entity.reviewFrequencyByDay,
      averageStreakLength: entity.averageStreakLength,
      successRate: entity.successRate,
      archivedItemsCount: entity.archivedItemsCount,
      reviewConsistency: entity.reviewConsistency,
      averagePagesPerDay: entity.averagePagesPerDay,
    );
  }

  /// Factory method to create from JSON
  factory DetailedMemorizationStatisticsModel.fromJson(Map<String, dynamic> json) {
    return DetailedMemorizationStatisticsModel(
      progressOverTime: (json['progressOverTime'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          DateTime.parse(key),
          value as int,
        ),
      ),
      reviewFrequencyByDay: (json['reviewFrequencyByDay'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          int.parse(key),
          value as int,
        ),
      ),
      averageStreakLength: (json['averageStreakLength'] as num).toDouble(),
      successRate: (json['successRate'] as num).toDouble(),
      archivedItemsCount: json['archivedItemsCount'] as int,
      reviewConsistency: (json['reviewConsistency'] as num).toDouble(),
      averagePagesPerDay: (json['averagePagesPerDay'] as num).toDouble(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'progressOverTime': progressOverTime.map(
        (key, value) => MapEntry(
          key.toIso8601String(),
          value,
        ),
      ),
      'reviewFrequencyByDay': reviewFrequencyByDay.map(
        (key, value) => MapEntry(
          key.toString(),
          value,
        ),
      ),
      'averageStreakLength': averageStreakLength,
      'successRate': successRate,
      'archivedItemsCount': archivedItemsCount,
      'reviewConsistency': reviewConsistency,
      'averagePagesPerDay': averagePagesPerDay,
    };
  }
}