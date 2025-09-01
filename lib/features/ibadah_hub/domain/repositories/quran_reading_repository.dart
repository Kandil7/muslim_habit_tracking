import 'package:muslim_habbit/features/ibadah_hub/domain/entities/quran_reading.dart';

/// Repository interface for Quran reading management
abstract class QuranReadingRepository {
  /// Add a new Quran reading entry
  Future<QuranReading> addQuranReading(QuranReading reading);

  /// Get Quran readings for a specific date
  Future<List<QuranReading>> getReadingsForDate(DateTime date);

  /// Get Quran readings for a date range
  Future<List<QuranReading>> getReadingsForDateRange(DateTime startDate, DateTime endDate);

  /// Get total pages read
  Future<int> getTotalPagesRead();

  /// Get reading statistics
  Future<QuranReadingStatistics> getReadingStatistics();

  /// Get recent readings
  Future<List<QuranReading>> getRecentReadings(int limit);
}

/// Class to hold Quran reading statistics
class QuranReadingStatistics {
  final int totalPagesRead;
  final int totalAyahRead;
  final Duration totalTimeSpent;
  final int streakDays;
  final DateTime? lastReadingDate;

  QuranReadingStatistics({
    required this.totalPagesRead,
    required this.totalAyahRead,
    required this.totalTimeSpent,
    required this.streakDays,
    this.lastReadingDate,
  });
}