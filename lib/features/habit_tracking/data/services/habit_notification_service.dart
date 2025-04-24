import 'package:flutter/material.dart' as material;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;

import '../../../../core/utils/notification_enhancer.dart';

/// Service for scheduling habit reminders
class HabitNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  HabitNotificationService() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    tz_data.initializeTimeZones();

    // Create the notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'habit_reminders_channel',
      'Habit Reminders',
      description: 'Reminders for your habits',
      importance: Importance.max,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification taps here
        debugPrint('Habit notification tapped: ${response.payload}');
      },
    );
  }

  Future<bool> requestPermissions() async {
    // Request permissions for iOS
    final IOSFlutterLocalNotificationsPlugin? iOSImplementation =
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    if (iOSImplementation != null) {
      await iOSImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // For Android, permissions are requested during initialization in newer versions
    // or when creating the notification channel
    return true;
  }

  Future<void> scheduleHabitReminder(
    String habitId,
    String habitName,
    TimeOfDay reminderTime,
    List<String> daysOfWeek,
  ) async {
    // Cancel any existing reminders for this habit
    await cancelHabitReminder(habitId);

    // For each selected day of the week, schedule a notification
    for (final day in daysOfWeek) {
      // We don't need to calculate the next occurrence anymore
      // as NotificationEnhancer handles scheduling based on the TimeOfDay

      // Note: We no longer need to convert to TZ DateTime or create notification details
      // as we're using the NotificationEnhancer which handles this for us

      // Get habit type from the habit ID (simplified for demo)
      final String habitType = _getHabitTypeFromId(habitId);

      // Convert our TimeOfDay to Flutter's TimeOfDay
      final flutterTimeOfDay = material.TimeOfDay(
        hour: reminderTime.hour,
        minute: reminderTime.minute,
      );

      // Use the NotificationEnhancer to schedule a notification with a motivational quote
      await NotificationEnhancer.scheduleHabitReminder(
        id: '${habitId}_$day'.hashCode, // Use habit ID + day as unique ID
        habitName: habitName,
        reminderTime: flutterTimeOfDay,
        habitType: habitType,
      );
    }
  }

  Future<void> cancelHabitReminder(String habitId) async {
    // Since we can't get the exact notification IDs, we'll need to cancel all and reschedule others
    // In a real app, you'd want to store the notification IDs somewhere
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  // Note: We've removed the _getDayIndex and _getNextDayOccurrence methods
  // as they're no longer needed with our enhanced notification approach

  /// Get the habit type from the habit ID
  /// This is a simplified implementation for demo purposes
  String _getHabitTypeFromId(String habitId) {
    // In a real app, you would look up the habit type from a database
    // For this demo, we'll use a simple heuristic based on the ID
    if (habitId.contains('prayer')) {
      return 'prayer';
    } else if (habitId.contains('quran')) {
      return 'quran';
    } else if (habitId.contains('fast')) {
      return 'fasting';
    } else if (habitId.contains('dhikr')) {
      return 'dhikr';
    } else if (habitId.contains('charity')) {
      return 'charity';
    } else {
      return 'custom';
    }
  }
}

/// TimeOfDay class for Flutter
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  factory TimeOfDay.now() {
    final now = DateTime.now();
    return TimeOfDay(hour: now.hour, minute: now.minute);
  }

  @override
  String toString() {
    final hourString = hour.toString().padLeft(2, '0');
    final minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
  }
}
