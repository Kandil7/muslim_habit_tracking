part of 'prayer_cubit.dart';

sealed class PrayerState {}

final class PrayerInitial extends PrayerState {}

final class GetPrayerSuccess extends PrayerState {}

final class GetPrayerError extends PrayerState {
  final String message;
  GetPrayerError(this.message);
}

final class ChangeTime extends PrayerState {}

final class SetLocationSuccess extends PrayerState {}

final class SetLocationError extends PrayerState {
  final String message;
  SetLocationError(this.message);
}

final class NotificationSettingsChanged extends PrayerState {}
