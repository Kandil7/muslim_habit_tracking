import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dhikr.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/entities/dua.dart';
import 'package:muslim_habbit/features/dua_dhikr/domain/repositories/dua_dhikr_repository.dart';

part 'dua_dhikr_event.dart';
part 'dua_dhikr_state.dart';

class DuaDhikrBloc extends Bloc<DuaDhikrEvent, DuaDhikrState> {
  final DuaDhikrRepository repository;

  DuaDhikrBloc({required this.repository}) : super(const DuaDhikrInitial()) {
    on<LoadInitialData>(_onLoadInitialData);
    on<LoadDuaCategories>(_onLoadDuaCategories);
    on<LoadDuasByCategory>(_onLoadDuasByCategory);
    on<LoadAllDhikrs>(_onLoadAllDhikrs);
    on<LoadFavoriteDuas>(_onLoadFavoriteDuas);
    on<LoadFavoriteDhikrs>(_onLoadFavoriteDhikrs);
    on<ToggleDuaFavoriteStatus>(_onToggleDuaFavorite);
    on<ToggleDhikrFavoriteStatus>(_onToggleDhikrFavorite);
    on<RefreshData>(_onRefreshData);
  }

  Future<void> _onLoadInitialData(
    LoadInitialData event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(const DataLoading());
    try {
      final categoriesResult = await repository.getDuaCategories();
      final dhikrsResult = await repository.getAllDhikrs();

      categoriesResult.fold(
        (failure) => emit(OperationFailed(failure.message)),
        (categories) {
          dhikrsResult.fold(
            (failure) => emit(OperationFailed(failure.message)),
            (dhikrs) =>
                emit(InitialDataLoaded(categories: categories, dhikrs: dhikrs)),
          );
        },
      );
    } catch (e) {
      emit(OperationFailed('Failed to load initial data: $e'));
    }
  }

  Future<void> _onLoadDuaCategories(
    LoadDuaCategories event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(const DataLoading());
    final result = await repository.getDuaCategories();
    result.fold(
      (failure) => emit(OperationFailed(failure.message)),
      (categories) => emit(DuaCategoriesLoaded(categories)),
    );
  }

  Future<void> _onLoadDuasByCategory(
    LoadDuasByCategory event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(const DataLoading());
    final result = await repository.getDuasByCategory(event.category);
    result.fold(
      (failure) => emit(OperationFailed(failure.message)),
      (duas) => emit(DuasByCategoryLoaded(duas)),
    );
  }

  Future<void> _onLoadAllDhikrs(
    LoadAllDhikrs event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(const DataLoading());
    final result = await repository.getAllDhikrs();
    result.fold(
      (failure) => emit(OperationFailed(failure.message)),
      (dhikrs) => emit(DhikrsLoaded(dhikrs)),
    );
  }

  Future<void> _onLoadFavoriteDuas(
    LoadFavoriteDuas event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(const DataLoading());
    final result = await repository.getFavoriteDuas();
    result.fold(
      (failure) => emit(OperationFailed(failure.message)),
      (duas) => emit(FavoriteDuasLoaded(duas)),
    );
  }

  Future<void> _onLoadFavoriteDhikrs(
    LoadFavoriteDhikrs event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(const DataLoading());
    final result = await repository.getFavoriteDhikrs();
    result.fold(
      (failure) => emit(OperationFailed(failure.message)),
      (dhikrs) => emit(FavoriteDhikrsLoaded(dhikrs)),
    );
  }

  Future<void> _onToggleDuaFavorite(
    ToggleDuaFavoriteStatus event,
    Emitter<DuaDhikrState> emit,
  ) async {
    final result = await repository.toggleDuaFavorite(event.duaId);
    result.fold(
      (failure) => emit(OperationFailed(failure.message)),
      (dua) => emit(DuaFavoriteToggled(dua)),
    );
  }

  Future<void> _onToggleDhikrFavorite(
    ToggleDhikrFavoriteStatus event,
    Emitter<DuaDhikrState> emit,
  ) async {
    final result = await repository.toggleDhikrFavorite(event.dhikrId);
    result.fold(
      (failure) => emit(OperationFailed(failure.message)),
      (dhikr) => emit(DhikrFavoriteToggled(dhikr)),
    );
  }

  Future<void> _onRefreshData(
    RefreshData event,
    Emitter<DuaDhikrState> emit,
  ) async {
    emit(const DataLoading());
    try {
      // Refresh all necessary data
      final categoriesResult = await repository.getDuaCategories();
      final dhikrsResult = await repository.getAllDhikrs();
      final favoriteDuasResult = await repository.getFavoriteDuas();
      final favoriteDhikrsResult = await repository.getFavoriteDhikrs();

      // Combine results
      if (categoriesResult.isRight() &&
          dhikrsResult.isRight() &&
          favoriteDuasResult.isRight() &&
          favoriteDhikrsResult.isRight()) {
        emit(const DataRefreshed());
      } else {
        emit(const OperationFailed('Failed to refresh data'));
      }
    } catch (e) {
      emit(OperationFailed('Refresh failed: $e'));
    }
  }
}
