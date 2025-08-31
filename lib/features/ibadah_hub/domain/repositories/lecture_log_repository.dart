import 'package:muslim_habbit/features/ibadah_hub/domain/entities/lecture_log.dart';

/// Repository interface for lecture log management
abstract class LectureLogRepository {
  /// Add a new lecture log entry
  Future<LectureLog> addLectureLog(LectureLog lecture);

  /// Get lecture logs for a date range
  Future<List<LectureLog>> getLecturesForDateRange(DateTime startDate, DateTime endDate);

  /// Get lecture log by ID
  Future<LectureLog?> getLectureById(String id);

  /// Update lecture log
  Future<LectureLog> updateLectureLog(LectureLog lecture);

  /// Delete lecture log
  Future<void> deleteLectureLog(String id);

  /// Get lectures by tag
  Future<List<LectureLog>> getLecturesByTag(String tag);

  /// Get lecture statistics
  Future<LectureStatistics> getLectureStatistics();
}

/// Class to hold lecture statistics
class LectureStatistics {
  final int totalLectures;
  final Duration totalTimeListened;
  final double averageRating;
  final int favoriteTagsCount;

  LectureStatistics({
    required this.totalLectures,
    required this.totalTimeListened,
    required this.averageRating,
    required this.favoriteTagsCount,
  });
}