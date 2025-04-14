part of 'notification_cubit.dart';

sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class ChangeNotificationSuccess extends NotificationState {}
