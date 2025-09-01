import 'package:muslim_habbit/features/self_development_hub/domain/entities/mindfulness_session.dart';

/// Repository interface for mindfulness session management
abstract class MindfulnessRepository {
  /// Start a new mindfulness session
  Future<MindfulnessSession> startSession(MindfulnessSession session);

  /// End a mindfulness session
  Future<MindfulnessSession> endSession(String id, DateTime endTime);

  /// Get all mindfulness sessions
  Future<List<MindfulnessSession>> getAllSessions();

  /// Get mindfulness session by ID
  Future<MindfulnessSession?> getSessionById(String id);

  /// Update mindfulness session
  Future<MindfulnessSession> updateSession(MindfulnessSession session);

  /// Delete mindfulness session
  Future<void> deleteSession(String id);

  /// Get sessions for a date range
  Future<List<MindfulnessSession>> getSessionsForDateRange(DateTime startDate, DateTime endDate);

  /// Get active session
  Future<MindfulnessSession?> getActiveSession();

  /// Get mindfulness statistics
  Future<MindfulnessStatistics> getMindfulnessStatistics();
}

/// Class to hold mindfulness statistics
class MindfulnessStatistics {
  final int totalSessions;
  final Duration totalTimeSpent;
  final Map<MindfulnessType, int> sessionsByType;
  final int streakDays;
  final DateTime? lastSessionDate;
  final double averageRating;

  MindfulnessStatistics({
    required this.totalSessions,
    required this.totalTimeSpent,
    required this.sessionsByType,
    required this.streakDays,
    this.lastSessionDate,
    required this.averageRating,
  });
}