import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/quran_bookmark_repository.dart';

/// Parameters for removing a bookmark
class RemoveBookmarkParams {
  /// ID of the bookmark to remove
  final int id;

  /// Constructor
  const RemoveBookmarkParams({required this.id});
}

/// Use case for removing a bookmark
class RemoveBookmark implements UseCase<void, RemoveBookmarkParams> {
  /// Repository instance
  final QuranBookmarkRepository repository;

  /// Constructor
  const RemoveBookmark(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveBookmarkParams params) async {
    return await repository.removeBookmark(params.id);
  }
}
