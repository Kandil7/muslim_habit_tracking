import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/dhikr.dart';
import '../repositories/dua_dhikr_repository.dart';

/// Use case for toggling a dhikr's favorite status
class ToggleDhikrFavorite {
  final DuaDhikrRepository repository;

  ToggleDhikrFavorite(this.repository);

  /// Execute the use case
  Future<Either<Failure, Dhikr>> call(ToggleDhikrFavoriteParams params) async {
    return await repository.toggleDhikrFavorite(params.id);
  }
}

/// Parameters for the ToggleDhikrFavorite use case
class ToggleDhikrFavoriteParams extends Equatable {
  final String id;

  const ToggleDhikrFavoriteParams({required this.id});

  @override
  List<Object> get props => [id];
}
