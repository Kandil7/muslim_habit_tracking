import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:logger/logger.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';

import '../../../features/prayer_times/data/models/prayer_item_model.dart';

class PrayerNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Logger _logger = Logger();

  PrayerNotificationService() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    tz_data.initializeTimeZones();

    // Create the notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'prayer_times_channel',
      'Prayer Times',
      description: 'Notifications for prayer times',
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
        _logger.i('Notification tapped: ${response.payload}');
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

    // For Android, check and request exact alarm permission
    if (Platform.isAndroid) {
      await _requestExactAlarmPermission();
    }

    return true;
  }

  Future<void> _requestExactAlarmPermission() async {
    try {
      // Initialize AndroidAlarmManager
      await AndroidAlarmManager.initialize();

      // Check if we can schedule exact alarms
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        // For Android 12+, we need to check and request permission
        final bool? hasExactAlarmPermission =
            await androidImplementation.requestExactAlarmsPermission();

        if (hasExactAlarmPermission != true) {
          _logger.w('Exact alarm permission not granted');
        }
      }
    } catch (e) {
      _logger.e('Error requesting exact alarm permission: $e');
      // If there's an error, we'll try to use inexact alarms instead
    }
  }

  Future<void> schedulePrayerNotification(
    PrayerItemModel prayer,
    int minutesBefore,
  ) async {
    // Parse prayer time
    final List<String> timeParts = prayer.prayerTime.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    // Create notification time
    final DateTime now = DateTime.now();
    final DateTime prayerDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Calculate notification time (minutes before prayer)
    final DateTime notificationTime = prayerDateTime.subtract(
      Duration(minutes: minutesBefore),
    );

    // Only schedule if it's in the future
    if (notificationTime.isAfter(now)) {
      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        notificationTime,
        tz.local,
      );

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
            'prayer_times_channel',
            'Prayer Times',
            channelDescription: 'Notifications for prayer times',
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

      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          prayer.enName.hashCode, // Use prayer name hash as ID
          'Prayer Time Reminder',
          '${prayer.enName} prayer time in $minutesBefore minutes',
          scheduledDate,
          platformChannelSpecifics,
          payload:
              'prayer_${prayer.enName}', // Add payload for handling notification taps
          matchDateTimeComponents: DateTimeComponents.time,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (e) {
        _logger.w('Failed to schedule exact alarm: $e');
        // Fall back to inexact alarms if exact alarms are not permitted
        if (e is PlatformException && e.code == 'exact_alarms_not_permitted') {
          _logger.i('Falling back to inexact alarm for ${prayer.enName}');
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            prayer.enName.hashCode, // Use prayer name hash as ID
            'Prayer Time Reminder',
            '${prayer.enName} prayer time in $minutesBefore minutes',
            scheduledDate,
            platformChannelSpecifics,
            payload:
                'prayer_${prayer.enName}', // Add payload for handling notification taps
            matchDateTimeComponents: DateTimeComponents.time,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          );
        } else {
          // Rethrow if it's not a permission issue
          rethrow;
        }
      }
    }
  }

  Future<void> scheduleAllPrayerNotifications(
    List<PrayerItemModel> prayers,
    int minutesBefore,
  ) async {
    await cancelAllNotifications();
    for (final prayer in prayers) {
      await schedulePrayerNotification(prayer, minutesBefore);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
