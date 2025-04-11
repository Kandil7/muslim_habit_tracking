import 'package:equatable/equatable.dart';

import '../../domain/entities/prayer_time.dart';

/// States for the prayer time feature
abstract class PrayerTimeState extends Equatable {
  const PrayerTimeState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class PrayerTimeInitial extends PrayerTimeState {}

/// Loading state
class PrayerTimeLoading extends PrayerTimeState {}

/// State when prayer time is loaded
class PrayerTimeLoaded extends PrayerTimeState {
  final PrayerTime prayerTime;
  
  const PrayerTimeLoaded({required this.prayerTime});
  
  @override
  List<Object?> get props => [prayerTime];
}

/// State when prayer times are loaded
class PrayerTimesLoaded extends PrayerTimeState {
  final List<PrayerTime> prayerTimes;
  
  const PrayerTimesLoaded({required this.prayerTimes});
  
  @override
  List<Object?> get props => [prayerTimes];
}

/// State when calculation method is loaded
class CalculationMethodLoaded extends PrayerTimeState {
  final String calculationMethod;
  
  const CalculationMethodLoaded({required this.calculationMethod});
  
  @override
  List<Object?> get props => [calculationMethod];
}

/// State when available calculation methods are loaded
class AvailableCalculationMethodsLoaded extends PrayerTimeState {
  final Map<String, String> calculationMethods;
  
  const AvailableCalculationMethodsLoaded({required this.calculationMethods});
  
  @override
  List<Object?> get props => [calculationMethods];
}

/// State when calculation method is updated
class CalculationMethodUpdated extends PrayerTimeState {}

/// Error state
class PrayerTimeError extends PrayerTimeState {
  final String message;
  
  const PrayerTimeError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
