import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran.dart';
import '../repositories/quran_repository.dart';

/// Use case to get all surahs
class GetAllSurahs implements UseCase<List<Quran>, NoParams> {
  final QuranRepository repository;

  GetAllSurahs(this.repository);

  @override
  Future<Either<Failure, List<Quran>>> call(NoParams params) async {
    return await repository.getAllSurahs();
  }
}
