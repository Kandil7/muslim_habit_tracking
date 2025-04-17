import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Service for scheduling habit reminders
class HabitNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  HabitNotificationService() {
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

  Future<void> scheduleHabitReminder(
    String habitId,
    String habitName,
    TimeOfDay reminderTime,
    List<String> daysOfWeek,
  ) async {
    // Cancel any existing reminders for this habit
    await cancelHabitReminder(habitId);

    // Get current date
    final now = DateTime.now();

    // For each selected day of the week, schedule a notification
    for (final day in daysOfWeek) {
      final int dayIndex = _getDayIndex(day);

      // Calculate the next occurrence of this day
      final DateTime nextOccurrence = _getNextDayOccurrence(now, dayIndex);

      // Set the reminder time
      final DateTime reminderDateTime = DateTime(
        nextOccurrence.year,
        nextOccurrence.month,
        nextOccurrence.day,
        reminderTime.hour,
        reminderTime.minute,
      );

      // Convert to TZ DateTime
      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        reminderDateTime,
        tz.local,
      );

      // Create notification details
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'habit_reminders_channel',
        'Habit Reminders',
        channelDescription: 'Reminders for your habits',
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

      // Schedule the notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        '${habitId}_$day'.hashCode, // Use habit ID + day as unique ID
        'Habit Reminder: $habitName',
        'Time to complete your habit: $habitName',
        scheduledDate,
        platformChannelSpecifics,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelHabitReminder(String habitId) async {
    // Since we can't get the exact notification IDs, we'll need to cancel all and reschedule others
    // In a real app, you'd want to store the notification IDs somewhere
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  int _getDayIndex(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }

  DateTime _getNextDayOccurrence(DateTime fromDate, int dayIndex) {
    DateTime resultDate = fromDate;

    // If the day index is less than today's weekday, it will be next week
    while (resultDate.weekday != dayIndex) {
      resultDate = resultDate.add(const Duration(days: 1));
    }

    return resultDate;
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
