import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_dhikrs.dart';
import '../../domain/usecases/get_duas_by_category.dart';
import '../../domain/usecases/toggle_dua_favorite.dart';
import 'dua_dhikr_event.dart';
import 'dua_dhikr_state.dart';

/// BLoC for the dua & dhikr feature
class DuaDhikrBloc extends Bloc<DuaDhikrEvent, DuaDhikrState> {
  final GetDuasByCategory getDuasByCategory;
  final GetAllDhikrs getAllDhikrs;
  final ToggleDuaFavorite toggleDuaFavorite;
  
  DuaDhikrBloc({
    required this.getDuasByCategory,
    required this.getAllDhikrs,
    required this.toggleDuaFavorite,
  }) : super(DuaDhikrInitial()) {
    on<GetDuasByCategoryEvent>(_onGetDuasByCategory);
    on<GetAllDhikrsEvent>(_onGetAllDhikrs);
    on<ToggleDuaFavoriteEvent>(_onToggleDuaFavorite);
  }
  
  /// Handle GetDuasByCategoryEvent
  Future<void> _onGetDuasByCategory(
    GetDuasByCategoryEvent event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(DuaDhikrLoading());
    
    final result = await getDuasByCategory(
      GetDuasByCategoryParams(category: event.category),
    );
    
    result.fold(
      (failure) => emit(DuaDhikrError(message: failure.message)),
      (duas) => emit(DuasLoaded(duas: duas)),
    );
  }
  
  /// Handle GetAllDhikrsEvent
  Future<void> _onGetAllDhikrs(
    GetAllDhikrsEvent event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(DuaDhikrLoading());
    
    final result = await getAllDhikrs();
    
    result.fold(
      (failure) => emit(DuaDhikrError(message: failure.message)),
      (dhikrs) => emit(DhikrsLoaded(dhikrs: dhikrs)),
    );
  }
  
  /// Handle ToggleDuaFavoriteEvent
  Future<void> _onToggleDuaFavorite(
    ToggleDuaFavoriteEvent event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(DuaDhikrLoading());
    
    final result = await toggleDuaFavorite(
      ToggleDuaFavoriteParams(id: event.id),
    );
    
    result.fold(
      (failure) => emit(DuaDhikrError(message: failure.message)),
      (dua) => emit(DuaFavoriteToggled(dua: dua)),
    );
  }
}
