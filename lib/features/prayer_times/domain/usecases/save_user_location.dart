import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/prayer_times_repository.dart';

/// Use case to save user location
class SaveUserLocation implements UseCase<bool, SaveUserLocationParams> {
  final PrayerTimesRepository repository;

  /// Creates a new SaveUserLocation use case
  SaveUserLocation(this.repository);

  @override
  Future<Either<Failure, bool>> call(SaveUserLocationParams params) {
    return repository.saveUserLocation(
      city: params.city,
      country: params.country,
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

/// Parameters for SaveUserLocation use case
class SaveUserLocationParams extends Equatable {
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;

  /// Creates new SaveUserLocationParams
  const SaveUserLocationParams({
    this.city,
    this.country,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [city, country, latitude, longitude];
}
