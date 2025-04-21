import '../../domain/entities/quran_reading_history.dart';

/// Data model for Quran reading history
class QuranReadingHistoryModel extends QuranReadingHistory {
  /// Constructor
  const QuranReadingHistoryModel({
    required super.id,
    required super.pageNumber,
    required super.timestamp,
  });

  /// Create from JSON
  factory QuranReadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return QuranReadingHistoryModel(
      id: json['id'] as int,
      pageNumber: json['pageNumber'] as int,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageNumber': pageNumber,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  /// Create a copy with some fields replaced
  @override
  QuranReadingHistoryModel copyWith({
    int? id,
    int? pageNumber,
    DateTime? timestamp,
  }) {
    return QuranReadingHistoryModel(
      id: id ?? this.id,
      pageNumber: pageNumber ?? this.pageNumber,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
