import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_history.dart';
import '../repositories/quran_repository.dart';

/// Use case to get reading history
class GetReadingHistory implements UseCase<List<QuranReadingHistory>, NoParams> {
  final QuranRepository repository;

  GetReadingHistory(this.repository);

  @override
  Future<Either<Failure, List<QuranReadingHistory>>> call(NoParams params) async {
    return await repository.getReadingHistory();
  }
}
