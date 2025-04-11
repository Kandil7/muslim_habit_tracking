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
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }
  
  /// Request notification permissions
  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    
    final bool? androidPermissionGranted =
        await androidPlugin?.requestPermission();
    
    final DarwinFlutterLocalNotificationsPlugin? iOSPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            DarwinFlutterLocalNotificationsPlugin>();
    
    final bool? iOSPermissionGranted = await iOSPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    return androidPermissionGranted ?? iOSPermissionGranted ?? false;
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
  }
  
  /// Schedule a single prayer notification
  Future<void> _schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required int minutesBefore,
  }) async {
    // Calculate notification time (prayer time - minutes before)
    final notificationTime = scheduledTime.subtract(Duration(minutes: minutesBefore));
    
    // Don't schedule if the time has already passed
    if (notificationTime.isBefore(DateTime.now())) {
      return;
    }
    
    // Create notification details
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'Prayer Times',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('adhan'),
      playSound: true,
    );
    
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      sound: 'adhan.aiff',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );
    
    // Schedule the notification
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(notificationTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'prayer_$id',
    );
  }
  
  /// Cancel prayer notifications for a specific date
  Future<void> cancelPrayerNotifications(DateTime date) async {
    // Prayer notification IDs are 1-5
    for (int id = 1; id <= 5; id++) {
      await _flutterLocalNotificationsPlugin.cancel(id);
    }
  }
  
  /// Schedule a habit reminder notification
  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitName,
    required TimeOfDay reminderTime,
    required List<String> daysOfWeek,
  }) async {
    // Cancel any existing reminders for this habit
    await cancelHabitReminder(habitId);
    
    // Create a unique ID for this habit (using hash code)
    final int notificationId = habitId.hashCode;
    
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
    
    // Schedule notifications for each selected day of the week
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final day = now.add(Duration(days: i));
      final dayOfWeek = _getDayOfWeek(day);
      
      if (daysOfWeek.contains(dayOfWeek)) {
        final scheduledDate = DateTime(
          day.year,
          day.month,
          day.day,
          reminderTime.hour,
          reminderTime.minute,
        );
        
        // Only schedule if the time hasn't passed yet
        if (scheduledDate.isAfter(now)) {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            notificationId + i, // Use different IDs for each day
            'Habit Reminder: $habitName',
            'Don\'t forget to complete your habit today!',
            tz.TZDateTime.from(scheduledDate, tz.local),
            notificationDetails,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: 'habit_$habitId',
          );
        }
      }
    }
  }
  
  /// Cancel habit reminder notifications
  Future<void> cancelHabitReminder(String habitId) async {
    final int baseId = habitId.hashCode;
    
    // Cancel notifications for all days of the week
    for (int i = 0; i < 7; i++) {
      await _flutterLocalNotificationsPlugin.cancel(baseId + i);
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
