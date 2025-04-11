import 'package:equatable/equatable.dart';

/// Events for the prayer time feature
abstract class PrayerTimeEvent extends Equatable {
  const PrayerTimeEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to get prayer time for a specific date
class GetPrayerTimeByDateEvent extends PrayerTimeEvent {
  final DateTime date;
  
  const GetPrayerTimeByDateEvent({required this.date});
  
  @override
  List<Object?> get props => [date];
}

/// Event to get prayer times for a date range
class GetPrayerTimesByDateRangeEvent extends PrayerTimeEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  const GetPrayerTimesByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });
  
  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event to update calculation method
class UpdateCalculationMethodEvent extends PrayerTimeEvent {
  final String method;
  
  const UpdateCalculationMethodEvent({required this.method});
  
  @override
  List<Object?> get props => [method];
}

/// Event to get current calculation method
class GetCalculationMethodEvent extends PrayerTimeEvent {}

/// Event to get available calculation methods
class GetAvailableCalculationMethodsEvent extends PrayerTimeEvent {}
