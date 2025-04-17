import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hadith.dart';
import '../repositories/hadith_repository.dart';

/// Use case to toggle the bookmark status of a hadith
class ToggleHadithBookmark implements UseCase<Hadith, BookmarkParams> {
  final HadithRepository repository;

  /// Creates a new ToggleHadithBookmark use case
  ToggleHadithBookmark(this.repository);

  @override
  Future<Either<Failure, Hadith>> call(BookmarkParams params) {
    return repository.toggleHadithBookmark(params.id);
  }
}

/// Parameters for the ToggleHadithBookmark use case
class BookmarkParams extends Equatable {
  /// The ID of the hadith to toggle bookmark status
  final String id;

  /// Creates a new BookmarkParams instance
  const BookmarkParams({required this.id});

  @override
  List<Object?> get props => [id];
}
