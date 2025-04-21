import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hadith.dart';
import '../repositories/hadith_repository.dart';

/// Use case to get the hadith of the day
class GetHadithOfTheDay implements UseCase<Hadith, NoParams> {
  final HadithRepository repository;

  /// Creates a new GetHadithOfTheDay use case
  GetHadithOfTheDay(this.repository);

  @override
  Future<Either<Failure, Hadith>> call(NoParams params) {
    return repository.getHadithOfTheDay();
  }
}
