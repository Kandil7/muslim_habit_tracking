import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../services/enhanced_notification_service.dart';

/// Utility class for enhancing notifications with motivational quotes and Islamic teachings
class NotificationEnhancer {
  static final EnhancedNotificationService _enhancedNotificationService =
      GetIt.instance<EnhancedNotificationService>();

  /// Show a notification with a motivational quote
  static Future<void> showMotivationalNotification({
    required int id,
    required String title,
    required String body,
    String? tag,
    String? payload,
  }) async {
    // Use the EnhancedNotificationService to show a notification with a motivational quote
    await _enhancedNotificationService.showMotivationalNotification(
      id: id,
      title: title,
      body: body,
      tag: tag,
      payload: payload,
    );
  }

  /// Schedule a notification with a motivational quote
  static Future<void> scheduleMotivationalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? tag,
    String? payload,
    bool repeats = false,
    RepeatInterval? repeatInterval,
  }) async {
    // Use the EnhancedNotificationService to schedule a notification with a motivational quote
    await _enhancedNotificationService.scheduleMotivationalNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      tag: tag,
      payload: payload,
      repeats: repeats,
      repeatInterval: repeatInterval,
    );
  }

  /// Schedule a daily notification with a motivational quote
  static Future<void> scheduleMotivationalDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay timeOfDay,
    String? tag,
    String? payload,
  }) async {
    // Use the EnhancedNotificationService to schedule a daily notification with a motivational quote
    await _enhancedNotificationService.scheduleMotivationalDailyNotification(
      id: id,
      title: title,
      body: body,
      timeOfDay: timeOfDay,
      tag: tag,
      payload: payload,
    );
  }

  /// Schedule a prayer notification with a relevant Islamic teaching
  static Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
    int minutesBefore = 15,
  }) async {
    // Use the EnhancedNotificationService to schedule a prayer notification
    await _enhancedNotificationService.scheduleEnhancedPrayerNotification(
      id: id,
      prayerName: prayerName,
      prayerTime: prayerTime,
      minutesBefore: minutesBefore,
    );
  }

  /// Schedule a habit reminder with a motivational quote
  static Future<void> scheduleHabitReminder({
    required int id,
    required String habitName,
    required TimeOfDay reminderTime,
    required String habitType,
  }) async {
    // Use the EnhancedNotificationService to schedule a habit reminder
    await _enhancedNotificationService.scheduleEnhancedHabitReminder(
      id: id,
      habitName: habitName,
      reminderTime: reminderTime,
      habitType: habitType,
    );
  }
}
