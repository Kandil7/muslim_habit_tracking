import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for handling local notifications
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _isInitialized = false;

  /// Constructor
  NotificationService(this._notificationsPlugin);

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize notification settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isInitialized = true;
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await initialize();

    // Request permissions for iOS
    final DarwinNotificationPermission? iosPermission =
        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );

    // Request permissions for Android
    final bool? androidPermission =
        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestPermission();

    return iosPermission == DarwinNotificationPermission.authorized ||
        androidPermission == true;
  }

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'muslim_habbit_channel',
      'Muslim Habbit Notifications',
      channelDescription: 'Notifications for Muslim Habbit app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool repeats = false,
    RepeatInterval? repeatInterval,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'muslim_habbit_scheduled_channel',
      'Muslim Habbit Scheduled Notifications',
      channelDescription: 'Scheduled notifications for Muslim Habbit app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (repeats && repeatInterval != null) {
      // Schedule a repeating notification
      await _notificationsPlugin.periodicallyShow(
        id,
        title,
        body,
        repeatInterval,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } else {
      // Schedule a one-time notification
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
  }

  /// Schedule a daily notification at a specific time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay timeOfDay,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    final effectiveDate = scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'muslim_habbit_daily_channel',
      'Muslim Habbit Daily Notifications',
      channelDescription: 'Daily notifications for Muslim Habbit app',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(timeOfDay),
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  /// Schedule a notification for prayer time
  Future<void> schedulePrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
    int minutesBefore = 15,
  }) async {
    if (!_isInitialized) await initialize();

    final notificationTime =
        prayerTime.subtract(Duration(minutes: minutesBefore));

    // Only schedule if the prayer time is in the future
    if (notificationTime.isAfter(DateTime.now())) {
      await scheduleNotification(
        id: id,
        title: 'Prayer Time Reminder',
        body: '$prayerName prayer time in $minutesBefore minutes',
        scheduledDate: notificationTime,
        payload: 'prayer_$prayerName',
      );
    }
  }

  /// Schedule a notification for a habit reminder
  Future<void> scheduleHabitReminder({
    required int id,
    required String habitName,
    required TimeOfDay reminderTime,
  }) async {
    if (!_isInitialized) await initialize();

    await scheduleDailyNotification(
      id: id,
      title: 'Habit Reminder',
      body: 'Time to complete your habit: $habitName',
      timeOfDay: reminderTime,
      payload: 'habit_$id',
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap based on payload
    if (response.payload != null) {
      final payload = response.payload!;
      
      if (payload.startsWith('prayer_')) {
        // Handle prayer notification tap
        final prayerName = payload.split('_')[1];
        debugPrint('Prayer notification tapped: $prayerName');
      } else if (payload.startsWith('habit_')) {
        // Handle habit notification tap
        final habitId = payload.split('_')[1];
        debugPrint('Habit notification tapped: $habitId');
      }
    }
  }

  /// Get the next instance of a specific time
  tz.TZDateTime _nextInstanceOfTime(TimeOfDay timeOfDay) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
