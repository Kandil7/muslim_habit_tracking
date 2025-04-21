import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../features/notification/data/models/notification_model.dart';

/// Service for handling local notifications
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Initialize timezone
    await _setTimeZone();

    // Initialize notification settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher_icon");

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

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );

    await _checkNotificationPermission();
    _isInitialized = true;
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (!_isInitialized) await initNotification();

    // Request permissions for iOS
    final bool? iosPermission = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Request permissions for Android
    final bool? androidPermission =
        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();

    return iosPermission == true || androidPermission == true;
  }

  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initNotification();

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

  /// Schedule a notification using the NotificationModel
  Future<void> scheduledNotification(
    NotificationModel notificationModel,
  ) async {
    if (!_isInitialized) await initNotification();

    NotificationDetails notificationDetails = _setNotificationDetails();

    int notificationId = _getNotificationId(DateTime.now());

    await _notificationsPlugin.zonedSchedule(
      notificationModel.id ?? notificationId,
      notificationModel.title,
      notificationModel.body,
      notificationModel.scheduledDate ??
          tz.TZDateTime(
            tz.local,
            notificationModel.date!.year,
            notificationModel.date!.month,
            notificationModel.date!.day,
            notificationModel.date!.hour,
            notificationModel.date!.minute,
            3,
          ),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
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
    if (!_isInitialized) await initNotification();

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
    if (!_isInitialized) await initNotification();

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

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
    if (!_isInitialized) await initNotification();

    final notificationTime = prayerTime.subtract(
      Duration(minutes: minutesBefore),
    );

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
    if (!_isInitialized) await initNotification();

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

  /// Alias for cancelNotification to maintain backward compatibility
  Future<void> cancleNotification(int id) async {
    await cancelNotification(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Handle notification tap
  static Future<void> _onNotificationTap(NotificationResponse response) async {
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

  int _getNotificationId(DateTime date) {
    int notificationId = date.millisecondsSinceEpoch.remainder(100000);
    return notificationId;
  }

  Future<void> _setTimeZone() async {
    tz.initializeTimeZones();

    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  NotificationDetails _setNotificationDetails() {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        "muslim_habbit_channel",
        "Muslim Habbit Notifications",
        channelDescription: "Notifications for Muslim Habbit app",
        priority: Priority.high,
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    return notificationDetails;
  }

  Future<void> _checkNotificationPermission() async {
    final androidStatus =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    final iOSStatus =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    bool? androidPermission = await androidStatus?.areNotificationsEnabled();
    final iOSPermission = await iOSStatus?.checkPermissions();

    if (androidPermission == null || androidPermission == false) {
      await androidStatus?.requestNotificationsPermission();
    }

    if (iOSPermission == null || !iOSPermission.isEnabled) {
      await iOSStatus?.requestPermissions();
    }
  }
}
