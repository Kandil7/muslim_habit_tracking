import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../features/notification/data/models/notification_model.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> _onTap(NotificationResponse details) async {}

  Future<void> initNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _flutterLocalNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse: _onTap,
    );

    await _checkNotificationPermission();
  }

  Future<void> scheduledNotification(
      NotificationModel notificationModel) async {
    NotificationDetails notificationDetails = _setNotificationDetails();
    await _setTimeZone();

    int notificationId = _getNotificationId(DateTime.now());

    await _flutterLocalNotifications.zonedSchedule(
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
              3),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
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
    NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails("Jumaa", "Jumaa",
            priority: Priority.high, importance: Importance.max),
        iOS: DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true));
    return notificationDetails;
  }

  Future<void> _checkNotificationPermission() async {
    final androidStatus =
        _flutterLocalNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final iOSStatus =
        _flutterLocalNotifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    bool? androidPermission = await androidStatus?.areNotificationsEnabled();
    final iOSPermission = await iOSStatus?.checkPermissions();

    if (androidPermission == null || androidPermission == false) {
      await androidStatus?.requestNotificationsPermission();
    }

    if (iOSPermission == null || !iOSPermission.isEnabled) {
      await iOSStatus?.requestPermissions();
    }
  }

  Future<void> cancleNotification(int id) async {
    await _flutterLocalNotifications.cancel(id);
  }
}
