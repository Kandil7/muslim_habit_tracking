import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quran_repository.dart';

/// Use case to clear Quran reading history
class ClearReadingHistory implements UseCase<void, NoParams> {
  final QuranRepository repository;

  ClearReadingHistory(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearReadingHistory();
  }
}
