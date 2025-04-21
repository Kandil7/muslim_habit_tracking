import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../entities/dua.dart';
import '../repositories/dua_dhikr_repository.dart';

/// Use case for getting duas by category
class GetDuasByCategory {
  final DuaDhikrRepository repository;

  GetDuasByCategory(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Dua>>> call(
    GetDuasByCategoryParams params,
  ) async {
    return await repository.getDuasByCategory(params.category);
  }
}

/// Parameters for the GetDuasByCategory use case
class GetDuasByCategoryParams extends Equatable {
  final String category;

  const GetDuasByCategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
