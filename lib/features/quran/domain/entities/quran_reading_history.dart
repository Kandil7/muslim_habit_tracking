import 'package:equatable/equatable.dart';

/// Entity representing a Quran reading history entry
class QuranReadingHistory extends Equatable {
  /// Unique identifier
  final int id;

  /// Page number
  final int pageNumber;

  /// Timestamp when the page was read
  final DateTime timestamp;

  /// Constructor
  const QuranReadingHistory({
    required this.id,
    required this.pageNumber,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, pageNumber, timestamp];

  /// Create a copy with some fields replaced
  QuranReadingHistory copyWith({
    int? id,
    int? pageNumber,
    DateTime? timestamp,
  }) {
    return QuranReadingHistory(
      id: id ?? this.id,
      pageNumber: pageNumber ?? this.pageNumber,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
