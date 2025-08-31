import 'package:muslim_habbit/features/ibadah_hub/domain/entities/adhkar.dart';

/// Repository interface for Adhkar management
abstract class AdhkarRepository {
  /// Get Adhkar by category
  Future<List<Adhkar>> getAdhkarByCategory(AdhkarCategory category);

  /// Get all Adhkar for today
  Future<List<Adhkar>> getTodaysAdhkar();

  /// Update Adhkar count
  Future<Adhkar> updateAdhkarCount(String id, int count);

  /// Mark Adhkar as completed
  Future<Adhkar> markAdhkarAsCompleted(String id);

  /// Reset Adhkar counts for a new day
  Future<void> resetDailyAdhkar();

  /// Get completed Adhkar count for today
  Future<int> getCompletedAdhkarCount();
}