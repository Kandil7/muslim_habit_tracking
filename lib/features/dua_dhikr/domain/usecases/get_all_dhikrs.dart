import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/dhikr.dart';
import '../repositories/dua_dhikr_repository.dart';

/// Use case for getting all dhikrs
class GetAllDhikrs {
  final DuaDhikrRepository repository;

  GetAllDhikrs(this.repository);

  /// Execute the use case
  Future<Either<Failure, List<Dhikr>>> call() async {
    return await repository.getAllDhikrs();
  }
}
