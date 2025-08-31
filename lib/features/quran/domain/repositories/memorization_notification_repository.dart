import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

/// Repository interface for memorization notifications
abstract class MemorizationNotificationRepository {
  /// Schedule a daily review notification
  Future<Either<Failure, void>> scheduleDailyReviewNotification();

  /// Cancel all memorization notifications
  Future<Either<Failure, void>> cancelAllNotifications();

  /// Set notification preferences
  Future<Either<Failure, void>> setNotificationPreferences({
    required bool enabled,
    required int hour,
    required int minute,
  });

  /// Get notification preferences
  Future<Either<Failure, NotificationPreferences>> getNotificationPreferences();
}

/// Entity representing notification preferences
class NotificationPreferences extends Equatable {
  final bool enabled;
  final int hour;
  final int minute;

  const NotificationPreferences({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  @override
  List<Object?> get props => [enabled, hour, minute];

  /// Creates a copy of this preferences with specified fields replaced
  NotificationPreferences copyWith({
    bool? enabled,
    int? hour,
    int? minute,
  }) {
    return NotificationPreferences(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}