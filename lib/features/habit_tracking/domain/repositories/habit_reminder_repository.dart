import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/habit_reminder.dart';

/// Repository interface for habit reminders
abstract class HabitReminderRepository {
  /// Get all reminders for a habit
  Future<Either<Failure, List<HabitReminder>>> getRemindersForHabit(String habitId);
  
  /// Create a new reminder
  Future<Either<Failure, HabitReminder>> createReminder(HabitReminder reminder);
  
  /// Update an existing reminder
  Future<Either<Failure, HabitReminder>> updateReminder(HabitReminder reminder);
  
  /// Delete a reminder
  Future<Either<Failure, void>> deleteReminder(String id);
  
  /// Enable or disable a reminder
  Future<Either<Failure, HabitReminder>> toggleReminder(String id, bool isEnabled);
}
