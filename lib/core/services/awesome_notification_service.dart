// import 'dart:io';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// import '../constants/app_constants.dart';
// import '../theme/app_theme.dart';
// import '../../features/prayer_times/domain/entities/prayer_time.dart';
//
// /// Service for handling local notifications using awesome_notifications
// class AwesomeNotificationService {
//   static final AwesomeNotificationService _instance = AwesomeNotificationService._internal();
//
//   factory AwesomeNotificationService() {
//     return _instance;
//   }
//
//   AwesomeNotificationService._internal();
//
//   /// Initialize the notification service
//   Future<void> init() async {
//     try {
//       await AwesomeNotifications().initialize(
//         null, // no icon for now, will use default
//         [
//           NotificationChannel(
//             channelKey: 'prayer_times_channel',
//             channelName: 'Prayer Times',
//             channelDescription: 'Notifications for prayer times',
//             defaultColor: AppColors.primary,
//             importance: NotificationImportance.High,
//             channelShowBadge: true,
//           ),
//           NotificationChannel(
//             channelKey: 'habit_reminders_channel',
//             channelName: 'Habit Reminders',
//             channelDescription: 'Reminders for habits',
//             defaultColor: AppColors.secondary,
//             importance: NotificationImportance.High,
//             channelShowBadge: true,
//           ),
//           NotificationChannel(
//             channelKey: 'general_channel',
//             channelName: 'General Notifications',
//             channelDescription: 'General app notifications',
//             defaultColor: AppColors.info,
//             importance: NotificationImportance.Default,
//             channelShowBadge: true,
//           ),
//         ],
//       );
//
//       debugPrint('Awesome Notification service initialized successfully');
//     } catch (e) {
//       debugPrint('Error initializing Awesome Notification service: $e');
//     }
//   }
//
//   /// Request notification permissions
//   Future<bool> requestPermissions() async {
//     try {
//       final result = await AwesomeNotifications().requestPermissionToSendNotifications();
//       return result;
//     } catch (e) {
//       debugPrint('Error requesting notification permissions: $e');
//       return false;
//     }
//   }
//
//   /// Schedule prayer time notifications
//   Future<void> schedulePrayerTimeNotifications(
//     PrayerTime prayerTime,
//     int minutesBefore,
//   ) async {
//     try {
//       // Cancel any existing prayer notifications for this day
//       await cancelPrayerNotifications(prayerTime.date);
//
//       // Schedule notifications for each prayer time
//       await _schedulePrayerNotification(
//         id: 1,
//         title: 'Fajr Prayer',
//         body: 'It\'s time for Fajr prayer',
//         scheduledTime: prayerTime.fajr,
//         minutesBefore: minutesBefore,
//       );
//
//       await _schedulePrayerNotification(
//         id: 2,
//         title: 'Dhuhr Prayer',
//         body: 'It\'s time for Dhuhr prayer',
//         scheduledTime: prayerTime.dhuhr,
//         minutesBefore: minutesBefore,
//       );
//
//       await _schedulePrayerNotification(
//         id: 3,
//         title: 'Asr Prayer',
//         body: 'It\'s time for Asr prayer',
//         scheduledTime: prayerTime.asr,
//         minutesBefore: minutesBefore,
//       );
//
//       await _schedulePrayerNotification(
//         id: 4,
//         title: 'Maghrib Prayer',
//         body: 'It\'s time for Maghrib prayer',
//         scheduledTime: prayerTime.maghrib,
//         minutesBefore: minutesBefore,
//       );
//
//       await _schedulePrayerNotification(
//         id: 5,
//         title: 'Isha Prayer',
//         body: 'It\'s time for Isha prayer',
//         scheduledTime: prayerTime.isha,
//         minutesBefore: minutesBefore,
//       );
//
//       debugPrint('Prayer time notifications scheduled successfully');
//     } catch (e) {
//       debugPrint('Error scheduling prayer time notifications: $e');
//     }
//   }
//
//   /// Schedule a single prayer notification
//   Future<void> _schedulePrayerNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     required int minutesBefore,
//   }) async {
//     try {
//       // Calculate notification time (prayer time - minutes before)
//       final notificationTime = scheduledTime.subtract(Duration(minutes: minutesBefore));
//
//       // Don't schedule if the time has already passed
//       if (notificationTime.isBefore(DateTime.now())) {
//         debugPrint('Not scheduling notification for $title as the time has already passed');
//         return;
//       }
//
//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: id,
//           channelKey: 'prayer_times_channel',
//           title: title,
//           body: body,
//           notificationLayout: NotificationLayout.Default,
//           category: NotificationCategory.Reminder,
//           wakeUpScreen: true,
//         ),
//         schedule: NotificationCalendar.fromDate(date: notificationTime),
//       );
//
//       debugPrint('Scheduled notification for $title at ${notificationTime.toString()}');
//     } catch (e) {
//       debugPrint('Error scheduling prayer notification for $title: $e');
//     }
//   }
//
//   /// Cancel prayer notifications for a specific date
//   Future<void> cancelPrayerNotifications(DateTime date) async {
//     try {
//       // Prayer notification IDs are 1-5
//       for (int id = 1; id <= 5; id++) {
//         await AwesomeNotifications().cancel(id);
//       }
//       debugPrint('Cancelled prayer notifications for ${date.toString()}');
//     } catch (e) {
//       debugPrint('Error cancelling prayer notifications: $e');
//     }
//   }
//
//   /// Schedule a habit reminder notification
//   Future<void> scheduleHabitReminder({
//     required String habitId,
//     required String habitName,
//     required TimeOfDay reminderTime,
//     required List<String> daysOfWeek,
//   }) async {
//     try {
//       // Cancel any existing reminders for this habit
//       await cancelHabitReminder(habitId);
//
//       // Create a unique ID for this habit (using hash code)
//       final int notificationId = habitId.hashCode.abs(); // Use absolute value to avoid negative IDs
//
//       // Get the weekday numbers for the selected days
//       final List<int> selectedWeekdays = daysOfWeek.map((day) => _getWeekdayNumber(day)).toList();
//
//       // Schedule notifications for each selected day of the week
//       for (final weekday in selectedWeekdays) {
//         await AwesomeNotifications().createNotification(
//           content: NotificationContent(
//             id: notificationId + weekday,
//             channelKey: 'habit_reminders_channel',
//             title: 'Habit Reminder: $habitName',
//             body: 'Don\'t forget to complete your habit today!',
//             notificationLayout: NotificationLayout.Default,
//             category: NotificationCategory.Reminder,
//           ),
//           schedule: NotificationCalendar(
//             weekday: weekday,
//             hour: reminderTime.hour,
//             minute: reminderTime.minute,
//             second: 0,
//             repeats: true,
//           ),
//         );
//       }
//
//       debugPrint('Habit reminder scheduled for $habitName on ${daysOfWeek.join(", ")}');
//     } catch (e) {
//       debugPrint('Error scheduling habit reminder: $e');
//     }
//   }
//
//   /// Cancel habit reminder notifications
//   Future<void> cancelHabitReminder(String habitId) async {
//     try {
//       final int baseId = habitId.hashCode.abs(); // Use absolute value to avoid negative IDs
//
//       // Cancel notifications for all days of the week
//       for (int i = 0; i < 7; i++) {
//         await AwesomeNotifications().cancel(baseId + i + 1);
//       }
//     } catch (e) {
//       debugPrint('Error canceling habit reminder: $e');
//     }
//   }
//
//   /// Get weekday number from day name
//   int _getWeekdayNumber(String day) {
//     switch (day) {
//       case 'Monday':
//         return 1;
//       case 'Tuesday':
//         return 2;
//       case 'Wednesday':
//         return 3;
//       case 'Thursday':
//         return 4;
//       case 'Friday':
//         return 5;
//       case 'Saturday':
//         return 6;
//       case 'Sunday':
//         return 7;
//       default:
//         return 1; // Default to Monday
//     }
//   }
//
//   /// Show an immediate notification
//   Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     try {
//       await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: 0, // Use ID 0 for immediate notifications
//           channelKey: 'general_channel',
//           title: title,
//           body: body,
//           payload: payload != null ? {'data': payload} : null,
//           notificationLayout: NotificationLayout.Default,
//         ),
//       );
//     } catch (e) {
//       debugPrint('Error showing notification: $e');
//     }
//   }
// }
