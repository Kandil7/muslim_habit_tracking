import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_points.dart';
import '../../domain/usecases/get_user_points.dart';
import 'user_points_event.dart';
import 'user_points_state.dart';

/// BLoC for managing the UserPoints feature state
class UserPointsBloc extends Bloc<UserPointsEvent, UserPointsState> {
  final GetUserPoints getUserPoints;
  final AddPoints addPoints;

  /// Creates a new UserPointsBloc
  UserPointsBloc({
    required this.getUserPoints,
    required this.addPoints,
  }) : super(UserPointsInitial()) {
    on<LoadUserPointsEvent>(_onLoadUserPoints);
    on<AddPointsEvent>(_onAddPoints);
    on<SpendPointsEvent>(_onSpendPoints);
    on<ResetPointsEvent>(_onResetPoints);
  }

  /// Handle LoadUserPointsEvent
  Future<void> _onLoadUserPoints(
    LoadUserPointsEvent event,
    Emitter<UserPointsState> emit,
  ) async {
    emit(UserPointsLoading());
    final result = await getUserPoints(NoParams());
    result.fold(
      (failure) => emit(UserPointsError(message: failure.message)),
      (userPoints) => emit(UserPointsLoaded(userPoints: userPoints)),
    );
  }

  /// Handle AddPointsEvent
  Future<void> _onAddPoints(
    AddPointsEvent event,
    Emitter<UserPointsState> emit,
  ) async {
    emit(UserPointsLoading());
    final result = await addPoints(
      AddPointsParams(
        points: event.points,
        reason: event.reason,
      ),
    );
    result.fold(
      (failure) => emit(UserPointsError(message: failure.message)),
      (userPoints) => emit(PointsAdded(
        userPoints: userPoints,
        pointsAdded: event.points,
        reason: event.reason,
      )),
    );
  }

  /// Handle SpendPointsEvent
  Future<void> _onSpendPoints(
    SpendPointsEvent event,
    Emitter<UserPointsState> emit,
  ) async {
    emit(UserPointsLoading());
    final result = await addPoints(
      AddPointsParams(
        points: -event.points,
        reason: event.reason,
      ),
    );
    result.fold(
      (failure) => emit(UserPointsError(message: failure.message)),
      (userPoints) => emit(PointsSpent(
        userPoints: userPoints,
        pointsSpent: event.points,
        reason: event.reason,
      )),
    );
  }

  /// Handle ResetPointsEvent
  Future<void> _onResetPoints(
    ResetPointsEvent event,
    Emitter<UserPointsState> emit,
  ) async {
    emit(UserPointsLoading());
    // Reset points by creating a new UserPoints instance
    final result = await addPoints(
      const AddPointsParams(
        points: 0,
        reason: 'Reset points',
      ),
    );
    result.fold(
      (failure) => emit(UserPointsError(message: failure.message)),
      (userPoints) => emit(PointsReset(userPoints: userPoints)),
    );
  }
}
