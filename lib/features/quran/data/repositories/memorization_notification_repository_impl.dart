import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/memorization_notification_repository.dart';
import '../services/memorization_notification_service.dart';

/// Implementation of MemorizationNotificationRepository
class MemorizationNotificationRepositoryImpl
    implements MemorizationNotificationRepository {
  final MemorizationNotificationService notificationService;
  final SharedPreferences sharedPreferences;

  MemorizationNotificationRepositoryImpl({
    required this.notificationService,
    required this.sharedPreferences,
  });

  static const String _notificationEnabledKey = 'memorization_notification_enabled';
  static const String _notificationHourKey = 'memorization_notification_hour';
  static const String _notificationMinuteKey = 'memorization_notification_minute';

  @override
  Future<Either<Failure, void>> scheduleDailyReviewNotification() async {
    try {
      final isEnabled = sharedPreferences.getBool(_notificationEnabledKey) ?? true;
      if (!isEnabled) return const Right(null);

      final hour = sharedPreferences.getInt(_notificationHourKey) ?? 19; // Default 7 PM
      final minute = sharedPreferences.getInt(_notificationMinuteKey) ?? 0;

      await notificationService.scheduleDailyReviewNotification(
        const MemorizationPreferences(
          reviewPeriod: 5,
          memorizationDirection: MemorizationDirection.fromBaqarah,
          notificationsEnabled: true,
          notificationTime: TimeOfDay(hour: hour, minute: minute),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to schedule daily review notification'));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAllNotifications() async {
    try {
      await notificationService.cancelDailyReviewNotification();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to cancel notifications'));
    }
  }

  @override
  Future<Either<Failure, void>> setNotificationPreferences({
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    try {
      await sharedPreferences.setBool(_notificationEnabledKey, enabled);
      await sharedPreferences.setInt(_notificationHourKey, hour);
      await sharedPreferences.setInt(_notificationMinuteKey, minute);

      // Reschedule notifications with new preferences
      if (enabled) {
        await notificationService.scheduleDailyReviewNotification(
          MemorizationPreferences(
            reviewPeriod: 5,
            memorizationDirection: MemorizationDirection.fromBaqarah,
            notificationsEnabled: true,
            notificationTime: TimeOfDay(hour: hour, minute: minute),
          ),
        );
      } else {
        await notificationService.cancelDailyReviewNotification();
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to set notification preferences'));
    }
  }

  @override
  Future<Either<Failure, NotificationPreferences>> getNotificationPreferences() async {
    try {
      final enabled = sharedPreferences.getBool(_notificationEnabledKey) ?? true;
      final hour = sharedPreferences.getInt(_notificationHourKey) ?? 19; // Default 7 PM
      final minute = sharedPreferences.getInt(_notificationMinuteKey) ?? 0;

      return Right(NotificationPreferences(
        enabled: enabled,
        hour: hour,
        minute: minute,
      ));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get notification preferences'));
    }
  }
}