import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/quran_bookmark.dart';
import '../repositories/quran_repository.dart';

/// Use case to add a Quran bookmark
class AddBookmark implements UseCase<QuranBookmark, AddBookmarkParams> {
  final QuranRepository repository;

  AddBookmark(this.repository);

  @override
  Future<Either<Failure, QuranBookmark>> call(AddBookmarkParams params) {
    return repository.addBookmark(params.bookmark);
  }
}

/// Parameters for the AddBookmark use case
class AddBookmarkParams extends Equatable {
  final QuranBookmark bookmark;

  const AddBookmarkParams({required this.bookmark});

  @override
  List<Object> get props => [bookmark];
}
