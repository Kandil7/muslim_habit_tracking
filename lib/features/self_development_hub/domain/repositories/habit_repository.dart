import 'package:muslim_habbit/features/self_development_hub/domain/entities/habit.dart';

/// Repository interface for habit management
abstract class HabitRepository {
  /// Add a new habit
  Future<Habit> addHabit(Habit habit);

  /// Get all habits
  Future<List<Habit>> getAllHabits();

  /// Get habit by ID
  Future<Habit?> getHabitById(String id);

  /// Update habit
  Future<Habit> updateHabit(Habit habit);

  /// Delete habit
  Future<void> deleteHabit(String id);

  /// Get habits by area
  Future<List<Habit>> getHabitsByArea(HabitArea area);

  /// Get habits by status
  Future<List<Habit>> getHabitsByStatus(HabitStatus status);

  /// Mark habit as completed for today
  Future<Habit> markHabitAsCompleted(String id);

  /// Mark habit as not completed for today
  Future<Habit> markHabitAsNotCompleted(String id);

  /// Get active habits
  Future<List<Habit>> getActiveHabits();

  /// Get habit statistics
  Future<HabitStatistics> getHabitStatistics();
}

/// Class to hold habit statistics
class HabitStatistics {
  final int totalHabits;
  final int activeHabits;
  final Map<HabitArea, int> habitsByArea;
  final Map<HabitStatus, int> habitsByStatus;
  final int averageStreak;
  final double completionRate;

  HabitStatistics({
    required this.totalHabits,
    required this.activeHabits,
    required this.habitsByArea,
    required this.habitsByStatus,
    required this.averageStreak,
    required this.completionRate,
  });
}