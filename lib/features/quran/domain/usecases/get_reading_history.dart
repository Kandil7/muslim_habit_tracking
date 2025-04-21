import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_reading_history.dart';
import '../repositories/quran_reading_history_repository.dart';

/// Use case for getting all reading history entries
class GetReadingHistory implements UseCase<List<QuranReadingHistory>, NoParams> {
  /// Repository instance
  final QuranReadingHistoryRepository repository;

  /// Constructor
  const GetReadingHistory(this.repository);

  @override
  Future<Either<Failure, List<QuranReadingHistory>>> call(NoParams params) async {
    return await repository.getReadingHistory();
  }
}
