import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_prayer_time_by_date.dart';
import '../../domain/usecases/get_prayer_times_by_date_range.dart';
import '../../domain/usecases/update_calculation_method.dart';
import 'prayer_time_event.dart';
import 'prayer_time_state.dart';

/// BLoC for the prayer time feature
class PrayerTimeBloc extends Bloc<PrayerTimeEvent, PrayerTimeState> {
  final GetPrayerTimeByDate getPrayerTimeByDate;
  final GetPrayerTimesByDateRange getPrayerTimesByDateRange;
  final UpdateCalculationMethod updateCalculationMethod;
  
  PrayerTimeBloc({
    required this.getPrayerTimeByDate,
    required this.getPrayerTimesByDateRange,
    required this.updateCalculationMethod,
  }) : super(PrayerTimeInitial()) {
    on<GetPrayerTimeByDateEvent>(_onGetPrayerTimeByDate);
    on<GetPrayerTimesByDateRangeEvent>(_onGetPrayerTimesByDateRange);
    on<UpdateCalculationMethodEvent>(_onUpdateCalculationMethod);
  }
  
  /// Handle GetPrayerTimeByDateEvent
  Future<void> _onGetPrayerTimeByDate(
    GetPrayerTimeByDateEvent event,
    Emitter<PrayerTimeState> emit,
  ) async {
    emit(PrayerTimeLoading());
    
    final result = await getPrayerTimeByDate(
      GetPrayerTimeByDateParams(date: event.date),
    );
    
    result.fold(
      (failure) => emit(PrayerTimeError(message: failure.message)),
      (prayerTime) => emit(PrayerTimeLoaded(prayerTime: prayerTime)),
    );
  }
  
  /// Handle GetPrayerTimesByDateRangeEvent
  Future<void> _onGetPrayerTimesByDateRange(
    GetPrayerTimesByDateRangeEvent event,
    Emitter<PrayerTimeState> emit,
  ) async {
    emit(PrayerTimeLoading());
    
    final result = await getPrayerTimesByDateRange(
      GetPrayerTimesByDateRangeParams(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    
    result.fold(
      (failure) => emit(PrayerTimeError(message: failure.message)),
      (prayerTimes) => emit(PrayerTimesLoaded(prayerTimes: prayerTimes)),
    );
  }
  
  /// Handle UpdateCalculationMethodEvent
  Future<void> _onUpdateCalculationMethod(
    UpdateCalculationMethodEvent event,
    Emitter<PrayerTimeState> emit,
  ) async {
    emit(PrayerTimeLoading());
    
    final result = await updateCalculationMethod(
      UpdateCalculationMethodParams(method: event.method),
    );
    
    result.fold(
      (failure) => emit(PrayerTimeError(message: failure.message)),
      (_) => emit(CalculationMethodUpdated()),
    );
  }
}
