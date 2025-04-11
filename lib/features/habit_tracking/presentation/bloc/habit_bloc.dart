import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_habit.dart';
import '../../domain/usecases/create_habit_log.dart';
import '../../domain/usecases/delete_habit.dart';
import '../../domain/usecases/get_habit_logs_by_date_range.dart';
import '../../domain/usecases/get_habits.dart';
import '../../domain/usecases/update_habit.dart';
import 'habit_event.dart';
import 'habit_state.dart';

/// BLoC for the habit feature
class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final GetHabits getHabits;
  final CreateHabit createHabit;
  final UpdateHabit updateHabit;
  final DeleteHabit deleteHabit;
  final GetHabitLogsByDateRange getHabitLogsByDateRange;
  final CreateHabitLog createHabitLog;

  HabitBloc({
    required this.getHabits,
    required this.createHabit,
    required this.updateHabit,
    required this.deleteHabit,
    required this.getHabitLogsByDateRange,
    required this.createHabitLog,
  }) : super(HabitInitial()) {
    on<GetHabitsEvent>(_onGetHabits);
    on<CreateHabitEvent>(_onCreateHabit);
    on<UpdateHabitEvent>(_onUpdateHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
    on<GetHabitLogsByDateRangeEvent>(_onGetHabitLogsByDateRange);
    on<CreateHabitLogEvent>(_onCreateHabitLog);
  }

  /// Handle GetHabitsEvent
  Future<void> _onGetHabits(
    GetHabitsEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await getHabits();

    result.fold(
      (failure) => emit(HabitError(message: failure.message)),
      (habits) => emit(HabitsLoaded(habits: habits)),
    );
  }

  /// Handle CreateHabitEvent
  Future<void> _onCreateHabit(
    CreateHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await createHabit(CreateHabitParams(habit: event.habit));

    result.fold(
      (failure) => emit(HabitError(message: failure.message)),
      (habit) => emit(HabitCreated(habit: habit)),
    );
  }

  /// Handle UpdateHabitEvent
  Future<void> _onUpdateHabit(
    UpdateHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await updateHabit(UpdateHabitParams(habit: event.habit));

    result.fold(
      (failure) => emit(HabitError(message: failure.message)),
      (habit) => emit(HabitUpdated(habit: habit)),
    );
  }

  /// Handle DeleteHabitEvent
  Future<void> _onDeleteHabit(
    DeleteHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await deleteHabit(DeleteHabitParams(id: event.id));

    result.fold(
      (failure) => emit(HabitError(message: failure.message)),
      (_) => emit(HabitDeleted()),
    );
  }

  /// Handle GetHabitLogsByDateRangeEvent
  Future<void> _onGetHabitLogsByDateRange(
    GetHabitLogsByDateRangeEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await getHabitLogsByDateRange(
      GetHabitLogsByDateRangeParams(
        habitId: event.habitId,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    result.fold(
      (failure) => emit(HabitError(message: failure.message)),
      (habitLogs) => emit(HabitLogsLoaded(habitLogs: habitLogs)),
    );
  }

  /// Handle CreateHabitLogEvent
  Future<void> _onCreateHabitLog(
    CreateHabitLogEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(HabitLoading());

    final result = await createHabitLog(
      CreateHabitLogParams(habitLog: event.habitLog),
    );

    result.fold(
      (failure) => emit(HabitError(message: failure.message)),
      (habitLog) => emit(HabitLogCreated(habitLog: habitLog)),
    );
  }
}
