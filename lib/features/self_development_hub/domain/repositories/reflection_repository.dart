import 'package:muslim_habbit/features/self_development_hub/domain/entities/reflection_entry.dart';

/// Repository interface for reflection entry management
abstract class ReflectionRepository {
  /// Add a new reflection entry
  Future<ReflectionEntry> addReflectionEntry(ReflectionEntry entry);

  /// Get all reflection entries
  Future<List<ReflectionEntry>> getAllReflectionEntries();

  /// Get reflection entry by ID
  Future<ReflectionEntry?> getReflectionEntryById(String id);

  /// Update reflection entry
  Future<ReflectionEntry> updateReflectionEntry(ReflectionEntry entry);

  /// Delete reflection entry
  Future<void> deleteReflectionEntry(String id);

  /// Get reflection entries for a date range
  Future<List<ReflectionEntry>> getEntriesForDateRange(DateTime startDate, DateTime endDate);

  /// Search reflection entries by query
  Future<List<ReflectionEntry>> searchReflectionEntries(String query);

  /// Get reflection entries by tag
  Future<List<ReflectionEntry>> getEntriesByTag(String tag);

  /// Get reflection statistics
  Future<ReflectionStatistics> getReflectionStatistics();
}

/// Class to hold reflection statistics
class ReflectionStatistics {
  final int totalEntries;
  final DateTime? lastEntryDate;
  final Map<String, int> entriesByMood;
  final int streakDays;
  final List<String> mostCommonTags;

  ReflectionStatistics({
    required this.totalEntries,
    this.lastEntryDate,
    required this.entriesByMood,
    required this.streakDays,
    required this.mostCommonTags,
  });
}