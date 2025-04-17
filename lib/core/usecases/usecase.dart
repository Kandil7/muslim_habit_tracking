import 'package:dartz/dartz.dart';
import 'package:muslim_habbit/core/errors/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// A class representing no parameters for use cases.
class NoParams {}
