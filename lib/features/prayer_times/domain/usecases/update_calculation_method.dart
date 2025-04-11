import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/prayer_time_repository.dart';

/// Use case for updating the calculation method
class UpdateCalculationMethod {
  final PrayerTimeRepository repository;

  UpdateCalculationMethod(this.repository);

  /// Execute the use case
  Future<Either<Failure, void>> call(UpdateCalculationMethodParams params) async {
    return await repository.updateCalculationMethod(params.method);
  }
}

/// Parameters for the UpdateCalculationMethod use case
class UpdateCalculationMethodParams extends Equatable {
  final String method;

  const UpdateCalculationMethodParams({required this.method});

  @override
  List<Object> get props => [method];
}
