import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/habit_reminder.dart';
import '../../domain/repositories/habit_reminder_repository.dart';
import '../models/habit_reminder_model.dart';
import '../services/habit_notification_service.dart';

/// Implementation of the HabitReminderRepository
class HabitReminderRepositoryImpl implements HabitReminderRepository {
  final SharedPreferences _sharedPreferences;
  final HabitNotificationService _notificationService;

  static const String _remindersKey = 'habit_reminders';

  HabitReminderRepositoryImpl({
    required SharedPreferences sharedPreferences,
    required HabitNotificationService notificationService,
  }) :
    _sharedPreferences = sharedPreferences,
    _notificationService = notificationService;

  @override
  Future<Either<Failure, List<HabitReminder>>> getRemindersForHabit(String habitId) async {
    try {
      final reminders = _getRemindersFromPrefs();
      final habitReminders = reminders.where((r) => r.habitId == habitId).toList();
      return Right(habitReminders);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get reminders: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, HabitReminder>> createReminder(HabitReminder reminder) async {
    try {
      final reminders = _getRemindersFromPrefs();

      // Check if a reminder with this ID already exists
      if (reminders.any((r) => r.id == reminder.id)) {
        return Left(CacheFailure(message: 'A reminder with this ID already exists'));
      }

      // Add the new reminder
      final reminderModel = HabitReminderModel.fromEntity(reminder);
      reminders.add(reminderModel);

      // Save to SharedPreferences
      await _saveRemindersToPrefs(reminders);

      // Schedule the notification if the reminder is enabled
      if (reminder.isEnabled) {
        await _scheduleReminderNotification(reminder);
      }

      return Right(reminder);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to create reminder: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, HabitReminder>> updateReminder(HabitReminder reminder) async {
    try {
      final reminders = _getRemindersFromPrefs();

      // Find the index of the reminder to update
      final index = reminders.indexWhere((r) => r.id == reminder.id);

      if (index == -1) {
        return Left(CacheFailure(message: 'Reminder not found'));
      }

      // Update the reminder
      final reminderModel = HabitReminderModel.fromEntity(reminder);
      reminders[index] = reminderModel;

      // Save to SharedPreferences
      await _saveRemindersToPrefs(reminders);

      // Update the notification
      if (reminder.isEnabled) {
        await _scheduleReminderNotification(reminder);
      } else {
        await _notificationService.cancelHabitReminder(reminder.habitId);
      }

      return Right(reminder);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update reminder: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReminder(String id) async {
    try {
      final reminders = _getRemindersFromPrefs();

      // Find the reminder to delete
      final reminderToDelete = reminders.firstWhere(
        (r) => r.id == id,
        orElse: () => throw Exception('Reminder not found'),
      );

      // Remove the reminder
      reminders.removeWhere((r) => r.id == id);

      // Save to SharedPreferences
      await _saveRemindersToPrefs(reminders);

      // Cancel the notification
      await _notificationService.cancelHabitReminder(reminderToDelete.habitId);

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete reminder: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, HabitReminder>> toggleReminder(String id, bool isEnabled) async {
    try {
      final reminders = _getRemindersFromPrefs();

      // Find the index of the reminder to update
      final index = reminders.indexWhere((r) => r.id == id);

      if (index == -1) {
        return Left(CacheFailure(message: 'Reminder not found'));
      }

      // Update the reminder
      final updatedReminder = reminders[index].copyWith(isEnabled: isEnabled);
      reminders[index] = updatedReminder;

      // Save to SharedPreferences
      await _saveRemindersToPrefs(reminders);

      // Update the notification
      if (isEnabled) {
        await _scheduleReminderNotification(updatedReminder);
      } else {
        await _notificationService.cancelHabitReminder(updatedReminder.habitId);
      }

      return Right(updatedReminder);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to toggle reminder: ${e.toString()}'));
    }
  }

  /// Get all reminders from SharedPreferences
  List<HabitReminderModel> _getRemindersFromPrefs() {
    final remindersJson = _sharedPreferences.getString(_remindersKey);

    if (remindersJson == null) {
      return [];
    }

    final List<dynamic> decodedJson = jsonDecode(remindersJson);
    return decodedJson
        .map((json) => HabitReminderModel.fromJson(json))
        .toList();
  }

  /// Save reminders to SharedPreferences
  Future<void> _saveRemindersToPrefs(List<HabitReminderModel> reminders) async {
    final remindersJson = jsonEncode(reminders.map((r) => r.toJson()).toList());
    await _sharedPreferences.setString(_remindersKey, remindersJson);
  }

  /// Schedule a notification for a reminder
  Future<void> _scheduleReminderNotification(HabitReminder reminder) async {
    await _notificationService.scheduleHabitReminder(
      reminder.habitId,
      'Habit Reminder', // Generic name since we don't have the habit object
      TimeOfDay(hour: reminder.hour, minute: reminder.minute),
      reminder.daysOfWeek,
    );
  }
}
