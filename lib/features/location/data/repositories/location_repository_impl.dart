import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

/// Implementation of the location repository
class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;
  final NetworkInfo networkInfo;
  
  // Stream controllers
  final _locationStreamController = StreamController<Either<Failure, LocationEntity>>.broadcast();
  final _compassStreamController = StreamController<Either<Failure, double>>.broadcast();
  
  // Stream subscriptions
  StreamSubscription? _locationSubscription;
  StreamSubscription? _compassSubscription;
  
  /// Creates a location repository implementation
  LocationRepositoryImpl({
    required this.locationService,
    required this.networkInfo,
  });
  
  @override
  Future<Either<Failure, LocationEntity>> getCurrentLocation({bool useCache = true}) async {
    try {
      final location = await locationService.getCurrentLocation(useCache: useCache);
      return Right(location);
    } on LocationException catch (e) {
      return Left(LocationFailure(message: e.message));
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, LocationEntity>> getSavedLocation({bool useDefaultIfNotFound = false}) async {
    try {
      final location = await locationService.getSavedLocation(useDefaultIfNotFound: useDefaultIfNotFound);
      return Right(location);
    } on LocationException catch (e) {
      return Left(LocationFailure(message: e.message));
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> saveLocation(LocationEntity location) async {
    try {
      await locationService.saveLocation(LocationModel.fromEntity(location));
      return const Right(null);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, String>> getAddressFromCoordinates(double latitude, double longitude) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    
    try {
      final address = await locationService.getAddressFromCoordinates(latitude, longitude);
      return Right(address);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, List<LocationEntity>>> getCoordinatesFromAddress(String address) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    
    try {
      final locations = await locationService.getCoordinatesFromAddress(address);
      return Right(locations);
    } on LocationException catch (e) {
      return Left(LocationFailure(message: e.message));
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isLocationServiceEnabled() async {
    try {
      final isEnabled = await locationService.isLocationServiceEnabled();
      return Right(isEnabled);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final permission = await locationService.requestPermission();
      final isGranted = permission == LocationPermission.always || 
                        permission == LocationPermission.whileInUse;
      return Right(isGranted);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Stream<Either<Failure, LocationEntity>> getLocationUpdates() {
    return _locationStreamController.stream;
  }
  
  @override
  Stream<Either<Failure, double>> getCompassUpdates() {
    return _compassStreamController.stream;
  }
  
  @override
  Future<Either<Failure, void>> startLocationTracking() async {
    try {
      // Check if location services are enabled
      final isEnabled = await locationService.isLocationServiceEnabled();
      if (!isEnabled) {
        return Left(LocationFailure(message: 'Location services are disabled'));
      }
      
      // Check location permissions
      final permission = await locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestPermission = await locationService.requestPermission();
        if (requestPermission == LocationPermission.denied) {
          return Left(LocationFailure(message: 'Location permissions are denied'));
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return Left(LocationFailure(message: 'Location permissions are permanently denied'));
      }
      
      // Stop any existing subscriptions
      await stopLocationTracking();
      
      // Start location tracking
      _locationSubscription = locationService.getPositionStream().listen(
        (location) {
          _locationStreamController.add(Right(location));
        },
        onError: (error) {
          _locationStreamController.add(Left(LocationFailure(message: error.toString())));
        },
      );
      
      // Start compass tracking
      final compassStream = locationService.getCompassStream();
      if (compassStream != null) {
        _compassSubscription = compassStream.listen(
          (heading) {
            _compassStreamController.add(Right(heading));
          },
          onError: (error) {
            _compassStreamController.add(Left(LocationFailure(message: error.toString())));
          },
        );
      }
      
      // Save tracking state
      await locationService.setLocationTrackingEnabled(true);
      
      return const Right(null);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> stopLocationTracking() async {
    try {
      // Cancel subscriptions
      await _locationSubscription?.cancel();
      _locationSubscription = null;
      
      await _compassSubscription?.cancel();
      _compassSubscription = null;
      
      // Save tracking state
      await locationService.setLocationTrackingEnabled(false);
      
      return const Right(null);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isLocationTrackingEnabled() async {
    try {
      final isEnabled = locationService.isLocationTrackingEnabled();
      return Right(isEnabled);
    } catch (e) {
      return Left(LocationFailure(message: e.toString()));
    }
  }
  
  /// Dispose of resources
  void dispose() {
    _locationSubscription?.cancel();
    _compassSubscription?.cancel();
    _locationStreamController.close();
    _compassStreamController.close();
  }
}
