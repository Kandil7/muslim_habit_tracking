import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/dua.dart';
import '../repositories/dua_dhikr_repository.dart';

/// Use case for toggling a dua's favorite status
class ToggleDuaFavorite {
  final DuaDhikrRepository repository;

  ToggleDuaFavorite(this.repository);

  /// Execute the use case
  Future<Either<Failure, Dua>> call(ToggleDuaFavoriteParams params) async {
    return await repository.toggleDuaFavorite(params.id);
  }
}

/// Parameters for the ToggleDuaFavorite use case
class ToggleDuaFavoriteParams extends Equatable {
  final String id;

  const ToggleDuaFavoriteParams({required this.id});

  @override
  List<Object> get props => [id];
}
