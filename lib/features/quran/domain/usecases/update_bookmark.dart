import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_bookmark.dart';
import '../repositories/quran_repository.dart';

/// Use case to update a Quran bookmark
class UpdateBookmark implements UseCase<QuranBookmark, UpdateBookmarkParams> {
  final QuranRepository repository;

  UpdateBookmark(this.repository);

  @override
  Future<Either<Failure, QuranBookmark>> call(UpdateBookmarkParams params) {
    return repository.updateBookmark(params.bookmark);
  }
}

/// Parameters for the UpdateBookmark use case
class UpdateBookmarkParams extends Equatable {
  final QuranBookmark bookmark;

  const UpdateBookmarkParams({required this.bookmark});

  @override
  List<Object> get props => [bookmark];
}
