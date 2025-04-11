import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../entities/habit_log.dart';

/// Repository interface for habit tracking
abstract class HabitRepository {
  /// Get all habits
  Future<Either<Failure, List<Habit>>> getHabits();
  
  /// Get a habit by ID
  Future<Either<Failure, Habit>> getHabitById(String id);
  
  /// Create a new habit
  Future<Either<Failure, Habit>> createHabit(Habit habit);
  
  /// Update an existing habit
  Future<Either<Failure, Habit>> updateHabit(Habit habit);
  
  /// Delete a habit
  Future<Either<Failure, void>> deleteHabit(String id);
  
  /// Get all logs for a habit
  Future<Either<Failure, List<HabitLog>>> getHabitLogs(String habitId);
  
  /// Get logs for a habit within a date range
  Future<Either<Failure, List<HabitLog>>> getHabitLogsByDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  );
  
  /// Create a new habit log
  Future<Either<Failure, HabitLog>> createHabitLog(HabitLog habitLog);
  
  /// Update an existing habit log
  Future<Either<Failure, HabitLog>> updateHabitLog(HabitLog habitLog);
  
  /// Delete a habit log
  Future<Either<Failure, void>> deleteHabitLog(String id);
}
