import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quran_repository.dart';

/// Use case to remove a bookmark
class RemoveBookmark implements UseCase<bool, RemoveBookmarkParams> {
  final QuranRepository repository;

  RemoveBookmark(this.repository);

  @override
  Future<Either<Failure, bool>> call(RemoveBookmarkParams params) async {
    return await repository.removeBookmark(params.bookmarkId);
  }
}

/// Parameters for the RemoveBookmark use case
class RemoveBookmarkParams extends Equatable {
  final String bookmarkId;

  const RemoveBookmarkParams({required this.bookmarkId});

  @override
  List<Object?> get props => [bookmarkId];
}
