import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reading_history.dart';
import '../repositories/quran_repository.dart';

/// Use case to add reading history
class AddReadingHistory implements UseCase<QuranReadingHistory, ReadingHistoryParams> {
  final QuranRepository repository;

  AddReadingHistory(this.repository);

  @override
  Future<Either<Failure, QuranReadingHistory>> call(ReadingHistoryParams params) async {
    return await repository.addReadingHistory(params.history);
  }
}

/// Parameters for the AddReadingHistory use case
class ReadingHistoryParams extends Equatable {
  final QuranReadingHistory history;

  const ReadingHistoryParams({required this.history});

  @override
  List<Object?> get props => [history];
}
