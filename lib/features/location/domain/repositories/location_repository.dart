import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/location_entity.dart';

/// Interface for the location repository
abstract class LocationRepository {
  /// Get the current location
  Future<Either<Failure, LocationEntity>> getCurrentLocation({bool useCache = true});
  
  /// Get the saved location
  Future<Either<Failure, LocationEntity>> getSavedLocation({bool useDefaultIfNotFound = false});
  
  /// Save a location
  Future<Either<Failure, void>> saveLocation(LocationEntity location);
  
  /// Get address from coordinates
  Future<Either<Failure, String>> getAddressFromCoordinates(double latitude, double longitude);
  
  /// Get coordinates from address
  Future<Either<Failure, List<LocationEntity>>> getCoordinatesFromAddress(String address);
  
  /// Check if location services are enabled
  Future<Either<Failure, bool>> isLocationServiceEnabled();
  
  /// Request location permission
  Future<Either<Failure, bool>> requestLocationPermission();
  
  /// Get location updates stream
  Stream<Either<Failure, LocationEntity>> getLocationUpdates();
  
  /// Get compass updates stream
  Stream<Either<Failure, double>> getCompassUpdates();
  
  /// Start location tracking
  Future<Either<Failure, void>> startLocationTracking();
  
  /// Stop location tracking
  Future<Either<Failure, void>> stopLocationTracking();
  
  /// Check if location tracking is enabled
  Future<Either<Failure, bool>> isLocationTrackingEnabled();
}
