import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_reading_history.dart';
import '../repositories/quran_repository.dart';

/// Use case to add a Quran reading history entry
class AddReadingHistory implements UseCase<QuranReadingHistory, AddReadingHistoryParams> {
  final QuranRepository repository;

  AddReadingHistory(this.repository);

  @override
  Future<Either<Failure, QuranReadingHistory>> call(AddReadingHistoryParams params) {
    return repository.addReadingHistory(params.history);
  }
}

/// Parameters for the AddReadingHistory use case
class AddReadingHistoryParams extends Equatable {
  final QuranReadingHistory history;

  const AddReadingHistoryParams({required this.history});

  @override
  List<Object> get props => [history];
}
