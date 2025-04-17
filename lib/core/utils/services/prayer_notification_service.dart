import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../../../features/prayer_times/data/models/prayer_item_model.dart';

class PrayerNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  PrayerNotificationService() {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    tz_data.initializeTimeZones();

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

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<bool> requestPermissions() async {
    // Request permissions for iOS
    final DarwinFlutterLocalNotificationsPlugin? iOSImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            DarwinFlutterLocalNotificationsPlugin>();

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

  Future<void> schedulePrayerNotification(
      PrayerItemModel prayer, int minutesBefore) async {
    // Parse prayer time
    final List<String> timeParts = prayer.prayerTime.split(':');
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    // Create notification time
    final DateTime now = DateTime.now();
    final DateTime prayerDateTime = DateTime(
        now.year, now.month, now.day, hour, minute);

    // Calculate notification time (minutes before prayer)
    final DateTime notificationTime = prayerDateTime.subtract(Duration(minutes: minutesBefore));

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

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        prayer.enName.hashCode, // Use prayer name hash as ID
        'Prayer Time Reminder',
        '${prayer.enName} prayer time in $minutesBefore minutes',
        scheduledDate,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> scheduleAllPrayerNotifications(
      List<PrayerItemModel> prayers, int minutesBefore) async {
    await cancelAllNotifications();
    for (final prayer in prayers) {
      await schedulePrayerNotification(prayer, minutesBefore);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
