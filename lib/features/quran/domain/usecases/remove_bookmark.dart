import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quran_repository.dart';

/// Use case to remove a Quran bookmark
class RemoveBookmark implements UseCase<void, RemoveBookmarkParams> {
  final QuranRepository repository;

  RemoveBookmark(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveBookmarkParams params) {
    return repository.deleteBookmark(params.id);
  }
}

/// Parameters for the RemoveBookmark use case
class RemoveBookmarkParams extends Equatable {
  final int id;

  const RemoveBookmarkParams({required this.id});

  @override
  List<Object> get props => [id];
}
