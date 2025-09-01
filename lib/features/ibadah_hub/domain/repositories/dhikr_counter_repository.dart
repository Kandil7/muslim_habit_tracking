import 'package:muslim_habbit/features/ibadah_hub/domain/entities/dhikr_counter.dart';

/// Repository interface for Dhikr counter management
abstract class DhikrCounterRepository {
  /// Start a new Dhikr counter session
  Future<DhikrCounter> startDhikrSession(DhikrCounter session);

  /// Update Dhikr counter
  Future<DhikrCounter> updateDhikrCount(String id, int count);

  /// Complete Dhikr session
  Future<DhikrCounter> completeDhikrSession(String id);

  /// Get active Dhikr session
  Future<DhikrCounter?> getActiveSession();

  /// Get Dhikr history
  Future<List<DhikrCounter>> getDhikrHistory(DateTime startDate, DateTime endDate);

  /// Get Dhikr statistics
  Future<DhikrStatistics> getDhikrStatistics();
}

/// Class to hold Dhikr statistics
class DhikrStatistics {
  final int totalSessions;
  final int totalCounts;
  final Duration totalTimeSpent;
  final int streakDays;
  final DateTime? lastSessionDate;

  DhikrStatistics({
    required this.totalSessions,
    required this.totalCounts,
    required this.totalTimeSpent,
    required this.streakDays,
    this.lastSessionDate,
  });
}