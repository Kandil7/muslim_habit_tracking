import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muslim_habbit/core/utils/services/notification_service.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';

/// Service to handle memorization notifications
class MemorizationNotificationService {
  final NotificationService _notificationService;

  static const int _dailyReviewNotificationId = 1001;

  MemorizationNotificationService(this._notificationService);

  /// Schedule daily review notification based on user preferences
  Future<void> scheduleDailyReviewNotification(
      MemorizationPreferences preferences) async {
    // Cancel any existing notification
    await _notificationService.cancelNotification(_dailyReviewNotificationId);

    // If notifications are disabled, don't schedule
    if (!preferences.notificationsEnabled ||
        preferences.notificationTime == null) {
      return;
    }

    // Schedule the notification
    await _notificationService.scheduleNotification(
      id: _dailyReviewNotificationId,
      title: 'Quran Memorization Reminder',
      body: 'It\'s time for your daily Quran review!',
      hour: preferences.notificationTime!.hour,
      minute: preferences.notificationTime!.minute,
      repeat: true,
    );
  }

  /// Cancel daily review notification
  Future<void> cancelDailyReviewNotification() async {
    await _notificationService.cancelNotification(_dailyReviewNotificationId);
  }

  /// Show an immediate notification for overdue items
  Future<void> showOverdueNotification(int overdueCount) async {
    await _notificationService.showNotification(
      id: _dailyReviewNotificationId + 1,
      title: 'Overdue Reviews',
      body: 'You have $overdueCount memorized items that need review!',
    );
  }
}
