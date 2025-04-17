import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/bookmark.dart';
import '../repositories/quran_repository.dart';

/// Use case to add a bookmark
class AddBookmark implements UseCase<QuranBookmark, BookmarkParams> {
  final QuranRepository repository;

  AddBookmark(this.repository);

  @override
  Future<Either<Failure, QuranBookmark>> call(BookmarkParams params) async {
    return await repository.addBookmark(params.bookmark);
  }
}

/// Parameters for the AddBookmark use case
class BookmarkParams extends Equatable {
  final QuranBookmark bookmark;

  const BookmarkParams({required this.bookmark});

  @override
  List<Object?> get props => [bookmark];
}
