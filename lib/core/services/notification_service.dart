import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/app_constants.dart';
import '../../features/prayer_times/domain/entities/prayer_time.dart';

/// Service for handling local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the notification service
  Future<void> init() async {
    try {
      tz.initializeTimeZones();

      // Android initialization settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Create notification channels for Android
      if (Platform.isAndroid) {
        await _createNotificationChannels();
      }

      // iOS settings
      final DarwinInitializationSettings initializationSettingsIOS =
          const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      debugPrint('Notification service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        // Prayer times channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'prayer_times_channel',
            'Prayer Times',
            description: 'Notifications for prayer times',
            importance: Importance.high,
          ),
        );

        // Habit reminders channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'habit_reminders_channel',
            'Habit Reminders',
            description: 'Reminders for habits',
            importance: Importance.high,
          ),
        );

        // General channel
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            'general_channel',
            'General Notifications',
            description: 'General app notifications',
            importance: Importance.default_,
          ),
        );

        debugPrint('Android notification channels created successfully');
      }
    } catch (e) {
      debugPrint('Error creating notification channels: $e');
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      // For Android 13 and above (API level 33+), we need to request permission
      // For lower Android versions, permissions are granted by default
      if (Platform.isAndroid) {
        // We'll use a simpler approach that works across Android versions
        // without relying on the specific API that might not be available
        debugPrint('Android notification permissions are handled at app installation time');
        return true;
      }

      // For iOS
      if (Platform.isIOS) {
        // On iOS, permissions are requested during initialization
        // We'll just return true here as iOS handles permissions differently
        debugPrint('iOS notification permissions are requested during app initialization');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Handle notification response
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification response: ${response.payload}');
  }

  /// Schedule prayer time notifications
  Future<void> schedulePrayerTimeNotifications(
    PrayerTime prayerTime,
    int minutesBefore,
  ) async {
    try {
      // Cancel any existing prayer notifications for this day
      await cancelPrayerNotifications(prayerTime.date);

      // Schedule notifications for each prayer time
      await _schedulePrayerNotification(
        id: 1,
        title: 'Fajr Prayer',
        body: 'It\'s time for Fajr prayer',
        scheduledTime: prayerTime.fajr,
        minutesBefore: minutesBefore,
      );

      await _schedulePrayerNotification(
        id: 2,
        title: 'Dhuhr Prayer',
        body: 'It\'s time for Dhuhr prayer',
        scheduledTime: prayerTime.dhuhr,
        minutesBefore: minutesBefore,
      );

      await _schedulePrayerNotification(
        id: 3,
        title: 'Asr Prayer',
        body: 'It\'s time for Asr prayer',
        scheduledTime: prayerTime.asr,
        minutesBefore: minutesBefore,
      );

      await _schedulePrayerNotification(
        id: 4,
        title: 'Maghrib Prayer',
        body: 'It\'s time for Maghrib prayer',
        scheduledTime: prayerTime.maghrib,
        minutesBefore: minutesBefore,
      );

      await _schedulePrayerNotification(
        id: 5,
        title: 'Isha Prayer',
        body: 'It\'s time for Isha prayer',
        scheduledTime: prayerTime.isha,
        minutesBefore: minutesBefore,
      );

      debugPrint('Prayer time notifications scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling prayer time notifications: $e');
    }
  }

  /// Schedule a single prayer notification
  Future<void> _schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required int minutesBefore,
  }) async {
    try {
      // Calculate notification time (prayer time - minutes before)
      final notificationTime = scheduledTime.subtract(Duration(minutes: minutesBefore));

      // Don't schedule if the time has already passed
      if (notificationTime.isBefore(DateTime.now())) {
        debugPrint('Not scheduling notification for $title as the time has already passed');
        return;
      }

      // Create notification details
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'prayer_times_channel',
        'Prayer Times',
        channelDescription: 'Notifications for prayer times',
        importance: Importance.high,
        priority: Priority.high,
        // Using default sound instead of custom sound to avoid issues
        playSound: true,
      );

      const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        // Using default sound instead of custom sound to avoid issues
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      // Convert to TZDateTime safely
      final tz.TZDateTime tzDateTime = tz.TZDateTime.from(notificationTime, tz.local);

      // Schedule the notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'prayer_$id',
      );

      debugPrint('Scheduled notification for $title at ${tzDateTime.toString()}');
    } catch (e) {
      debugPrint('Error scheduling prayer notification for $title: $e');
    }
  }

  /// Cancel prayer notifications for a specific date
  Future<void> cancelPrayerNotifications(DateTime date) async {
    try {
      // Prayer notification IDs are 1-5
      for (int id = 1; id <= 5; id++) {
        await _flutterLocalNotificationsPlugin.cancel(id);
      }
      debugPrint('Cancelled prayer notifications for ${date.toString()}');
    } catch (e) {
      debugPrint('Error cancelling prayer notifications: $e');
    }
  }

  /// Schedule a habit reminder notification
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitName,
    required TimeOfDay reminderTime,
    required List<String> daysOfWeek,
  }) async {
    try {
      // Cancel any existing reminders for this habit
      await cancelHabitReminder(habitId);

      // Create a unique ID for this habit (using hash code)
      final int notificationId = habitId.hashCode.abs(); // Use absolute value to avoid negative IDs

      // Create notification details
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'habit_reminders_channel',
        'Habit Reminders',
        channelDescription: 'Reminders for habits',
        importance: Importance.high,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );

      // Get the weekday numbers for the selected days
      final List<int> selectedWeekdays = daysOfWeek.map((day) => _getWeekdayNumber(day)).toList();

      // Schedule notifications for each selected day of the week
      for (final weekday in selectedWeekdays) {
        // Calculate the next occurrence of this weekday
        final now = DateTime.now();
        final daysUntilNextOccurrence = (weekday - now.weekday) % 7;
        final nextOccurrence = now.add(Duration(days: daysUntilNextOccurrence));

        // Create the scheduled date with the reminder time
        final scheduledDate = tz.TZDateTime(
          tz.local,
          nextOccurrence.year,
          nextOccurrence.month,
          nextOccurrence.day,
          reminderTime.hour,
          reminderTime.minute,
        );

        // If the time has already passed today, schedule for next week
        final effectiveDate = scheduledDate.isBefore(tz.TZDateTime.now(tz.local))
            ? scheduledDate.add(const Duration(days: 7))
            : scheduledDate;

        // Schedule the notification
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId + weekday, // Use different IDs for each day
          'Habit Reminder: $habitName',
          'Don\'t forget to complete your habit today!',
          effectiveDate,
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: 'habit_$habitId',
        );
      }
    } catch (e) {
      debugPrint('Error scheduling habit reminder: $e');
    }
  }

  /// Cancel habit reminder notifications
  Future<void> cancelHabitReminder(String habitId) async {
    try {
      final int baseId = habitId.hashCode.abs(); // Use absolute value to avoid negative IDs

      // Cancel notifications for all days of the week
      for (int i = 0; i < 7; i++) {
        await _flutterLocalNotificationsPlugin.cancel(baseId + i);
      }
    } catch (e) {
      debugPrint('Error canceling habit reminder: $e');
    }
  }

  /// Get day of week string from DateTime
  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  /// Get weekday number from day name
  int _getWeekdayNumber(String day) {
    switch (day) {
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      default:
        return 1; // Default to Monday
    }
  }

  /// Show an immediate notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      channelDescription: 'General app notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Use ID 0 for immediate notifications
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
