import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hadith.dart';
import '../repositories/hadith_repository.dart';

/// Use case to get all hadiths
class GetAllHadiths implements UseCase<List<Hadith>, void> {
  final HadithRepository repository;

  /// Creates a new GetAllHadiths use case
  GetAllHadiths(this.repository);

  @override
  Future<Either<Failure, List<Hadith>>> call(void params) {
    return repository.getAllHadiths();
  }
}
