import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:muslim_habbit/core/utils/services/notification_service.dart';
import 'package:muslim_habbit/features/quran/data/services/memorization_notification_service.dart';
import 'package:muslim_habbit/features/quran/domain/entities/memorization_preferences.dart';

import 'memorization_notification_service_test.mocks.dart';

@GenerateMocks([NotificationService])
void main() {
  late MemorizationNotificationService notificationService;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockNotificationService = MockNotificationService();
    notificationService = MemorizationNotificationService(mockNotificationService);
  });

  group('scheduleDailyReviewNotification', () {
    test('should schedule notification when preferences are valid', () async {
      // Arrange
      final preferences = MemorizationPreferences(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
        notificationsEnabled: true,
        notificationTime: const TimeOfDay(hour: 9, minute: 0),
      );

      // Act
      await notificationService.scheduleDailyReviewNotification(preferences);

      // Assert
      verify(mockNotificationService.cancelNotification(1001)).called(1);
      verify(mockNotificationService.scheduleNotification(
        id: 1001,
        title: 'Quran Memorization Reminder',
        body: 'It\'s time for your daily Quran review!',
        scheduledDate: anyNamed('scheduledDate'),
        repeats: true,
        repeatInterval: RepeatInterval.daily,
      )).called(1);
    });

    test('should not schedule notification when notifications are disabled', () async {
      // Arrange
      final preferences = MemorizationPreferences(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
        notificationsEnabled: false,
      );

      // Act
      await notificationService.scheduleDailyReviewNotification(preferences);

      // Assert
      verify(mockNotificationService.cancelNotification(1001)).called(1);
      verifyNever(mockNotificationService.scheduleNotification(
        id: anyNamed('id'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        scheduledDate: anyNamed('scheduledDate'),
        repeats: anyNamed('repeats'),
        repeatInterval: anyNamed('repeatInterval'),
      ));
    });

    test('should not schedule notification when notification time is null', () async {
      // Arrange
      final preferences = MemorizationPreferences(
        reviewPeriod: 5,
        memorizationDirection: MemorizationDirection.fromBaqarah,
        notificationsEnabled: true,
        notificationTime: null,
      );

      // Act
      await notificationService.scheduleDailyReviewNotification(preferences);

      // Assert
      verify(mockNotificationService.cancelNotification(1001)).called(1);
      verifyNever(mockNotificationService.scheduleNotification(
        id: anyNamed('id'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        scheduledDate: anyNamed('scheduledDate'),
        repeats: anyNamed('repeats'),
        repeatInterval: anyNamed('repeatInterval'),
      ));
    });
  });

  group('cancelDailyReviewNotification', () {
    test('should cancel the daily review notification', () async {
      // Act
      await notificationService.cancelDailyReviewNotification();

      // Assert
      verify(mockNotificationService.cancelNotification(1001)).called(1);
    });
  });

  group('showOverdueNotification', () {
    test('should show overdue notification with correct count', () async {
      // Act
      await notificationService.showOverdueNotification(3);

      // Assert
      verify(mockNotificationService.showNotification(
        id: 1002,
        title: 'Overdue Reviews',
        body: 'You have 3 memorized items that need review!',
      )).called(1);
    });
  });
}