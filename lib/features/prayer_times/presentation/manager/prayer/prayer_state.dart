part of 'prayer_cubit.dart';

sealed class PrayerState {}

final class PrayerInitial extends PrayerState {}

final class GetPrayerSuccess extends PrayerState {}

final class ChangeTime extends PrayerState {}

final class SetLocationSuccess extends PrayerState {}
